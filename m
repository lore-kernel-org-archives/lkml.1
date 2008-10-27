Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbYJ0Lmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbYJ0Lmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 07:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbYJ0Lmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 07:42:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45572 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbYJ0Lma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 07:42:30 -0400
Date: Mon, 27 Oct 2008 12:42:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Pavel Machek <pavel@suse.cz>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Richard Purdie <rpurdie@rpsys.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] SGI X86 UV: Provide a System Activity Indicator
	driver
Message-ID: <20081027114205.GB5631@elte.hu>
References: <4901AF28.4070606@sgi.com> <20081024120103.GD1680@elf.ucw.cz> <20081024120544.GA9812@elte.hu> <4901BF30.3090708@sgi.com> <87mygt9815.fsf@basil.nowhere.org> <490249CF.2080308@sgi.com> <49024B1D.1050407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49024B1D.1050407@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Subject: SGI X86 UV: Provide a System Activity Indicator driver
> 
> The SGI UV system has no LEDS but uses one of the system controller
> regs to indicate the online internal state of the cpu.  There is a
> heartbeat bit indicating that the cpu is responding to interrupts,
> and an idle bit indicating whether the cpu is idle when the heartbeat
> interrupt occurs.  The current period is one second.
> 
> When a cpu panics, an error code is written by BIOS to this same reg.
> 
> This patchset provides the following:
> 
>   * x86_64: Add base functionality for writing to the specific SCIR's
>     for each cpu.
> 
>   * heartbeat: Invert "heartbeat" bit to indicate the cpu is
>     "interruptible".  If the current thread is the idle thread,
>     then indicate system is "idle".
> 
>   * if hotplug enabled, all bits are set (0xff) when the cpu is disabled.
> 
> Based on linux-2.6.tip/master.
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
>  arch/x86/include/asm/uv/uv_hub.h |   63 +++++++++++++++++++++++-
>  arch/x86/kernel/genx2apic_uv_x.c |  102 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 164 insertions(+), 1 deletion(-)

applied to tip/x86/uv, thanks Mike!

Please send the cpu_idle() cleanup patch separately.

Another minor thing i noticed:

@@ -130,7 +140,9 @@ struct uv_hub_info_s {
 	unsigned char	blade_processor_id;
 	unsigned char	m_val;
 	unsigned char	n_val;
+	struct uv_scir_s scir;

please align the new field vertically, like they were aligned before - 
by adding another tab to the whole lineup. (This will also make it 
appear nicer when viewed together with followup definitions below this 
section)

	Ingo
