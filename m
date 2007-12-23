Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbXLWEgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbXLWEgd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 23:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbXLWEgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 23:36:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44634 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514AbXLWEgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 23:36:23 -0500
Date: Sat, 22 Dec 2007 20:35:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
In-Reply-To: <476DDFEE.3010009@garzik.org>
Message-ID: <alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org>
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org>
 <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DDFEE.3010009@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 22 Dec 2007, Jeff Garzik wrote:

> My core assertion:  the present situation -- turning off MMCONFIG aggressively
> -- is greatly preferable to adding pci_enable_mmconfig_accesses(pdev).

Well, you do realize that right now we have to have _users_ just doing 
"pci=nommconf" on the kernel command line, because we apparently don't do 
it aggressively enough?

The fact is, we simply don't know what the breakage is. The only safe 
situation is to just assume things are broken, and enable it only when 
necessary.

And if there isn't a driver that needs it, then it sure as *hell* isn't 
necessary. 

			Linus
