Return-Path: <linux-kernel-owner+w=401wt.eu-S1760678AbYBSKaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760678AbYBSKaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 05:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbYBSKaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 05:30:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36936 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268AbYBSK37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 05:29:59 -0500
Date: Tue, 19 Feb 2008 11:29:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: fix dma_alloc_pages
Message-ID: <20080219102944.GA25663@elte.hu>
References: <200802190221.46552.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802190221.46552.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> one system with two nodes and two ht links on every node. the bios 
> already have _pxm for two links.
> 
> when no ram installed for node1 will have panic.
> 
> reason: the device on second chain will get node = 1 from 
> dev_to_node...via pci_acpi_scan_root. but node1 doesn't have ram 
> installed. in dma_alloc_pages it will pass check with 
> first_node(node_online_map)... and will have problem with 
> __alloc_pages in alloc_pages_node.
> 
> this patch will check the if the node is online..., if not will get 
> numa_node_id to get one node with ram.

thanks, applied.

	Ingo
