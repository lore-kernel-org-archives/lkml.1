Return-Path: <linux-kernel-owner+w=401wt.eu-S1760973AbZE2RJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760973AbZE2RJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 13:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbZE2RJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 13:09:11 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46365 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950AbZE2RJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 13:09:10 -0400
Date: Fri, 29 May 2009 19:09:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
Message-ID: <20090529170911.GK11363@kernel.dk>
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com> <4A200846.5050109@gmail.com> <4A200B43.40708@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A200B43.40708@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29 2009, Artem Bityutskiy wrote:
> Artem Bityutskiy wrote:
>> Jens Axboe wrote:
>>> Hi,
>>>
>>> Here's the 9th version of the writeback patches. Changes since v8:
>>>
>>> - Fix a bdi_work on-stack allocation hang. I hope this fixes Ted's
>>>   issue.
>>> - Get rid of the explicit wait queues, we can just use wake_up_process()
>>>   since it's just for that one task.
>>> - Add separate "sync_supers" thread that makes sure that the dirty
>>>   super blocks get written. We cannot safely do this from
>>> bdi_forker_task(),
>>>   as that risks deadlocking on ->s_umount. Artem, I implemented this
>>>   by doing the wake ups from a timer so that it would be easier for you
>>>   to just deactivate the timer when there are no super blocks.
>>>
>>> For ease of patching, I've put the full diff here:
>>>
>>>   http://kernel.dk/writeback-v9.patch
>>>
>>> and also stored this in a writeback-v9 branch that will not change,
>>> you can pull that into Linus tree from here:
>>>
>>>   git://git.kernel.dk/linux-2.6-block.git writeback-v9
>>
>> I'm working with the above branch. Got the following twice.
>> Not sure what triggers this, probably if I do nothing and
>> cpufreq starts doing its magic, this is triggered.
>>
>> And I'm not sure it has something to do with your changes,
>> it is just that I saw this only with your tree. Please,
>> ignore if this is not relevant.
>
> Sorry, probably I shouldn't have reported this before looking
> closer. I'll investigate this later and fine out whether it
> is related to your work or not. Sorry for too early and probably
> false alarm.

No problem. If it does turn out to have some relation to the writeback
stuff, let me know.

-- 
Jens Axboe

