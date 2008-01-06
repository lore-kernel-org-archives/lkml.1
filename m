Return-Path: <linux-kernel-owner+w=401wt.eu-S1761120AbYAFOwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761120AbYAFOwQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758834AbYAFOr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:47:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56280 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760070AbYAFOrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:47:23 -0500
Date: Sun, 6 Jan 2008 15:47:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
Message-ID: <20080106144706.GA25419@elte.hu>
References: <20080102162534.GA4041@elte.hu> <1199292381.3258.32.camel@localhost.localdomain> <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org> <20080102194030.GC11638@parisc-linux.org> <1199304735.3258.53.camel@localhost.localdomain> <alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org> <1199316785.3258.85.camel@localhost.localdomain> <alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org> <m3ir27oe7f.fsf@telia.com> <1199627875.5205.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199627875.5205.1.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> > I can repeat this bug, both with and without the scsi patch that is 
> > claimed to make a difference, both with an external USB drive and an 
> > internal IDE drive.
> > 
> > To repeat:
> > 
> >   1. Start with an empty drive.
> >   2. pktsetup 0 /dev/scd0 
> >   3. Insert a CD containing an isofs filesystem.
> >   4. mount /dev/pktcdvd/0 /mnt/tmp
> >   5. umount /mnt/tmp
> >   6. Press the eject button.
> >   7. Insert a DVD containing a non-writable filesystem.
> >   8. mount /dev/scd0 /mnt/tmp
> >   9. find /mnt/tmp -type f -print0 | xargs -0 sha1sum >/dev/null
> >   10. If the DVD contains data beyond the physical size of a CD, you
> >       get I/O errors in the terminal, and dmesg reports lots of
> >       "attempt to access beyond end of device" errors.
> 
> Brilliant!  I can confirm the reproduction of the bug too (that's with 
> the originally fingered commit reverted).

may i point out the obvious at this stage? The thing that finally got 
movement into this bug was ... :

   exposure on lkml

The reproducer came to you via Peter Osterlund who has never authored a 
single drivers/scsi/ commit before (according to git-log) and who (and 
here i'm out on a limb guessing it) does not even follow 
linux-scsi@vger.kernel.org.

this bug was obscure and hidden on linux-scsi@vger.kernel.org for 
_months_, (it is a rarely visited and rarely read mailing list) and 
there was just not enough "critical mass" to get this issue fixed.

_THAT_ is the power of lkml. People who are not generally interested in 
your subsystem come and help. There is extra noise, but it's manageable.

so may i at this point suggest that you as the SCSI maintainer start 
reading SCSI bugreports on lkml and start participating in SCSI topics 
there, without extra prompting? It _is_ an important aggregation mailing 
list for development, just like -mm or the upstream kernel is an 
aggregation point of all things Linux.

I believe the "I only read linux-scsi, please post bugs there" approach 
is harmful. If lkml traffic is too big then i'd suggest to set up email 
filters to separate out mails that have 'SCSI' in their subject line or 
body. Fortunately it's a really easy key to filter on. [ Scheduler mails 
are much harder to filter out :-/ ] In fact i'd suggest to do all SCSI 
development on lkml. We've got one upstream kernel codebase, one git 
stream of commits and hence we should use one lkml feed to discuss 
things on.

	Ingo
