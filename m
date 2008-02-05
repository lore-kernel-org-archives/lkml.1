Return-Path: <linux-kernel-owner+w=401wt.eu-S1759814AbYBEVzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814AbYBEVzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757800AbYBEVzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:55:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53254 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757256AbYBEVzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:55:07 -0500
Date: Tue, 5 Feb 2008 22:54:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] x86 updates
Message-ID: <20080205215454.GA20724@elte.hu>
References: <20080204161219.GA8092@elte.hu> <alpine.LFD.1.00.0802051043550.9374@woody.linux-foundation.org> <20080205192236.GA26426@uranus.ravnborg.org> <20080205210508.GA14708@elte.hu> <20080205211710.GA27589@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205211710.GA27589@uranus.ravnborg.org>
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

* Sam Ravnborg <sam@ravnborg.org> wrote:

> > btw., what's the practical consequence of getting these section 
> > flags wrong - for example writable data can end up in executable 
> > section accidentally and be marked readonly by RODATA? Or can 
> > anything more serious happen? (they cannot get into any of the 
> > discarded sections, we filter for them explicitly in the linker 
> > scripts)
>
> I have not investigated this. My attention were due to section 
> mismatch warnings pointing to section names I could not find in the 
> code. When I did an objdump of vmlinux the funny section names were 
> gone so I expected ld had recognized them and merged them somehow - 
> but I did not look closer as my focus was to get rid of them anyway.

ah, indeed. if we have the same section name but different attributes 
then i guess gas/ld resolves the conflict by auto-generating these 
.1/.2, etc. artificial sections. They dont show up in the vmlinux 
because they went through the linker scripts that merges them into a 
single output section. But modpost picks up those pre-merge names.

> I also did a quick skimming of info ld - but no luck.

Peter pointed me to "info gas", which has a "Sections and Relocation" 
chapter.

	Ingo
