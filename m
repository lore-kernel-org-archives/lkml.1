Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbZF3WJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbZF3WJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbZF3WJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:09:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46439 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612AbZF3WJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:09:44 -0400
Date: Wed, 1 Jul 2009 00:09:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: tony.luck@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, hpa@zytor.com,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reduce export symbol CRC table size on 64-bit archs
Message-ID: <20090630220932.GE1241@elte.hu>
References: <4A4A18780200007800008345@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4A18780200007800008345@vpn.id2.novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@novell.com> wrote:

> Since these CRCs are really only 32-bit quantities, there's no 
> need to store them in 64-bit slots. Since, however, gcc doesn't 
> allow respective initializations, asm() constructs get used to 
> create the CRC tables (and its for that reason that the patch only 
> makes x86-64 and ia64 utilize that functionality, as I can't 
> verify this doesn't break in some subtle way elsewhere).
> 
> Observed size reduction (x86-64):
> - 16k kernel resident size
> - 2k module resident size
> - 1M vmlinux image size
> 
> If the asm() construct could be extended to all architectures, and 
> if modpost would guarantee generation of CRCs for all exported, 
> then the __crc_* symbols wouldn't need to be declared weak 
> anymore, could hence remain local to the exporting object. By 
> adding -Wa,-strip-local-absolute to the second compilation step 
> the __crc_* symbols could even be prevented from making it into 
> any object file at all.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

> 
> ---
>  arch/ia64/include/asm/module.h |    2 ++
>  arch/x86/include/asm/module.h  |    1 +
>  include/linux/module.h         |   41 ++++++++++++++++++++++++++---------------
>  include/linux/moduleparam.h    |   10 +++++++++-
>  kernel/module.c                |   26 +++++++++++++-------------
>  scripts/genksyms/genksyms.c    |   16 ++++++++--------
>  6 files changed, 59 insertions(+), 37 deletions(-)

No objections to the (minor) x86 bits.

	Ingo
