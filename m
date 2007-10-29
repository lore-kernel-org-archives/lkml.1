Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbXJ2Hgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbXJ2Hgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 03:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbXJ2Hgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 03:36:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42752 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816AbXJ2Hgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 03:36:42 -0400
Date: Mon, 29 Oct 2007 00:36:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Rankin <rankincj@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [2.6.23.1] PCI device locking up the computer when its module
 loads
Message-Id: <20071029003640.6fe08168.akpm@linux-foundation.org>
In-Reply-To: <511770.44451.qm@web52902.mail.re2.yahoo.com>
References: <511770.44451.qm@web52902.mail.re2.yahoo.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 13:43:16 +0100 (BST) Chris Rankin <rankincj@yahoo.com> wrote:

> Hi,
> 
> I have a Netgear MA301 PLX wireless networking adapter which wants to use the hostap_plx driver in
> Linux 2.6.23.1. This very same piece of hardware works fine in an old(!) P120 machine running
> 2.4.33, but makes the 2.6.23.1 kernel freeze as soon as the pci_enable_device() function is called
> in prism2_plx_probe. What seems to happen is that IRQ 5 is signalled (the adapter's IRQ, according
> to lspci), but the handler function hasn't been installed yet and so the kernel disables IRQ 5 and
> locks up. However, the documentation that I have read implies that calling pci_enable_device()
> before requesting the IRQ number to install the handler on is "The Right Thing to do", because
> otherwise the IRQ number might change.
> 
> I have tried booting with "acpi=off nolapic" to no effect. The kernel is UP with 4K stacks and
> PREEMPT.
> 
> Can anyone suggest what a suitable fix might be, please? Because I am currently thinking "CLI" and
> "STI"!
> 

(+linux-wireless)
