Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752506AbYLQVWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbYLQVWm (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 16:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbYLQVWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 16:22:31 -0500
Received: from nebensachen.de ([195.34.83.29]:34018 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbYLQVWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 16:22:30 -0500
X-Hashcash: 1:20:081217:bzolnier@gmail.com::W3gAHBfBRbwROsiF:0000000000000000000000000000000000000000000338E
X-Hashcash: 1:20:081217:linux-ide@vger.kernel.org::8slbPrVQ+z/WU7oQ:000000000000000000000000000000000000AVzZ
X-Hashcash: 1:20:081217:linux-kernel@vger.kernel.org::54wAx4y1u0lpZ5TC:0000000000000000000000000000000000Ylm
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ide: use per-device request queue locks
References: <200811182119.21286.bzolnier@gmail.com>
	<87vdudjgfm.fsf@denkblock.local>
	<200812140015.23853.bzolnier@gmail.com>
	<87skom6bmz.fsf@denkblock.local>
Date: Wed, 17 Dec 2008 22:22:17 +0100
In-Reply-To: <87skom6bmz.fsf@denkblock.local> (Elias Oltmanns's message of
	"Wed, 17 Dec 2008 16:53:56 +0100")
Message-ID: <87myeu5wfq.fsf@denkblock.local>
User-Agent: Gnus/5.110011 (No Gnus v0.11)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns <eo@nebensachen.de> wrote:
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
>> On Monday 24 November 2008, Elias Oltmanns wrote:
[...]
>>> Finally, some more general blathering on the topic at hand: A while ago,
>>> I spent some thought on the possibilities of giving the block layer a
>>> notion of linked device queues as an equivalent hwgroups in ide,
>>> scsi_hosts or ata_ports and let it take care of time / bandwidth
>>> distribution among the queues belonging to one group. This is, as I
>>> understand, pretty much what your code is relying on since you have
>>> chucked out choose_drive(). However, this turned out not to be too easy
>>
>> This is the right way to go and I has always advocated for it.  However
>> after seeing how libata got away with ignoring the issue altogether
>> I'm no longer sure of this.  I haven't seen any bug reports which would
>> indicate that simplified approach has any really negative consequences.
>
> Well, libata can safely ignore it since scsi takes care of that (see
> scsi_run_queue() which is called on command completion).
>
>>
>> [ Still would be great to have the control over bandwitch of "queue-group"
>>   at the block layer level since we could also use it for distributing the
>>   available PCI[-E] bus bandwitch. ]
>>
>>> and I'm not quite sure whether we really want to go down that road. One
>>> major problem is that there is no straight forward way for the block
>>> layer to know, whether a ->request_fn() has actually taken a request off
>>> the queue and if not (or less than queue_depth anyway), whether it's
>>> just the device that couldn't take any more or the controller instead.
>>> On the whole, it seems not exactly trivial to get it right and it would
>>> probably be a good idea to consult Jens and perhaps James before
>>
>> I think that having more information returned by ->request_fn() could be
>> beneficial to the block layer (independently whether we end up adding
>> support for "queue-groups" to the block layer or not) but this definitely
>> needs to be verified with Jens & James.
>
> Some time back, I raised this with Jens in connection with your previous
> version of the patchset [1]. I didn't get an answer at the time but
> perhaps it would help to raise it again in its own right and to give
> some more examples of its potential merits.

[1] http://marc.info/?l=linux-ide&m=122470007616121&w=2

What ever does it mean that I missed something vital in this email too?
;-)

Regards,

Elias
