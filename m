Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110AbXH0H4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbXH0H4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 03:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbXH0H4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 03:56:33 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:7806 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbXH0H4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 03:56:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PXPNEdzmzl2wld4CM8MSAt29xyawtUnfiI/pjPcCvIbu7Xq+jLmCJcvQ0IaXqdoyqvpnbrPGTHlb8MHB2OT/lotj66YwLZYUhF05m9dcn/nArNFHF63BZpGUAIZ++QhaHUR6Z8s+7LHKjfgxm4xG+Ew6jOEpURZ+MQ7Y22amPdE=
Message-ID: <4877c76c0708270056g40b75dc8qb63f6a32d04ebc34@mail.gmail.com>
Date: Mon, 27 Aug 2007 00:56:30 -0700
From: "Michael Evans" <mjevans1983@gmail.com>
To: "Kyle Moffett" <mrmacman_g4@mac.com>
Subject: Re: [patch v2 1/1] md: Software Raid autodetect dev list not array
Cc: "Michael J. Evans" <mjevans1983@comcast.net>, "Neil Brown" <neilb@suse.de>,
       "Ingo Molnar" <mingo@redhat.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <ADB93FAB-45EF-439A-816C-8E27D8D3F5BB@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708222058.45480.mjevans1983@comcast.net>
	 <18126.21113.981032.286298@notabene.brown>
	 <200708260451.24868.mjevans1983@comcast.net>
	 <4877c76c0708260520v33bc36bfu24e688a5902912e5@mail.gmail.com>
	 <ADB93FAB-45EF-439A-816C-8E27D8D3F5BB@mac.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/26/07, Kyle Moffett <mrmacman_g4@mac.com> wrote:
> On Aug 26, 2007, at 08:20:45, Michael Evans wrote:
> > Also, I forgot to mention, the reason I added the counters was
> > mostly for debugging.  However they're also as useful in the same
> > way that listing the partitions when a new disk is added can be (in
> > fact this augments that and the existing messages the autodetect
> > routines provide).
> >
> > As for using autodetect or not... the only way to skip it seems to
> > be compiling md's raid support as a module.  I checked 2.6.22's
> > menuconfig and there's no way for me to explicitly turn it on or
> > off at compile time.  I also feel that forcing the addition of a
> > boot parameter to de-activate a broken and deprecated system you
> > aren't even aware you are getting is somehow wrong.  So if you have
> > over 128 devices for it to scan, as I do on one of my PCs, then it
> > can bring up
> > an array in degraded mode.  ... crud.
>
> Well, you could just change the MSDOS disk label to use a different
> "Partition Type" for your raid partitions.  Just pick the standard
> "Linux" type and you will get exactly the same behavior that
> everybody who doesn't use MSDOS partition tables gets.
>
> Cheers,
> Kyle Moffett
>
>

I recall most of the guides I referenced during setup having me change
the partition type, additionally parted only calls the flag 'raid' not
'raid autodetect'.  However it would still be confusing to anyone not
intimately familiar with the subsystem.

Also, even though the system has a standard PC BIOS, I liked some of
the specifications of the GUID partition table (GPT) provided.  Namely
a checksum and backup copy, and up to 128 partitions per disk.  Parted
is the only real tool I could find for editing such a disk label.

A problem I experienced that is almost completely unrelated to this
patch are other 'magic number' assumptions.  It is rather unfortunate
that linux allocates a fixed (and very small) number of partitions per
scsi disk.  A better method might be a complete dis-association of
major:minor pair to device name, and instead simply enumerating
partitions as they are detected.  That way if I choose to have 128
drives but each having at most 2 partitions I still easily fit within
one major, or if I choose the opposite (for whatever reason) I still
come to the same conclusion.  Before anyone mentions using LVM
instead, sharing operating systems, and using different partitions for
different raid stripe sizes/rebuilding flexibility/restriping
flexibility are just two good reasons I can think of for supporting
more then 15 partitions per device.
