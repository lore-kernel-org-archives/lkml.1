Return-Path: <linux-kernel-owner+w=401wt.eu-S1763716AbZAOTmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763716AbZAOTmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 14:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757422AbZAOTmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 14:42:22 -0500
Received: from mail.gmx.net ([213.165.64.20]:40002 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757308AbZAOTmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 14:42:22 -0500
X-Authenticated: #4875094
X-Provags-ID: V01U2FsdGVkX18SZ091g8USl3VocpC2j9EXjEPer4X8fPZHQFvr+G
	RjU0tRd84CoLjl
Message-ID: <496F9174.5080907@gmx.de>
Date: Thu, 15 Jan 2009 20:41:40 +0100
From: wk <handygewinnspiel@gmx.de>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: wk <handygewinnspiel@gmx.de>, Chris Mason <chris.mason@oracle.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl, HWerner4@gmx.de,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mchehab@infradead.org
Subject: Re: [linux-dvb] compiling on 2.6.28 broken?
References: <20090112132130.6c932b85.akpm@linux-foundation.org> <20090112220624.4fbfee34@pedra.chehab.org> <20090112162337.318dd61d.akpm@linux-foundation.org> <20090113184755.87720@gmx.net> <20090113105947.9e774b69.akpm@linux-foundation.org> <20090113191757.74290@gmx.net> <20090113113700.776a94b5.akpm@linux-foundation.org> <20090113203843.GJ29283@parisc-linux.org> <1231957750.8269.28.camel@think.oraclecorp.com> <496E56EB.2030301@gmx.de> <20090114223016.GY8071@disturbed>
In-Reply-To: <20090114223016.GY8071@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> On Wed, Jan 14, 2009 at 10:19:39PM +0100, wk wrote:
>   
>> Chris Mason wrote:
>> I cannot fully understand what strace -v outputs (see attachment), but  
>> what i see is that 'find' stops after finding a file with d_off = 
>> 4294967295
>> 4294967295  =  0xFFFFFFFF, adding any number greater that zero will be  
>> greater that 32bits, so this could be the reason for the message "value  
>> too large".
>>
>>
>>
>> I also noticed that i cannot access these files through samba if i boot  
>> from 2.6.28 - really strange.
>> If i reboot older kernels these are visible in samba again and fully  
>> accessible.
>>
>> Attached the log from stracing the command which was ivoked by the  
>> Makefile from v4l-dvb.
>> I guess this is all i could contribute to that problem. Thats stuff for  
>> xfs filesystem experts now..
>>     
>
> It's obviously the regression fixed by:
>
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs.git;a=commit;h=15440319767942a363f282d6585303d3d75088ba
>
> It needs to be pushed to Linus, then into 2.6.28-stable.
>
> Cheers,
>
> Dave.
>   

Yes, that solves the problems as expected. But may i kindly ask the xfs 
fs developers to put some more readable patch here,
so that its better understandable by looking at the source code? I think 
some macro would be better here, for example i used

#define TRUNC_TO_SIGNED32(x) (x & 0x7FFFFFFF)

inside xfs.h and replaced all "foo & 0x7fffffff" with 
"TRUNC_TO_SIGNED32(foo)".

Thanks for your help,
Winfried
