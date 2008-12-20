Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbYLTTbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbYLTTbc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 14:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbYLTTbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 14:31:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33836 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbYLTTbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 14:31:23 -0500
Date: Sat, 20 Dec 2008 20:31:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [git pull] x86 fixes
Message-ID: <20081220193106.GA19555@elte.hu>
References: <20081220134353.GA16399@elte.hu> <alpine.LFD.2.00.0812201112210.14014@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812201112210.14014@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 20 Dec 2008, Ingo Molnar wrote:
> > 
> > Joerg Roedel (3):
> >       AMD IOMMU: panic if completion wait loop fails
> 
> What's the advantage to this, especially this late in the game?
> 
> Now, I tried to google for the message (while ignoring the patches), and 
> as far as I can tell, it has never happened that google has noticed. But 
> still, why was this pushed as a "fix"?

You are right, this patch should have been delayed to .29. Should i rebase 
the branch?

Joerg has been doing stress-tests of the iommu driver and these fixes are 
the result of that. I pulled three patches from Joerg in one group, and 
the other two were real fixes - and this one looked indeed unnecessary but 
harmless, so i didnt ask him to rebase. CONFIG_AMD_IOMMU is default-off 
and a relatively new driver, and the patch came from the hw vendor 
affected by it so i let it through. When i pulled i assumed i could get it 
in before -rc9 but once you released -rc9 the pull was done already. I 
wouldnt have pulled such a patch so close before final .28. The timing was 
a bit unfortunate - can rebase and re-test. Same deal for:

   55aab5f: x86 gart: don't complain if no AMD GART found

i wouldnt have put it in after the final -rc.

	Ingo
