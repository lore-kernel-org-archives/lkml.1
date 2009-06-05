Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbZFEVba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbZFEVba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 17:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbZFEVbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 17:31:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:28471 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbZFEVbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 17:31:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RL4sAL+fZ6nVwcUSdZ0wgCbycl/8hAjjGoHjJMFm/dcCJM8exY24RlkEtWxgFb96Ac
         9p7ggDgRyBuGblNeqHg4OY8o+G5ZqEXcfAR2JZu6UIEwQMfyUOJaKapUZLPvgUH9GVNM
         PNq1Ou/Vq2v5MXSroh1lW86V/KqCefqwZorsA=
Message-ID: <4A298EF5.9000504@tuffmail.co.uk>
Date: Fri, 05 Jun 2009 22:32:37 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: Aioanei Rares <krnl.list@gmail.com>, linux-ext4@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Mild filesystem corruption on ext4 (no journal)
References: <4A28F83F.4030704@tuffmail.co.uk> <4A292E61.3050204@gmail.com> <4A293084.5010400@tuffmail.co.uk> <4A2937CC.7070503@redhat.com> <4A294B15.9070209@tuffmail.co.uk> <4A29601F.3070802@redhat.com>
In-Reply-To: <4A29601F.3070802@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Alan Jenkins wrote:
>   
>> Eric Sandeen wrote:
>>     
>
>   
>>> Maybe you could try some things in your shutdown script, such as
>>> explicitly fsyncing the file, or bmapping it with filefrag, or dropping
>>> caches and rereading it... see what the state is just before the
>>> shutdown compared to after the reboot.
>>>
>>> -Eric
>>>   
>>>       
>> Dropping caches (and running sync first) had no effect on the result of 
>> md5sum.  Hopefully that narrows it down a bit.
>>     
>
> And did the reread after dropping caches have the right data?
>   

Yes.

> Did the block numbers reported by filefrag -v change post-boot?
>   

Oh, I didn't understand that's what you were asking for.

The bug report Ted linked to says it's (most likely) a writeback issue.  
In which case I think the block numbers won't change.  I'll check 
tomorrow, and follow-up if it turns up any unexpected result.

There's also speculation that it's a core kernel issue, something that 
changed since 2.6.26.  Perhaps that explains how remount-ro + sync + 
drop_caches can leave the correct data sitting in the pagecache, without 
either writing it to disk or dropping it.

Thanks
Alan
