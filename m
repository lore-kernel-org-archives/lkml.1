Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbZHQNpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbZHQNpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 09:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZHQNpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 09:45:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39718 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbZHQNpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 09:45:01 -0400
To: mark@bifferos.com
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86 CPU detection for RDC
From: Andi Kleen <andi@firstfloor.org>
References: <58001.1250437590@bifferos.com>
Date: Mon, 17 Aug 2009 15:44:58 +0200
In-Reply-To: <58001.1250437590@bifferos.com> (Mark Kelly's message of "Sun, 16 Aug 2009 16:46:30 +0100")
Message-ID: <87hbw6sgf9.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Kelly <mark@bifferos.com> writes:
> +{
> +	u16 vendor, device;
> +	
> +	/* RDC CPU is SoC (system-on-chip), Northbridge is always present. */
> +	vendor = read_pci_config_16(0, 0, 0, PCI_VENDOR_ID);
> +	device = read_pci_config_16(0, 0, 0, PCI_DEVICE_ID);

This needs some check first if PCI is even enabled. You can use
early_pci_allowed() for this or just add a handler in early quirks
that sets a flag you test here.

Also I would suggest to not hard code your own email addresses
in printk (which might go away), but use some list like linux-kernel.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
