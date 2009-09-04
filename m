Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbZIDLtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbZIDLtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 07:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756740AbZIDLtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 07:49:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756728AbZIDLtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 07:49:52 -0400
Message-ID: <4AA0FECE.3010200@redhat.com>
Date: Fri, 04 Sep 2009 07:49:34 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: jim owens <jowens@hp.com>, Ric Wheeler <rwheeler@redhat.com>,
       Pavel Machek <pavel@ucw.cz>, david@lang.hm,
       Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [testcase] test your fs/storage stack (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
References: <20090826001645.GN4300@elf.ucw.cz> <200909022141.48827.rob@landley.net> <4A9FCF53.10105@hp.com> <200909040244.54772.rob@landley.net>
In-Reply-To: <200909040244.54772.rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2009 03:44 AM, Rob Landley wrote:
> On Thursday 03 September 2009 09:14:43 jim owens wrote:
>    
>> Rob Landley wrote:
>>      
>>> I think he understands he was clueless too, that's why he investigated
>>> the failure and wrote it up for posterity.
>>>
>>>        
>>>> And Ric said do not stigmatize whole classes of A) devices, B) raid,
>>>> and C) filesystems with "Pavel says...".
>>>>          
>>> I don't care what "Pavel says", so you can leave the ad hominem at the
>>> door, thanks.
>>>        
>> See, this is exactly the problem we have with all the proposed
>> documentation.  The reader (you) did not get what the writer (me)
>> was trying to say.  That does not say either of us was wrong in
>> what we thought was meant, simply that we did not communicate.
>>      
> That's why I've mostly stopped bothering with this thread.  I could respond to
> Ric Wheeler's latest (what does write barriers have to do with whether or not
> a multi-sector stripe is guaranteed to be atomically updated during a panic or
> power failure?) but there's just no point.
>    

The point of that post was that the failure that you and Pavel both 
attribute to RAID and journalled fs happens whenever the storage cannot 
promise to do atomic writes of a logical FS block (prevent torn 
pages/split writes/etc). I gave a specific example of why this happens 
even with simple, single disk systems.

Further, if  you have the write cache enabled on your local S-ATA/SAS 
drives and do not have working barriers (as is the case with MD 
RAID5/6), you have a hard promise of data loss on power outage and these 
split writes are not going to be the cause of your issues.

You can verify this by testing. Or, try to find people that do storage 
and file systems that you would listen to and ask.
> The LWN article on the topic is out, and incomplete as it is I expect it's the
> best documentation anybody will actually _read_.
>
> Rob
>    

