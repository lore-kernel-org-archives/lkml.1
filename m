Return-Path: <linux-kernel-owner+w=401wt.eu-S934507AbYBVMsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934507AbYBVMsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 07:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbYBVMsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 07:48:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40882 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbYBVMsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 07:48:46 -0500
Date: Fri, 22 Feb 2008 13:48:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: don't print a warning when MTRR are blank and
	running in KVM
Message-ID: <20080222124830.GA25902@elte.hu>
References: <1203605414-4958-1-git-send-email-joerg.roedel@amd.com> <20080221203748.GA9031@elte.hu> <47BDFBDE.5040102@zytor.com> <20080222094513.GA6269@elte.hu> <47BE9CB7.5070609@zytor.com> <20080222100044.GA6807@elte.hu> <20080222111518.GA6504@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222111518.GA6504@amd.com>
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> > ok. Then i guess we should just leave the warning and the backtrace 
> > in place until they get a fix done?
> 
> No. I don't agree. The MTRRs are set up by the BIOS because it knows 
> the hardware best (I know this is only true in theory). The OS should 
> basically trust the BIOS MTRR settings. If the OS can't trust the 
> BIOS, like on real hardware, the check and the warning is necessary. 
> If the OS can trust the BIOS, like running in a KVM or QEMU virtual 
> machine, it should just ignore the case where all MTRRs are blank.

well, i can agree with the warning being pointless on KVM paravirt, but 
it's not pointless in the Qemu context.

we fundamentall _dont_ trust the BIOS's MTRR settings, just check the 
very function that you modified: mtrr_trim_uncached_memory() - that 
function handles _exactly_ a case where a BIOS messes up MTRR's. This 
problem has caused real user-side breakage and just not emitting a 
warning because Qemu is lazy to emulate a proper PC is not a strong 
enough argument.

so i've applied the KVM bits but the warning stays for Qemu.

	Ingo
