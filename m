Return-Path: <linux-kernel-owner+w=401wt.eu-S932208Ab0A1S4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab0A1S4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 13:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203Ab0A1S4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 13:56:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755946Ab0A1S4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 13:56:15 -0500
Date: Thu, 28 Jan 2010 10:54:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Jeff Garrett <jeff@jgarrett.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Myron Stowe <myron.stowe@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86/pci: print ioh resources only
In-Reply-To: <4B61D7C4.1050405@kernel.org>
Message-ID: <alpine.LFD.2.00.1001281052510.22433@localhost.localdomain>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <201001261348.59508.rjw@sisk.pl> <201001261032.37053.bjorn.helgaas@hp.com> <201001261902.13911.rjw@sisk.pl> <20100126101752.78196900@jbarnes-piketon> <4B5F735B.2040308@kernel.org> <alpine.LFD.2.00.1001271748300.3570@localhost.localdomain>
 <20100127192409.79af96db@jbarnes-piketon> <20100128040226.GB8964@jgarrett.org> <20100128082432.05a97ebc@jbarnes-piketon> <4B61D7C4.1050405@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 28 Jan 2010, Yinghai Lu wrote:
> @@ -43,7 +43,7 @@ static void __devinit pci_root_bus_res(s
>  {
>  	u16 word;
>  	u32 dword;
> -	struct pci_root_info *info;
> +	struct pci_root_info info;

That structure is something like a kilobyte in size, please don't put 
those things on the stack (sixteen "struct resource" entries).

		Linus
