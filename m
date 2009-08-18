Return-Path: <linux-kernel-owner+w=401wt.eu-S1752386AbZHRXyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbZHRXyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZHRXyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:54:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:62809 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbZHRXyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:54:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fZsLYm0+g1V7D2cFySCe4oBsdEfLbOr2E6dr+zBzpcJGLiNbdn/xqijuF43mUYYspP
         1RdaNDTceJA8wYpog6/k1o19OMoX29r+0M6d8wM9xBfai0wH3qf9GFY+EJmHYHspHef+
         f1/mVOwVD/IykN73YvcCSZJbeKvAoCChOi0N4=
Message-ID: <4A8B3F69.2020104@gmail.com>
Date: Tue, 18 Aug 2009 16:55:21 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: system gets stuck in a lock during boot
References: <4A84345D.60506@gmail.com> <20090818104905.GC5231@nowhere>  <20090818160911.GA21243@goodmis.org> <dd18b0c30908180924n3848d32ave258f98a5f703c38@mail.gmail.com> <alpine.DEB.2.00.0908181926410.28398@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0908181926410.28398@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Tue, 18 Aug 2009, Justin Mattock wrote:
>
>    
>> On Tue, Aug 18, 2009 at 9:09 AM, Steven Rostedt<rostedt@goodmis.org>  wrote:
>>      
>>> On Tue, Aug 18, 2009 at 12:49:06PM +0200, Frederic Weisbecker wrote:
>>>        
>>>> On Thu, Aug 13, 2009 at 08:42:21AM -0700, Justin P. Mattock wrote:
>>>>          
>>>>> I posted already and had no reply,
>>>>> I cannot boot my system with the latest git
>>>>>
>>>>> seems to be stuck in some lock:
>>>>>            
>
> BTW, it does not look like it got stuck in a lock. The backtrace shows
> that it paniced inside event_create_dir due to a bad pointer.
>
>    
>>>>> [   0.655640] [<ffffffff81440c33>] panic+0x84/0x129
>>>>> [   0.655883] [<ffffffff81063f96>]  do_exit+0x84/0x67e
>>>>> [   0.656125] [<ffffffff81445044>] oops_end+0x9c/0xb7
>>>>> [   0.656368] [<ffffffff81044a6c>] no_context+0x200/0x223
>>>>> [   0.656611] [<ffffffff81442d3d>] ? __mutex_lock_slowpath+0x226/0x249
>>>>> [   0.656848] [<ffffffff81044c36>] __bad_area_nosemaphore+0x1a7/0x1e1
>>>>> [   0.657097] [<ffffffff81442b01>]? mutex_unlock+0x1c/0x32
>>>>> [   0.657097] [<ffffffff811ce094>] ? inode_doinit_with_dentry+0x533/0x5be
>>>>> [   0.657579] [<ffffffff81443ee0>] ? _spin_unlock+0x1c/0x32
>>>>> [   0.657822] [<ffffffff81044c91>] bad_area_nosemaphore+0x2a/0x40
>>>>> [   0.658066] [<ffffffff811ce149>] ? selinux_d_instantiate+0x2a/0x40
>>>>> [   0.658309] [<ffffffff8144687d>] do_page_fault+0x192/0x2dd
>>>>> [   0.658549] [<ffffffff814444cf>] page_fault+0x1f/0x30
>>>>> [   0.658791] [<ffffffff8120e856>] ? strcmp+0x17/0x46
>>>>> [   0.659040] [<ffffffff810b9ca0>] event_create_dir+0x49/0x37b
>>>>>            
>>>>
>>>> Ouch...
>>>>
>>>> I've never seen such panic. Could you send me your config, hopefully
>>>> I could reproduce it?
>>>>          
>>> Send me the config too please.
>>>
>>> -- Steve
>>>
>>>
>>>        
>> yeah this happens with rc6 but not with rc5.
>>
>> The system is a linux from scratch build
>> x86_64 I used these flags for building everything:
>>
>>   CFLAGS=" -m64 -mtune=core2 -march=core2 -mfpmath=both  -O2 -pipe
>>   -fomit-frame-pointer -fstack-protector" CXXFLAGS="${CFLAGS}" MAKEOPTS="{-j3}"
>>
>> also:  I have a macbook(not x86_64) that is running rc6 that seems
>> to be fine.(I can double check).
>>
>> attached is .config, dmesg as well.
>>      
>
> BTW, how did you get the dmesg? Is it from a clean boot?
>
> Since it works fine in -rc5 but breaks in -rc6, could you do a git bisect
> on it? It shouldn't take too long.
>
> Thanks,
>
> -- Steve
>
>    
dmesg is from rc5 figured it would be good to
send that.

as for whatever is happening with this  I don't really know.


The problem with doing a git bisect is these kernels
are tar.balls although I do have a fresh pulled
tree which might work.
  if not Ill just start reverting
commits from the web interface until she boots properly.
(luckily its from rc5 to rc6)

At the moment I'm trying to get the grub2 properly configured
so I can get more of this message on the screen. and then manually
write it down.
(have to learn the new gfxload thing).

Justin P. Mattock
