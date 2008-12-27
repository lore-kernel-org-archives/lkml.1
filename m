Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbYL0Asn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbYL0Asn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 19:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYL0Ase
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 19:48:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084AbYL0Asd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 19:48:33 -0500
Date: Fri, 26 Dec 2008 16:48:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kai Ruhnau <kai@tragetaschen.dyndns.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Boot hang after io scheduler registration
Message-Id: <20081226164827.48527739.akpm@linux-foundation.org>
In-Reply-To: <49556A37.8070202@tragetaschen.dyndns.org>
References: <49556A37.8070202@tragetaschen.dyndns.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Dec 2008 00:35:19 +0100 Kai Ruhnau <kai@tragetaschen.dyndns.org> wrote:

> Hi,
> 
> I have a somewhat weird hang problem when booting all recent kernel
> versions including 2.6.28: When I boot my system and let grub start the
> kernel after a 5 second timeout, the system will hang after registering
> the io schedulers (see below). However, when I choose the default grub
> entry manually by pressing ENTER in the menu, the kernel does not hang
> and continues the normal booting process.
> 
> Below, you can find the place of the hang and an excerpt of the messages
> that follow on a normal boot as well as some system information.
> 
> Thanks for your time on this problem.
> 
> Best regards
> Kai
> 
> # dmesg
> ...
> [    0.309379] io scheduler noop registered
> [    0.309473] io scheduler anticipatory registered
> [    0.309569] io scheduler deadline registered
> [    0.309679] io scheduler cfq registered (default)
> 
> Hang happens here.
> 
> Continuation when pressing ENTER in grub:
> 
> [    0.414098] pci 0000:01:00.0: Boot video device
> [    0.417068] pcieport-driver 0000:00:02.0: setting latency timer to 64
> [    0.417097] pcieport-driver 0000:00:02.0: found MSI capability
> [    0.417222] pcieport-driver 0000:00:02.0: irq 319 for MSI/MSI-X
> [    0.417231] pci_express 0000:00:02.0:pcie00: allocate port service
> [    0.417294] pci_express 0000:00:02.0:pcie03: allocate port service
> [    0.417376] pcieport-driver 0000:00:06.0: setting latency timer to 64
> [    0.417403] pcieport-driver 0000:00:06.0: found MSI capability
> [    0.417523] pcieport-driver 0000:00:06.0: irq 318 for MSI/MSI-X
> [    0.417532] pci_express 0000:00:06.0:pcie00: allocate port service
> [    0.417580] pci_express 0000:00:06.0:pcie03: allocate port service
> ...
> 

Please add `initcall_debug' to the kernel boot command line.  That
should tell us which initialisation function is getting stuck.

