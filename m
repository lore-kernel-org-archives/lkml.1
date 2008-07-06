Return-Path: <linux-kernel-owner+w=401wt.eu-S1757796AbYGFQMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796AbYGFQMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 12:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757317AbYGFQMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 12:12:06 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58196 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757247AbYGFQME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 12:12:04 -0400
Subject: Re: 2.6.26-rc9: Reported regressions from 2.6.25
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <alpine.LFD.1.10.0807060816070.3016@woody.linux-foundation.org>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
	 <alpine.LFD.1.10.0807060816070.3016@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sun, 06 Jul 2008 11:11:58 -0500
Message-Id: <1215360718.4197.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-06 at 08:46 -0700, Linus Torvalds wrote:
> > Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=10725
> > Subject               : USB Mass storage mount fails: Write protect on
> > Submitter     : Maciej Rutecki <maciej.rutecki@gmail.com>
> > Date          : 2008-05-16 14:55 (52 days old)
> > References    : http://marc.info/?l=linux-kernel&m=121095168003572&w=4
> > Handled-By    : Alan Stern <stern@rowland.harvard.edu>
> > Patch         : http://marc.info/?l=linux-scsi&m=121433068314568&w=2
> 
> Hmm. James?

Oh ... it was reported against 2.6.26-rc1, so the fix is actually
crrently queued for scsi-misc in my internal test rig.  However, the
reason for the long QA is that there's a potential danger to the fix
which is clearing the buffer from the reported length to the actual
length will break a SCSI card that misreports the returned length.  It
seems to be OK on my esoteric SCSI card collection, so I'll push it out
to scsi-rc-fixes.  However, I think it still wants to run in linux-next
for a few days to see if anyone else can turn up a problem.

The true issue, of course, is that we won't see a problem until the
2.6.26 release because the hardware that triggers it isn't in the set
we're testing with.  A less risky fix for 2.6.26-rc9 might be to move
the clearing into the affected subsystem (usbstorage).

James


