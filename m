Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab0CMWzW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 17:55:22 -0500
Received: from mail-pz0-f200.google.com ([209.85.222.200]:41269 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab0CMWzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 17:55:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=a8xnfH+02s1+UoGPLz0XscNS6OeJvvv7u6g16PJoNWmBwnDKSg0xijygyHq/Gq9UZO
         W6/10ipAlGAucFFjiDYqc9Bv3uoX9fKJSmv5Vn9jBwY01FTrvF8TvwJGcRiZA831E6lW
         LCZnk0xoR5Chd42mxM9Qldnahkg/6qtVuDf7g=
Message-ID: <4B9C17D3.5080402@lwfinger.net>
Date: Sat, 13 Mar 2010 16:55:15 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] base firmware: Fix BUG from sysfs attributes change in
 commit a2db6842873c8e5a70652f278d469128cb52db70
References: <4b9be956.x5+yAHXGDfXer810%Larry.Finger@lwfinger.net> <alpine.LFD.2.00.1003131426480.3719@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1003131426480.3719@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2010 04:32 PM, Linus Torvalds wrote:
> 
> 
> On Sat, 13 Mar 2010, Larry Finger wrote:
>>
>> Commit a2db6842873c8e5a70652f278d469128cb52db70 changed the way that
>> sysfs attributes are handled. With lockdep checking enabled, a firmware
>> loading request from b43 generates the following BUG:
>>
>> BUG: key ffff8800b85f4870 not in .data!
>> ------------[ cut here ]------------
>> WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0x236/0x5d0()
> 
> I don't think we can fix these problems this way.
> 
> Lookie here:
> 
> 	[torvalds@i5 linux]$ git grep sysfs_create_bin_file | wc
> 	     68     319    5999
> 	[torvalds@i5 linux]$ git grep sysfs_bin_attr_init | wc
> 	      8      24     522
> 
> and you sent in patches to fix _two_ of the remaining 60 cases.

Those are the two that showed up on my machine, and as Jiri says, not all 68
will be needed. I need them to see any lockdep problems on the driver I'm
developing. I'll watch for developments.

Larry

