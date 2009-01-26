Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbZAZN3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbZAZN3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 08:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbZAZN3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 08:29:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45789 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbZAZN3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 08:29:00 -0500
Date: Mon, 26 Jan 2009 14:28:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: Fix setion mismatch warning.
Message-ID: <20090126132849.GA13567@elte.hu>
References: <b9df5fa10901231146k89cd1adoee590b6743bb349f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10901231146k89cd1adoee590b6743bb349f@mail.gmail.com>
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


* Rakib Mullick <rakib.mullick@gmail.com> wrote:

> Impact: Fix section mismatch warning.
> 
> Here function vmi_activate calls a init function activate_vmi , which
> causes the following section mismatch warnings. This patch fixes it.
> 
>   LD      arch/x86/kernel/built-in.o
> WARNING: arch/x86/kernel/built-in.o(.text+0x13ba9): Section mismatch
> in reference from the function vmi_activate() to the function
> .init.text:vmi_time_init()
> The function vmi_activate() references
> the function __init vmi_time_init().
> This is often because vmi_activate lacks a __init
> annotation or the annotation of vmi_time_init is wrong.
> 
> WARNING: arch/x86/kernel/built-in.o(.text+0x13bd1): Section mismatch
> in reference from the function vmi_activate() to the function
> .devinit.text:vmi_time_bsp_init()
> The function vmi_activate() references
> the function __devinit vmi_time_bsp_init().
> This is often because vmi_activate lacks a __devinit
> annotation or the annotation of vmi_time_bsp_init is wrong.
> 
> WARNING: arch/x86/kernel/built-in.o(.text+0x13bdb): Section mismatch
> in reference from the function vmi_activate() to the function
> .devinit.text:vmi_time_ap_init()
> The function vmi_activate() references
> the function __devinit vmi_time_ap_init().
> This is often because vmi_activate lacks a __devinit
> annotation or the annotation of vmi_time_ap_init is wrong.
> 
> 
> Thanks.
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

applied to tip/x86/urgent, thanks Rakib.

Note, the patch was corrupted here:

> +void __init vmi_activate(void)
>  {
>  	unsigned long flags;
> --

that's too short - context diffs have 3 closing lines. I fixed this up 
manually.

I also fixed the typo in the subject line.

Thanks,

	Ingo
