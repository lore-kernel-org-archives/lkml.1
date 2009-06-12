Return-Path: <linux-kernel-owner+w=401wt.eu-S1765178AbZFLS2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765178AbZFLS2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 14:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbZFLS2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 14:28:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48051 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754085AbZFLS2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 14:28:35 -0400
Date: Fri, 12 Jun 2009 19:28:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because
 there's no local APIC
Message-ID: <20090612192830.16224709@lxorguk.ukuu.org.uk>
In-Reply-To: <4A329CF8.4050502@goop.org>
References: <4A329CF8.4050502@goop.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +		if (error == -EINVAL) {
> +			/*
> +			 * The ACPI tables themselves were malformed.
> +			 * Dell Precision Workstation 410, 610 come here.
> +			 */
> +			printk(KERN_ERR PREFIX
> +			       "Invalid BIOS MADT, disabling ACPI\n");
> +			disable_acpi();
> +		} else {

This seems a very bad model. On todays systems turning off ACPI renders
them basically useless. If the MADT is bogus its far better to pray that
they rest of the ACPI is mostly sound and continue by ignoring the only
dodgy table.

Alan
