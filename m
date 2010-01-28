Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971Ab0A1Bvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab0A1Bvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 20:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906Ab0A1Bvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 20:51:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753760Ab0A1Bvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 20:51:45 -0500
Date: Wed, 27 Jan 2010 17:50:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Jeff Garrett <jeff@jgarrett.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Myron Stowe <myron.stowe@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with
 pci=use_crs)
In-Reply-To: <4B5F735B.2040308@kernel.org>
Message-ID: <alpine.LFD.2.00.1001271748300.3570@localhost.localdomain>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <201001261348.59508.rjw@sisk.pl> <201001261032.37053.bjorn.helgaas@hp.com> <201001261902.13911.rjw@sisk.pl> <20100126101752.78196900@jbarnes-piketon> <4B5F735B.2040308@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Jan 2010, Yinghai Lu wrote:
> 
> [PATCH] x86/pci: don't use ioh resource if only have one ioh

Please, no.

This patch is too ugly to live.

And it's totally unacceptable to probe every single possible PCI device 
for something like this.

If we don't know enough about the hardware workings of those Intel bridges 
to know when they are active and how they decode things, then please let's 
just disable intel_bus.c entirely.

There's no excuse for hacky tests like this.

			Linus
