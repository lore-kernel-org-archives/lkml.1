Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbZFCIL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbZFCIL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbZFCILm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:11:42 -0400
Received: from smtp.nokia.com ([192.100.105.134]:16761 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbZFCILk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:11:40 -0400
Message-ID: <4A263019.3090807@nokia.com>
Date: Wed, 03 Jun 2009 11:11:05 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "david@fromorbit.com" <david@fromorbit.com>,
       "hch@infradead.org" <hch@infradead.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "jack@suse.cz" <jack@suse.cz>,
       "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "damien.wyart@free.fr" <damien.wyart@free.fr>
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com> <4A200846.5050109@gmail.com> <4A200B43.40708@nokia.com> <20090529170911.GK11363@kernel.dk>
In-Reply-To: <20090529170911.GK11363@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Jun 2009 08:11:06.0846 (UTC) FILETIME=[D876DFE0:01C9E422]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Jens Axboe wrote:
> On Fri, May 29 2009, Artem Bityutskiy wrote:
>> Artem Bityutskiy wrote:
>>> Jens Axboe wrote:
>>>> Hi,
>>>>
>>>> Here's the 9th version of the writeback patches. Changes since v8:
>>>>
>>>> - Fix a bdi_work on-stack allocation hang. I hope this fixes Ted's
>>>>   issue.
>>>> - Get rid of the explicit wait queues, we can just use wake_up_process()
>>>>   since it's just for that one task.
>>>> - Add separate "sync_supers" thread that makes sure that the dirty
>>>>   super blocks get written. We cannot safely do this from
>>>> bdi_forker_task(),
>>>>   as that risks deadlocking on ->s_umount. Artem, I implemented this
>>>>   by doing the wake ups from a timer so that it would be easier for you
>>>>   to just deactivate the timer when there are no super blocks.
>>>>
>>>> For ease of patching, I've put the full diff here:
>>>>
>>>>   http://kernel.dk/writeback-v9.patch
>>>>
>>>> and also stored this in a writeback-v9 branch that will not change,
>>>> you can pull that into Linus tree from here:
>>>>
>>>>   git://git.kernel.dk/linux-2.6-block.git writeback-v9
>>> I'm working with the above branch. Got the following twice.
>>> Not sure what triggers this, probably if I do nothing and
>>> cpufreq starts doing its magic, this is triggered.
>>>
>>> And I'm not sure it has something to do with your changes,
>>> it is just that I saw this only with your tree. Please,
>>> ignore if this is not relevant.
>> Sorry, probably I shouldn't have reported this before looking
>> closer. I'll investigate this later and fine out whether it
>> is related to your work or not. Sorry for too early and probably
>> false alarm.
> 
> No problem. If it does turn out to have some relation to the writeback
> stuff, let me know.

OK, I'm confirming that I observe this also with pure 2.6.30-rc7
as well.


-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
