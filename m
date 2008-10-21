Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbYJUOfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbYJUOfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 10:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYJUOfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 10:35:05 -0400
Received: from hope.ime.usp.br ([143.107.45.8]:52512 "HELO hope.ime.usp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751552AbYJUOfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 10:35:04 -0400
Date: Tue, 21 Oct 2008 12:35:00 -0200
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Theodore Tso <tytso@mit.edu>, Alexandre Lymberopoulos <lymber@gmail.com>,
       502583@bugs.debian.org, 502583-submitter@bugs.debian.org,
       linux-kernel@vger.kernel.org, rafael@debian.org
Subject: Re: Bug#502583: scary messages in dmesg
Message-ID: <20081021143500.GA18469@ime.usp.br>
References: <2bfaaf400810172145g4aba4827l87a19e67b9742815@mail.gmail.com> <20081018060400.GB916@ime.usp.br> <2bfaaf400810201654u21c9d950o72b2afa9496ba3da@mail.gmail.com> <20081021101510.GA16244@ime.usp.br> <20081021123348.GB15685@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081021123348.GB15685@mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of all, Thanks Theodore.

On Oct 21 2008, Theodore Tso wrote:
> On Tue, Oct 21, 2008 at 08:15:10AM -0200, Rogério Brito wrote:
> > Did you sync the device? From the message, it seems that some data were
> > to be written to the device, but the device was already gone by that
> > time, but I'm not a specialist on the filesystem subsystem and perhaps
> > others could say more about it.
> 
> A patch to suppress the WARN information will be in 2.6.28 when the
> user does something stupid (i.e., yank out a USB stick without
> unmounting the filesystem first).

Right. I will put a big, fat warning on the installation of usbmount and
tell the users about it. Besides that, depending on the filesystem, the
superblock may be marked as dirty.

> This was done mainly to suppress the "scary message" in dmesg, which on
> distributions that support uploading such messages to
> http://www.kerneloops.org for analysis, was cluttering the reports.

Right...

> > > > [39071.160167] Buffer I/O error on device sda1, logical block 1545
> > > > [39071.160170] lost page write due to I/O error on sda1
> > > > [39071.160184] Buffer I/O error on device sda1, logical block 1545
> > > > [39071.160187] lost page write due to I/O error on sda1
> 
> These errors you'd still get, since these messages are the sound of
> users' data being irretrivably being lost.

Good that not all messages will be going... BTW, this reminded me of a
patch that eliminated a whole lot of messages (BUG()'s) for embedded
devices... I didn't find it anymore...

Also, the same thing with the hash tables that could turn into linked lists
eventually...

But I'm drifting away from the main topic.

> > Well, it is a bug. It just needs more investigation to see where the bug
> > lies.
> 
> I don't know if you would call it a bug or not.  Fundamentally,
> yanking out a USB stick without unmounting it first is dangerous, and
> can lead to data loss.

At least sync'ing...

[snip]

> If you see "lost page write due to I/O error", then you will have lost
> data due to premature removal of the USB stick, and fundamentally
> *that* bug exists between the keyboard and the chair.

Ok, so I'm closing this bug in the next upload.


Thanks, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
