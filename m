Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbZBBUmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbZBBUmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbZBBUl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:41:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753316AbZBBUl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:41:58 -0500
Date: Mon, 2 Feb 2009 12:41:31 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andreas Schwab <schwab@suse.de>
Subject: Re: PCI PM: Restore standard config registers of all devices early
In-Reply-To: <1233606580.18767.93.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0902021236040.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>  <1233568479.18767.86.camel@pasglop>  <alpine.LFD.2.00.0902020902320.4704@localhost.localdomain> <1233606580.18767.93.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Benjamin Herrenschmidt wrote:
> 
> I'd rather hook it up inside pci_set_power_state()...

Umm. But you already _have_ that. Look at platform_pci_set_power_state(). 
It gets called before turning the device on (pci_raw_set_power_state(D0)) 
and after turning the device off (pci_raw_set_power_state(D1+))

Maybe you missed it? It's how ACPI does things.

However, the issue you see is that pci_restore_standard_config() doesn't 
call it, because at least with ACPI, the ACPI code simply isn't ready to 
be called with interrupts off. So it looks like you may be looking at the 
wrong thing, hmm?

			Linus
