Return-Path: <linux-kernel-owner+w=401wt.eu-S1762779AbYECJqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762779AbYECJqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 05:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759911AbYECJqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 05:46:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40381 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759910AbYECJqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 05:46:11 -0400
Date: Sat, 3 May 2008 11:45:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Adrian Bunk <bunk@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       linux-kernel@vger.kernel.org
Subject: Re: x86 git acpi issue?
Message-ID: <20080503094551.GA10805@elte.hu>
References: <481BAC6F.5090509@ct.jp.nec.com> <481BACEC.8080902@zytor.com> <20080503071332.GF5838@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805031123420.6003@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805031123420.6003@apollo.tec.linutronix.de>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Sat, 3 May 2008, Adrian Bunk wrote:
> > Commit afcab879e4044f952b7a031d5fd504e0feb7df41 is the commit where Ingo 
> > both _reverts_ his patch you describe in the x86 tree and additionally 
> > moves pci-$(CONFIG_ACPI) in exactly the way that causes this breakage.
> > 
> > In the 4 hours between Ingo doing the += change and Ingo reverting his 
> > own patch in the x86 tree it was in a pull request to Linus, so the
> > "queued up" patch is in Linus' tree but reverted in the x86 tree.
> > 
> > I saw neither the patch changing the :='s to += on linux-kernel nor does 
> > "do not override the existing pci-y rule when adding visws or numaq 
> > rules." in the commit description give any indication what the actual 
> > problem was.
> > 
> > It's also not obvious why the revert with the subject "visws: build fix" 
> > also moved the pci-$(CONFIG_ACPI) causing this bug here.
> 
> Right. This Makefile is a nasty trap. I looked into it and the fix for 
> now is below. Long term this Makefile trickery needs to be cleaned up 
> to avoid trapping into this again.

Thanks Thomas, i messed up that commit - i should have known that the 
NUMAQ build fix looked _too_ easy ;-)

	Ingo
