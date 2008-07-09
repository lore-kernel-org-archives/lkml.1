Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbYGIGTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbYGIGTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 02:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYGIGTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 02:19:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40276 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbYGIGTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 02:19:40 -0400
Date: Wed, 9 Jul 2008 08:19:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 6/7] x86: traps_xx: modify default_do_nmi
Message-ID: <20080709061922.GH9760@elte.hu>
References: <20080701193643.GA29695@mailshack.com> <20080701233227.GF29903@mailshack.com> <20080702161220.GA7003@cvg> <20080702163901.GA1283@mailshack.com> <20080702171637.GB7003@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080702171637.GB7003@cvg>
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

* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> [Alexander van Heukelum - Wed, Jul 02, 2008 at 06:39:01PM +0200]
> |  - local caching of smp_processor_id() in default_do_nmi()
> |  - v2: do not split default_do_nmi over two lines
> | 
> | Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> | 
> | ---
> | 
> | On Wed, Jul 02, 2008 at 08:12:20PM +0400, Cyrill Gorcunov wrote:
> | > | -static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
> | > | +static notrace __kprobes void
> | > | +default_do_nmi(struct pt_regs *regs)
> | > | [ ... ]
> | > | -asmlinkage notrace  __kprobes void default_do_nmi(struct pt_regs *regs)
> | > | +asmlinkage notrace __kprobes void
> | > | +default_do_nmi(struct pt_regs *regs)
> | > 
> | > Hi Alexander, good done, thanks! But why did you split default_do_nmi
> | > definition by two lines? I think it would be better to keep them as it
> | > was before, ie by a single line
> | > 
> | > 	static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
> | 
> | Thanks! Here is the replacement patch with default_do_nmi left on
> | a single line. Patch 7 applies with 1 line fuzz.
> | 
> | Greetings,
> |     Alexander
> | 
> 
> Thanks, Alexander, this looks good to me. Feel free to add my 
> Signed-off if you need it.

Thanks Alexander, i've picked them up into tip/x86/core:

 Alexander van Heukelum (7):
      x86: initial changes to unify traps_32.c and traps_64.c
      x86: traps_xx: shuffle headers and globals
      x86: traps_xx: modify __die
      x86: traps_xx: modify do_trap
      x86: traps_xx: restructure do_general_protection()
      x86: traps_xx: modify default_do_nmi
      x86: traps_xx: various small changes

i've added Cyrill's Acked-by lines as well. (We use Signed-off is when 
routing patches)

	Ingo
