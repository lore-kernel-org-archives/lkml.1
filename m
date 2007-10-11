Return-Path: <linux-kernel-owner+w=401wt.eu-S1758222AbXJKNw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222AbXJKNw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 09:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbXJKNwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 09:52:51 -0400
Received: from www.tglx.de ([62.245.132.106]:58280 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439AbXJKNwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 09:52:51 -0400
Date: Thu, 11 Oct 2007 15:51:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Joerg Roedel <joerg.roedel@amd.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Egger <Christoph.Egger@amd.com>
Subject: Re: [PATCH 1/2] x86: mce init optimization and signedness fixup
In-Reply-To: <1192105075473-git-send-email-joerg.roedel@amd.com>
Message-ID: <alpine.LFD.0.9999.0710111550400.15917@localhost.localdomain>
References: <11921050742274-git-send-email-joerg.roedel@amd.com> <1192105075473-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007, Joerg Roedel wrote:
> MCG_CAP never reports a negative count of available error-reporting banks.
> Therefore, make nr_mce_banks unsigned.
> Check for MCA/MCE feature bits as early as possible.

> +
> +	if (!cpu_has(c, X86_FEATURE_MCA) || !cpu_has(c, X86_FEATURE_MCE)) {
> +		printk(KERN_INFO "CPU%i: No machine check support available\n",
> +			smp_processor_id());
> +		return;

This breaks winchip MCE support.

     tglx

