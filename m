Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbYJUMeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbYJUMeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYJUMeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:34:03 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:60469 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752886AbYJUMeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:34:01 -0400
Date: Tue, 21 Oct 2008 08:33:48 -0400
From: Theodore Tso <tytso@mit.edu>
To: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
Cc: Alexandre Lymberopoulos <lymber@gmail.com>, 502583@bugs.debian.org,
       502583-submitter@bugs.debian.org, linux-kernel@vger.kernel.org
Subject: Re: Bug#502583: scary messages in dmesg
Message-ID: <20081021123348.GB15685@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	=?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>,
	Alexandre Lymberopoulos <lymber@gmail.com>, 502583@bugs.debian.org,
	502583-submitter@bugs.debian.org, linux-kernel@vger.kernel.org
References: <2bfaaf400810172145g4aba4827l87a19e67b9742815@mail.gmail.com> <20081018060400.GB916@ime.usp.br> <2bfaaf400810201654u21c9d950o72b2afa9496ba3da@mail.gmail.com> <20081021101510.GA16244@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081021101510.GA16244@ime.usp.br>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 08:15:10AM -0200, Rogério Brito wrote:
> On Oct 20 2008, Alexandre Lymberopoulos wrote:
> > It's not a memory stick, it's a hard disk with ext3 file system. I
> > just plugged it it and the disk was automatically mounted in /dev/ext3
> > with no abnormal messages in dmesg.
> 
> Ok, this far.
> 
> > That weird messages appeared when I unpplugged the disk (without
> > umounting it, as it should be done when using usbmount, right?).
> 
> Did you sync the device? From the message, it seems that some data were to
> be written to the device, but the device was already gone by that time, but
> I'm not a specialist on the filesystem subsystem and perhaps others could
> say more about it.

A patch to suppress the WARN information will be in 2.6.28 when the
user does something stupid (i.e., yank out a USB stick without
unmounting the filesystem first).  This was done mainly to suppress
the "scary message" in dmesg, which on distributions that support
uploading such messages to http://www.kerneloops.org for analysis, was
cluttering the reports.

However, the patch does not make it any *safer* to uncerimoniously
yank out a USB stick without unmounting it first.  This can still lead
to data loss, unless you're *sure* that no process is writing to the
stick and you issued the sync command, and you know enough time has
passed so all of the data has been written to the USB stick. 

> > > [39071.160167] Buffer I/O error on device sda1, logical block 1545
> > > [39071.160170] lost page write due to I/O error on sda1
> > > [39071.160184] Buffer I/O error on device sda1, logical block 1545
> > > [39071.160187] lost page write due to I/O error on sda1

These errors you'd still get, since these messages are the sound of
users' data being irretrivably being lost.

> Well, it is a bug. It just needs more investigation to see where the bug
> lies.

I don't know if you would call it a bug or not.  Fundamentally,
yanking out a USB stick without unmounting it first is dangerous, and
can lead to data loss.  Printing the stack trace when this happens
implies it's a problem which can be fixed by a developer, so perhaps
that could be considered a bug, and in any case, that should be
"fixed" in 2.6.28.  (I'm pretty sure akpm has sent the ext3 version of
that patch to Linus by now, but if not, it should make the 2.6.28
merge window.)

If you see "lost page write due to I/O error", then you will have lost
data due to premature removal of the USB stick, and fundamentally
*that* bug exists between the keyboard and the chair.

Regards,

						- Ted
