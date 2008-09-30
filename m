Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbYI3RWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbYI3RWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 13:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYI3RWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 13:22:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124AbYI3RWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 13:22:13 -0400
Date: Tue, 30 Sep 2008 10:21:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rene Herman <rene.herman@keyaccess.nl>
cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Adam Belay <abelay@mit.edu>, Avuton Olrich <avuton@gmail.com>,
       Karl Bellve <karl.bellve@umassmed.edu>, Willem Riede <wriede@riede.org>,
       Matthew Hall <mhall@mhcomputing.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 2/2] PNP: don't check disabled PCI BARs for conflicts in
 quirk_system_pci_resources()
In-Reply-To: <alpine.LFD.2.00.0809301001280.3389@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0809301015210.4651@nehalem.linux-foundation.org>
References: <200809290953.56565.bjorn.helgaas@hp.com> <200809290957.59813.bjorn.helgaas@hp.com> <alpine.LFD.1.10.0809290912060.3265@nehalem.linux-foundation.org> <48E11EFA.8010402@keyaccess.nl> <alpine.LFD.2.00.0809291211330.3389@nehalem.linux-foundation.org>
 <48E1EF0E.8030006@keyaccess.nl> <alpine.LFD.2.00.0809300741320.3389@nehalem.linux-foundation.org> <48E24C6F.3030903@keyaccess.nl> <alpine.LFD.2.00.0809300904530.3389@nehalem.linux-foundation.org>
 <alpine.LFD.2.00.0809301001280.3389@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Sep 2008, Linus Torvalds wrote:
> 
> A clearer (and more flexible) solution might be this patch. It's more 
> explicit about the fact that it simply makes it clear that any drivers 
> that are added by the architecture Makefile will be _first_ in the list of 
> drivers.

It looks like both of these will fall afoul of the fact that ACPI 
currently seems to _expect_ to be called in the old order, ie I get some 
oops in acpi_irq_penalty_init() apparently because it knew that it got 
called later (thanks to being called from pci_acpi_init in the 
arch-specific directory), and knew that the other ACPI subsys setup 
routines had been done before.

Dang.

I guess we'll have to bite the bullet some day and actually create some 
explicit topological ordering of initcalls rather than depend on the 
initcall levels and link order. That is one particular complexity I've 
tried to avoid. But the subtlety of the current ordering is certainly not 
at all good either.

		Linus
