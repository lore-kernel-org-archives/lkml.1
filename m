Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbYGRI11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbYGRI11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 04:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYGRI1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 04:27:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43678 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbYGRI1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 04:27:13 -0400
Date: Fri, 18 Jul 2008 10:26:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/6] x86 tracehook patches
Message-ID: <20080718082658.GH6875@elte.hu>
References: <20080717074550.EE1E215411D@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717074550.EE1E215411D@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> Hi!  Here is the x86 arch work that goes with the "tracehook" patch 
> series that I posted for the generic code.  I don't know how the 
> merging will go with that.  But when there is a tree containing all 
> that to base it on, you can merge these arch patches on top of that. 
> You can't take these without the generic tracehook series, some will 
> break the build until the generic file is there.
> 
> This series also requires as a baseline what you have in tip/x86/step.
> 
> The following changes since commit dc2cda6931dd54cd02b05da3a5bc969032e10992:
>   Roland McGrath (1):
>         x86 ptrace: user-sets-TF nits
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-utrace.git x86-tracehook
> 
> Roland McGrath (6):
>       x86: tracehook_signal_handler
>       x86: tracehook syscall
>       x86: tracehook: asm/syscall.h
>       x86 signals: use asm/syscall.h
>       x86: tracehook: TIF_NOTIFY_RESUME
>       x86: tracehook: CONFIG_HAVE_ARCH_TRACEHOOK

since Andrew picked up the generic bits into -mm i cannot put the 
generic+x86 bits into -tip.

Andrew, could you please pick up these x86 bits as well?

  Reviewed-by: Ingo Molnar <mingo@elte.hu>

Roland, a sidenote: your sha1's did not match that of tip/x86/step.

It's not a big issue in this case because Andrew takes patches but best 
practice is to not rebase commits you base future pull requests on. 
(rebasing is fine until something is WIP and put pushed/pulled - but 
it's lethal to transparency and mergability once patches have been 
published, so we try to avoid it as much as possible)

The way you could rebase existing commits back ontop of x86/step is to 
do this in your tracehook branch:

   git-rebase -i --onto tip/x86/step linus/master

(and if you've got fixes for x86/step then please send them as a pull 
request that just adds the fix in an append-only manner.)

	Ingo
