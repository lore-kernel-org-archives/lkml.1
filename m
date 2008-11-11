Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbYKKICT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbYKKICT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 03:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYKKICG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 03:02:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752268AbYKKICF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:02:05 -0500
Date: Tue, 11 Nov 2008 00:01:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jarkko Lavinen <jlavi@iki.fi>
Cc: linux-kernel@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: i82875p_edac: BAR 0 collision
Message-Id: <20081111000152.271d9706.akpm@linux-foundation.org>
In-Reply-To: <20081107114355.GA31730@piipiip.net>
References: <20081107114355.GA31730@piipiip.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

On Fri, 7 Nov 2008 13:43:55 +0200 Jarkko Lavinen <jlavi@iki.fi> wrote:

> When I try to load i82875p_edac module on ASUS P4C800 Deluxe in 2.6.26
> or 2.6.27 it fails due to BAR 0 collision. On 2.6.25 the
> i82875p_edac works just fine.
> 
> Should i82875p_setup_overfl_dev() do some additional work to fix the
> missing resource of the hidden overflow device?
> 
> When I try load i82875p_edac module on 2.6.27 I get
> 
>   # modprobe i82875p_edac
>   FATAL: Error inserting i82875p_edac
>   (/lib/modules/2.6.27.4/kernel/drivers/edac/i82875p_edac.ko): No such device
> 
> And dmesg shows (from 2.6.27.4):
> 
>   EDAC MC: Ver: 2.1.0 Oct 30 2008
>   EDAC DEBUG: edac_pci_dev_parity_clear()
>   ...
>   EDAC DEBUG: edac_pci_dev_parity_clear()
>   EDAC DEBUG: edac_sysfs_setup_mc_kset()
>   EDAC DEBUG: edac_sysfs_setup_mc_kset() Registered '.../edac/mc' kobject
>   EDAC DEBUG: i82875p_init_one()
>   EDAC i82875p: i82875p init one
>   EDAC DEBUG: i82875p_probe1()
>   PCI: 0000:00:06.0 reg 10 32bit mmio: [fecf0000, fecf0fff]
>   pci 0000:00:06.0: device not available because of BAR 0 [0xfecf0000-0xfecf0fff] collisions
>   EDAC i82875p: i82875p_setup_overfl_dev(): Failed to enable overflow device
>   EDAC DEBUG: 875p init fail
> 
> On 2.6.25.19 loading i82875p_edac works just fine and dmesg shows:
> 
>   EDAC MC: Ver: 2.1.0 Nov  4 2008
>   EDAC i82875p: i82875p init one
>   EDAC MC0: Giving out device to 'i82875p_edac' 'i82875p': DEV 0000:00:00.0
>   EDAC PCI0: Giving out device to module 'i82875p_edac' controller 'EDAC PCI controller': DEV '0000:00:00.0' (POLLED)
> 

Might be an EDAC driver regression.  It might also be a consequence of
PCI address space management fiddlings, but I think most of the changes
there post-date 2.6.26?

