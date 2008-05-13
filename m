Return-Path: <linux-kernel-owner+w=401wt.eu-S1758195AbYEMMHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbYEMMHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbYEMMH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:07:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60216 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbYEMMHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:07:25 -0400
Date: Tue, 13 May 2008 14:07:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Manish Katiyar <mkatiyar@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Remove unused variable "cpu" from arch/x86/xen/setup.c
Message-ID: <20080513120707.GE32022@elte.hu>
References: <ea11fea30805111026o448f5711nc6db445db0995b5c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea11fea30805111026o448f5711nc6db445db0995b5c@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0216]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Manish Katiyar <mkatiyar@gmail.com> wrote:

>  Remove unused variable "cpu" from arch/x86/xen/setup.c

it's not unused:

>  void xen_enable_sysenter(void)
>  {
> -       int cpu = smp_processor_id();
>         extern void xen_sysenter_target(void);
>         /* Mask events on entry, even though they get enabled immediately */
>         static struct callback_register sysenter = {

          if (!boot_cpu_has(X86_FEATURE_SEP) ||
              HYPERVISOR_callback_op(CALLBACKOP_register, &sysenter) != 0) {
                 clear_cpu_cap(&cpu_data(cpu), X86_FEATURE_SEP);
                               ^^^^^^^^^^^^^^
                 clear_cpu_cap(&boot_cpu_data, X86_FEATURE_SEP);
          }

if it generates an unused variable warning on UP then per_cpu() needs to 
be fixed to do a (void)(cpu) to indicate use of that variable.

	Ingo
