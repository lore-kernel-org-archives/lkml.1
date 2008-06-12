Return-Path: <linux-kernel-owner+w=401wt.eu-S1758878AbYFLK2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbYFLK2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 06:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbYFLK2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 06:28:25 -0400
Received: from mail-va3.bigfish.com ([216.32.180.115]:2284 "EHLO
	mail213-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753904AbYFLK2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 06:28:24 -0400
X-Greylist: delayed 1570 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jun 2008 06:28:24 EDT
X-BigFish: VPS-42(zz1432R98dR4015M7efV1805Mzz10d3izzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0K2CH77-01-WBI-01
Date: Thu, 12 Jun 2008 12:01:10 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 0/5] x86: minor PAT adaptations
Message-ID: <20080612100110.GA7763@alberich.amd.com>
References: <20080610140411.GD5024@alberich.amd.com> <20080612081029.GA1403@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080612081029.GA1403@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 12 Jun 2008 10:01:11.0593 (UTC) FILETIME=[3E244990:01C8CC73]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 10:10:29AM +0200, Ingo Molnar wrote:
> 
> * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> 
> > Following some patches to slightly adapt the PAT code.
> > 
> > patch 1 - enable PAT for all AMD CPUs that have the PAT feature flag set
> > patch 2 - fix up paranoia check in pat_init and fix the logic to
> >           enable/disable PAT (IMHO the current code enables PAT on all
> >           Transmeta and Centaur CPUs even if no PAT feature flag is set) 
> >           (I admit I should have changed the sequence of patches 1 and 2.)
> > patch 3 - fix some checkpatch errors
> > patch 4 - variable renaming
> 
> applied to tip/x86/pat, thanks Andreas. (i presume you'll send a 
> followup patch for the suggestions that came up in the discussion)

Yes, I'll do.

> > patch 5 - slightly changing the code that is doing the intersection of
> >           pat_type and mtrr_type to be more readable (from my point of view)
> > 
> > Patches are against x86/pat (as of version v2.6.26-rc3-6-g46dd98a).
> 
> #5 makes sense too, but it didnt apply cleanly:

That's odd. I've double checked it by doing a fresh

$ git remote add tip git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
$ git remote update
$ git checkout tip/x86/pat

and applying patches 1-5 in sequence without problems.
(Patches were taken from emails that arrived via my linux-kernel
subscription.) Probably your tip/x86/pat is not at
v2.6.26-rc3-6-g46dd98a?

When trying to apply the patches to tip/master I get rejects for
patches 3 and 5.

Hence I think creating my patches against a feature branch was not a
good idea.

>  Applying patch 
>  patches/pat-x86-pat-make-pat-x-mtrr-type-more-readable.patch
>  patching file arch/x86/mm/pat.c
>  Hunk #1 FAILED at 185.
>  1 out of 1 hunk FAILED -- rejects in file arch/x86/mm/pat.c
> 
> (it didnt apply neither against tip/x86/pat or tip/master, nor against 
> linus/master. I guess it's some mixup somewhere.)

Ok, it's commit 282c454cd3a7041f59a37112bb2f82263bc38f6c which was not
contained in the tip/x86/pat branch. This means I have to adapt patch 5.

Finally a dumb question. What patches do you prefer?
Patches against feature branches (say tip/x86/foo), against tip/master
or against tip/auto-latest as described in your tip.git-Readme?


Thanks,

Andreas


