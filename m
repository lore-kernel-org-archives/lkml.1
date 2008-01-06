Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbYAFRKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbYAFRKa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 12:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbYAFRKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 12:10:21 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37819 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754425AbYAFRKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 12:10:19 -0500
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
In-Reply-To: <20080106161207.GB27863@elte.hu>
References: <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org>
	 <20080102194030.GC11638@parisc-linux.org>
	 <1199304735.3258.53.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org>
	 <1199316785.3258.85.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org>
	 <m3ir27oe7f.fsf@telia.com> <1199627875.5205.1.camel@localhost.localdomain>
	 <20080106144706.GA25419@elte.hu>
	 <1199632845.5205.31.camel@localhost.localdomain>
	 <20080106161207.GB27863@elte.hu>
Content-Type: text/plain
Date: Sun, 06 Jan 2008 11:10:07 -0600
Message-Id: <1199639407.5205.60.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-01-06 at 17:12 +0100, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > > The reproducer came to you via Peter Osterlund who has never 
> > > authored a single drivers/scsi/ commit before (according to git-log) 
> > > and who (and here i'm out on a limb guessing it) does not even 
> > > follow linux-scsi@vger.kernel.org.
> > > 
> > > this bug was obscure and hidden on linux-scsi@vger.kernel.org for 
> > > _months_, (it is a rarely visited and rarely read mailing list) and 
> > > there was just not enough "critical mass" to get this issue fixed.
> > 
> > If I were you, I'd actually make a cursory effort to get my facts 
> > straight before spouting off.
> > 
> > This bug was actually hidden in bugzilla for ages, where Matthew 
> > Wilcox was trying to deal with it on his own. [...]
> 
> Huh? The bugzilla just tracked a bug reported to lkml. The very
> description of the bugzilla says:
> 
>  Subject         : v2.6.24-rc2-409-g9418d5d: attempt to access beyond end of device
>  Submitter       : Thomas Meyer <thomas@m3y3r.de>
>  References      : http://lkml.org/lkml/2007/11/13/250
> 
> so no, it was evidently not "hidden in bugzilla for ages" - all the 
> important action happened on lkml.

... and your original accusation was "this bug was obscure and hidden on
linux-scsi@vger.kernel.org for _months_" which I was pointing out wasn't
true.

Even the original lkml report was obscured by sweeping the report into
bugzilla and forgetting about it, so in fact, no action happened, even
on lkml.

The history is that I was made aware of the bug on 18 Dec.  I suggested
then it was a pktcdvd problem and actually cc'd the wrong maintainer ...
again an error which is compounded by following this single person
workflow bugzilla requires.  I also told you in no uncertain terms that
it wasn't caused by the commit you were trying to blame, but that didn't
stop the crusade to affix blame and close the bug without doing proper
root cause analysis.

Can we stop it with the recriminations and blame shifting now.  The
problem we need to solve is fixing our broken bug resolution workflow.

My suggestion (for actually the third time in various fora) is:

        to get the best of both worlds, file a bugzilla and note the
        bugid. Then email a complete report to the relevant list, but
        add [BUG <bugid>] to the subject line and cc
        bugme-daemon@bugzilla.kernel.org  If you do this, bugzilla will
        keep track of the entire discussion as it progresses and allow
        those who track bugs through bugzilla to get a pretty accurate
        idea of the status.  You should never need to touch bugzilla
        again once the initial bug report is filed: all future
        information flow is via the mailing lists.
        
I don't give a toss what you recommend the default list to be ... use
lkml if you wish.  There are a lot of people who will vector it back on
to linux-scsi and keep lkml in the cc.

I also think that bug reports need to be complete, so copy the
information from the mailing list, don't just give a URL ... one of the
other enforced breaks in workflow is that the URL in the original
bugzilla wasn't working when we all tried to look at the original email
on 18 Dec, that's why you get several comments asking for more
information and where the original thread is.

James


