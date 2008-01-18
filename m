Return-Path: <linux-kernel-owner+w=401wt.eu-S932728AbYARWgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728AbYARWgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760738AbYARWgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:36:08 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50711 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762857AbYARWgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:36:06 -0500
In-Reply-To: <47910D6E.3070801@garzik.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Al Boldi <a1426z@gawab.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Daniel Phillips <phillips@google.com>,
       ric@emc.com, Rik van Riel <riel@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Valerie Henson <val.henson@gmail.com>
MIME-Version: 1.0
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental fsck)
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFDAE81670.76D5065A-ON882573D4.007A239B-882573D4.007C23CE@us.ibm.com>
From: Bryan Henderson <hbryan@us.ibm.com>
Date: Fri, 18 Jan 2008 14:35:55 -0800
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.0|August 02, 2007) at 01/18/2008
 17:35:56,
	Serialize complete at 01/18/2008 17:35:56
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just had a talk with a colleague, John Palmer, who worked on disk drive 
design for about 5 years in the '90s and he gave me a very confident, 
credible explanation of some of the things we've been wondering about disk 
drive power loss in this thread, complete with demonstrations of various 
generations of disk drives, dismantled.

First of all, it is plain to see that there is no spring capable of 
parking the head, and there is no capacitor that looks big enough to 
possibly supply the energy to park the head, in any of the models I looked 
at.  Since parking of the heads is essential, we can only conclude that 
the myth of the kinetic energy of the disks being used for that (turned 
into electricity by the drive motor) is true.  The energy required is not 
just to move the heads to the parking zone, but to latch them there as 
well.

The myth is probably just that that energy is used for anything else; it's 
really easy to build a dumb circuit to park the heads using that power; 
keeping a computer running is something else.

The drive does drop a write in the middle of the sector if it is writing 
at the time of power loss.  The designers were too conservative to keep 
writing as power fails -- there's no telling what damage you might do.  So 
the drive cuts the power to the heads at the first sign of power loss.  If 
a write was in progress, this means there is one garbage sector on the 
disk.  It can't be read.

Trying to finish writing the sector is something I can image some drive 
model somewhere trying to do, but if even _some_ take the conservative 
approach, everyone has to design for it, so it doesn't matter.

A device might then reassign that sector the next time you try to write to 
it (after failing to read it), thinking the medium must be bad.  But there 
are various algorithms for deciding when to reassign a sector, so it might 
not too.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems

