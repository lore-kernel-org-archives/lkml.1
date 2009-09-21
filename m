Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbZIUACY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbZIUACY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 20:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbZIUACX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 20:02:23 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:42767 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324AbZIUACV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 20:02:21 -0400
MIME-Version: 1.0
In-Reply-To: <4AB67883.3010500@gmail.com>
References: <20090917115728.GA13854@arachsys.com> <4AB2596D.10809@kernel.org> 
	<4AB67883.3010500@gmail.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Sun, 20 Sep 2009 20:02:04 -0400
Message-ID: <f73f7ab80909201702q4661cfe4t5b7b8449ba12306a@mail.gmail.com>
Subject: Re: MD/RAID time out writing superblock
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Chris Webb <chris@arachsys.com>,
       Neil Brown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>,
       Andrei Tanas <andrei@tanas.ca>, linux-kernel@vger.kernel.org,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       Mark Lord <mlord@pobox.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 20, 2009 at 14:46, Robert Hancock <hancockrwd@gmail.com> wrote:
> On 09/17/2009 09:44 AM, Tejun Heo wrote:
>>>
>>> Thanks Neil. This implies that when we see these fifteen second
>>> hangs reading /proc/mdstat without write errors, there are genuinely
>>> successful superblock writes which are taking fifteen seconds to
>>> complete, presumably corresponding to flushes which complete but
>>> take a full 15s to do so.
>>>
>>> Would such very slow (but ultimately successful) flushes be
>>> consistent with the theory of power supply issues affecting the
>>> drives? It feels like the 30s timeouts on flush could be just a more
>>> severe version of the 15s very slow flushes.
>>
>> Probably not.  Power problems usually don't resolve themselves with
>> longer timeout.  If the drive genuinely takes longer than 30s to
>> flush, it would be very interesting tho.  That's something people have
>> been worrying about but hasn't materialized yet.  The timeout is
>> controlled by SD_TIMEOUT in drivers/scsi/sd.h.  You might want to bump
>> it up to, say, 60s and see whether anything changes.
>
> It's possible if the power dip only slightly disrupted the drive it might
> just take longer to complete the write. I've also seen reports of vibration
> issues causing problems in RAID arrays (there's a video on Youtube of a guy
> yelling at a Sun disk array during heavy I/O and the resulting vibrations
> causing an immediate spike in I/O service times). Could be something like
> that causing issues with simultaneous media access to all drives in the
> array, too..

There have been a rather large number of reported firmware problems
lately with various models of Seagate SATA drives; typically they
cause command timeouts and occasionally they completely brick the
drive (restart does not fix it).  I possessed 3 of these for a while
and they pretty consistently fell over (even with just 3 in a
low-power-CPU box with a good PSU rated for 8 drives).

You might check with the various Seagate tech support lines to see if
your drive firmwares are affected by the bugs (Some were related to
NCQ command processing, others were just single-command failures).

Cheers,
Kyle Moffett
