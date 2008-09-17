Return-Path: <linux-kernel-owner+w=401wt.eu-S1754225AbYIQPVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbYIQPVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 11:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYIQPVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 11:21:12 -0400
Received: from nebensachen.de ([195.34.83.29]:59298 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbYIQPVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 11:21:11 -0400
X-Hashcash: 1:20:080917:pavel@suse.cz::nYGVs9tUUM0VtiKk:000003lh
X-Hashcash: 1:20:080917:tj@kernel.org::1NAW1q8zReHl5Fev:00002nUk
X-Hashcash: 1:20:080917:multinymous@gmail.com::OqDiAEnBU4kjaMRR:00000000000000000000000000000000000000000Yju
X-Hashcash: 1:20:080917:trenn@suse.de::sfkgcaI0Cdo2BThr:00000RY5
X-Hashcash: 1:20:080917:linux-kernel@vger.kernel.org::Zh3AtxpgCa3G2quh:0000000000000000000000000000000001gu5
X-Hashcash: 1:20:080917:linux-ide@vger.kernel.org::EfQWT52ysTQ9TOPH:0000000000000000000000000000000000001IUQ
From: Elias Oltmanns <eo@nebensachen.de>
To: Pavel Machek <pavel@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, Shem Multinymous <multinymous@gmail.com>,
       Thomas Renninger <trenn@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Laptop shock detection and harddisk protection
References: <48C7FCEE.8060404@kernel.org>
	<41840b750809110908o54a61f55w7b1b9793abf55634@mail.gmail.com>
	<48C948A6.3080404@kernel.org> <877i9ipi56.fsf@denkblock.local>
	<20080817195103.GD4043@ucw.cz>
Date: Wed, 17 Sep 2008 17:21:01 +0200
In-Reply-To: <20080817195103.GD4043@ucw.cz> (Pavel Machek's message of "Sun,
	17 Aug 2008 21:51:03 +0200")
Message-ID: <87d4j2ol2a.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@suse.cz> wrote:
> Hi!
>
>> Short of a satisfying proposition regarding the questions raised, I just
>> want to add two things that would be nice to solve in the future one way
>> or another and should perhaps be taken into consideration from the
>> beginning:
>> 
>> 1. Disable polling completely when it isn't required: once the hd has
>>    spun down, there is no need to keep polling the sensors at all. Only
>>    when the first request requiring the hd to spin up arrives, the
>>    kernel needs to hold back for a short while to gather enough data
>>    from the sensors, so shock protection is up and running again.
>
> hdparm can already tell if disk is spinning or not. As userland is
> polling, already, that may be enough?

Yes, I know it *is* possible, I just think it may not be completely
trivial to get it right. The only way I can think of, right now, is some
sort of polling in the hdparm way, i.e. issuing a ATA_CMD_CHK_POWER from
time to time. The question is how we are to decide when and how often we
should poll for the current power state of the HD.

>
>> 2. Make shock protection interact nicely with suspend operations:
>>    currently, we are out of luck if anything should happen after
>>    processes have been frozen. This is particularly unfortunatel in the
>>    case of s2disk.
>
> I'd say that s2disk is similar to early boot... no protection there. 

Well, this is true for resume. However, I can't help thinking that we
may do better than that until the disk spins down, particularly while
writing the image to disk.

Regards,

Elias
