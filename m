Return-Path: <linux-kernel-owner+w=401wt.eu-S1760043AbYGRPxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043AbYGRPxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 11:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbYGRPxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 11:53:46 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:55514 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbYGRPxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 11:53:46 -0400
Date: Fri, 18 Jul 2008 17:52:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, robert.moore@intel.com,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: Endless ACPI errors on Linus tree (5b664cb235)
Message-ID: <20080718155244.GE32051@basil.nowhere.org>
References: <s5hzlof1ll2.wl%tiwai@suse.de> <87od4vqvaj.fsf@basil.nowhere.org> <s5htzencp02.wl%tiwai@suse.de> <s5hr69rz57u.wl%tiwai@suse.de> <s5hk5fjurag.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hk5fjurag.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 18 Jul 2008 15:52:41.0858 (UTC) FILETIME=[4FCA5620:01C8E8EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 05:48:39PM +0200, Takashi Iwai wrote:
> At Fri, 18 Jul 2008 15:34:13 +0200,
> I wrote:
> > 
> > At Fri, 18 Jul 2008 15:15:25 +0200,
> > I wrote:
> > > 
> > > At Fri, 18 Jul 2008 13:35:48 +0200,
> > > Andi Kleen wrote:
> > > > 
> > > > Takashi Iwai <tiwai@suse.de> writes:
> > > > 
> > > > > the boot with the latest Linus git tree fails on x86-64 due to the
> > > > > endless kernel messages like below:
> > > > >
> > > > >     ACPI Error (evpge-0710): No handler or method for GPE[10],
> > > > >     disabling event[20080609]
> > > > >
> > > > > It happens on today's tree and also on yesterday (33af79d12e).
> > > > > The config is below.
> > > > 
> > > > That was after the ACPI merge I assume?
> > > 
> > > Yes.
> > > 
> > > >  Do you have a full boot log?
> > > 
> > > Sorry, no.  The kernel shows the error message (the number after GPE
> > > constantly changing as 1x) endlessly, and couldn't boot up properly to
> > > get a log. 
> > > 
> > > > Revert candidates to test would be e38e8a0743b0e996a8a3fbea8908fe75a84f02c7
> > > > and c91d924e3af08d4f98eab6ebf81f2b8ce132448f (Bob, that were both
> > > > changes from you for evgpe.c). Can you see if reverting
> > > > those helps? If yes which?
> > > 
> > > Will give it a spin.
> > 
> > I reverting both, but it doesn't fix the problem.
> > 
> > Another finding is that the boot reaches to the exec of init, at
> > least.  So I could get a sane state with init=/bin/sh.  The message
> > appears after the init script running udevd.
> > 
> > Also, the machine could boot fine with the recent linux-next kernel,
> > at least, 20080711-0714.  (It failed for last couple of days, but it
> > can be irrelevant.)
> > 
> > I'll investigate a bit.  Any hints are appreciated.
> 
> OK, found out the bad commit via bisect.
> Reverting below fixes the boot problem.

Ah thanks. That one was on the revert list anyways becase
it caused some other problems.

-Andi
