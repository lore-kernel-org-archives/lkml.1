Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbXL0VVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbXL0VVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 16:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbXL0VVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 16:21:24 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:56375 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbXL0VVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 16:21:23 -0500
Date: Thu, 27 Dec 2007 14:21:21 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Loic Prylli <loic@myri.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>, Jeff Garzik <jeff@garzik.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver opt-in
Message-ID: <20071227212121.GD11638@parisc-linux.org>
References: <fa.m7tRTz/ymu3iMyLTO2aF1Tvaw24@ifi.uio.no> <fa.XrRLIuL4juNAXXaMPF3iY8FyWW8@ifi.uio.no> <fa.H0fcNl3b6xVBwzWUgT72M4K6KOU@ifi.uio.no> <4773EBB4.2020805@shaw.ca> <alpine.LFD.0.9999.0712271023090.21557@woody.linux-foundation.org> <477414C9.3040906@myri.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477414C9.3040906@myri.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2007 at 04:10:33PM -0500, Loic Prylli wrote:
> The root pcie port implementation is obviously buggy. But did we confirm
> whether that hardware bug might be partly related to
> "configuration-retry-status" pcie-root handling as introduced/described in:
> 
> http://marc.info/?l=linux-kernel&m=110541914926842&w=2
> 
> Does the 0001 vendor-id still shows up if pci_enable_crs() has never
> been called?
> 
> Does anybody knows what was the original rational to call
> pci_enable_crs() by default?

If you don't call pci_enable_crs(), no device can return the retry
status, so it would be pointless having this code in the kernel at all.
If it turns out some devices are buggy, then obviously we shouldn't
enable it for them.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
