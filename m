Return-Path: <linux-kernel-owner+w=401wt.eu-S1753060AbYKFUNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbYKFUNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbYKFUMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:12:40 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:50831 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYKFUMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:12:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:from;
        b=k5XQ0JEg8UWYx9hHI4FX1p8K2HDbDvYpP9B7Lt6aDseh/IyXUqBRO2EFSUf8oF21ZV
         l8MAHli3t2SHIcB1R4ThcUujjUsosBy4TQYe6F8GhGvHn5cBMHxIMKuhBf8BGesVuTwi
         ZI5om3qPVsF16yYxtsnrsWZwr4L7lLm0s3vYs=
Date: Thu, 6 Nov 2008 15:12:32 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stern@rowland.harvard.edu,
       Jens Axboe <jens.axboe@oracle.com>, linux-usb@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [BUG] usb-storage: Error in queuecommand: us->srb = ffff88006a338480
Message-ID: <20081106201232.GA25383@ezra.hsd1.tn.comcast.net>
References: <20081030213557.GA6767@ezra.hsd1.tn.comcast.net> <20081105174905.27194494.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105174905.27194494.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
From: Brian Kysela <brian.kysela@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-11-05 at 17:49 -0800, Andrew Morton wrote: 
> On Thu, 30 Oct 2008 17:35:57 -0400
> Brian Kysela <bkysela@gmail.com> wrote:
> 
> > On kernels ranging from 2.6.26 - 2.6.28-rc2
> 
> So 2.6.25 was OK?

I had only tested back to 2.6.26. If I have time and find a kernel
before that that works consistently, I'll let you know.

> 
> > on an Intel P4 3.2GHz HT x86-64
> > cpu, I am seeing a bug that occurs about half the time when copying ~300MB
> > data from a usb flash drive (FAT) to hard drive (XFS). There are three
> > possible outcomes, so far, when I hit the bug:
> > 
> >     (1) The copy process hangs, cpu wait hits 100% and load avg climbs until
> >         reboot;
> >     (2) The copy process hangs and then recovers and then one of:
> >         (a) the cpu wait & load avg both decline to normal; or
> >         (b) cpu wait hovers at 100% and the load avg slowly climbs until reboot;
> >     (3) Kernel bug reported and machine locks up.
> > 
> > Result (1) is the most frequent. Result (3) happened only twice out of about 40
> > tests. I lose the full traces, but here are two relevant lines that I see on
> > screen before the machine locks up:
> > 
> > kernel BUG at /home/brian/linux-2.6/block/elevator.c:841!
> > invalid opcode: 0000 [#1] PREMPT SMP
> 
> It is unclear what kernel version produced that message, and that is
> important information.  In 2.6.28-rc2, block/elevator.c:841 is
> 
>     void elv_dequeue_request(struct request_queue *q, struct request *rq)
>     {
> -->>	BUG_ON(list_empty(&rq->queuelist));
> 	BUG_ON(ELV_ON_HASH(rq));
> 
> please confirm that I have the correct line there.

Yes, that's the correct line, it was 2.6.28-rc2 that produced those.
I'll try usbmon per Alan Stern's suggestion and see if that shows
anything interesting.

Brian 
