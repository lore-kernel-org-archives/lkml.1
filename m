Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbYHIOET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbYHIOET (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 10:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbYHIOEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 10:04:04 -0400
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:48656 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039AbYHIOEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 10:04:02 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH 1/1] [x86] Configuration options to compile out x86 CPU support code
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       michael@free-electrons.com
Reply-To: 7eggert@gmx.de
Date: Sat, 09 Aug 2008 16:08:57 +0200
References: <20030410181011$6d15@gated-at.bofh.it> <aXrl4-2FX-1@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1KRp7q-0001pd-61@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Petazzoni <thomas.petazzoni@free-electrons.com> wrote:

> This patch adds some configuration options that allow to compile out
> CPU vendor-specific code in x86 kernels (in arch/x86/kernel/cpu). The
> new configuration options are only visible when CONFIG_EMBEDDED is
> selected, as they are mostly interesting for space savings reasons.

> +menuconfig PROCESSOR_SELECT
> +     default y
> +     bool "Supported processor vendors" if EMBEDDED
> +     help
> +       This lets you choose what x86 vendor support code your kernel
> +       will include.
> +
> +config CPU_SUP_INTEL_32
> +     default y
> +     bool "Support Intel processors" if PROCESSOR_SELECT
> +     depends on !64BIT
> +     help
> +       This enables extended support for Intel processors
> +

I don't think having a generic kernel for only Intel CPUs makes much sense,
and OTOH, if you optimize for e.g. Athlon CPUs, you're likely to not need
Intel code on that machine - even on desktop systems.

What about an option to "Include code for CPUs from all supported vendors",
invisible and y for generic kernels?

