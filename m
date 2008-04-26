Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbYDZOml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbYDZOml (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 10:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbYDZOmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 10:42:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45372 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbYDZOmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 10:42:31 -0400
Date: Sat, 26 Apr 2008 16:42:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [git pull] x86 PAT changes
Message-ID: <20080426144203.GA19635@elte.hu>
References: <20080424225625.GB8717@elte.hu> <481330C6.7040109@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481330C6.7040109@googlemail.com>
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


* Gabriel C <nix.or.die@googlemail.com> wrote:

> Hi Ingo,
> 
> When using an 64bit ( didn't got time to test 32bit now ) kernel[1] 
> with PAT enabled , kvm-intel does not work anymore.
> 
> When modprobing kvm-intel , kvm is saying VT extension is disable by 
> BIOS which isn't true. When disabling PAT again ( no changes to BIOS ) 
> kvm-intel works again here.
> 
> Is that an known problem ?

no, that side-effect was not known. Cc:-ed more folks.

> If you need more infos just let me know.
> 
> Gabriel
> 
> [1]  2.6.25-05096-gb1721d0-dirty
>      with following patches :
>      http://lkml.org/lkml/2008/4/26/37
>      http://lkml.org/lkml/2008/4/26/24
>      http://lkml.org/lkml/2008/4/25/107

thanks - that should be enough for now. We'll try to reproduce these 
problems.

A blind guess: maybe it's the CONFIG_NONPROMISC_DEVMEM somehow breaks 
Qemu. With the patch below you'd be able to disable NONPROMISC_DEVMEM 
without disabling PAT.

	Ingo

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4d350b5..4aa4180 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1049,9 +1049,9 @@ config MTRR
 	  See <file:Documentation/mtrr.txt> for more information.
 
 config X86_PAT
-	def_bool y
+	bool
 	prompt "x86 PAT support"
-	depends on MTRR && NONPROMISC_DEVMEM
+	depends on MTRR
 	help
 	  Use PAT attributes to setup page level cache control.
 
