Return-Path: <linux-kernel-owner+w=401wt.eu-S1753623AbXLFDW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbXLFDW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 22:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbXLFDWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 22:22:48 -0500
Received: from gate.crashing.org ([63.228.1.57]:33518 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbXLFDWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 22:22:47 -0500
Subject: Re: [PATCH] pci: Fix bus resource assignment on 32 bits with 64b
	resources
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071205064116.D849BDE10A@ozlabs.org>
References: <20071205064116.D849BDE10A@ozlabs.org>
Content-Type: text/plain
Date: Thu, 06 Dec 2007 14:22:27 +1100
Message-Id: <1196911347.7033.15.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-12-05 at 17:40 +1100, Benjamin Herrenschmidt wrote:
> The current pci_assign_unassigned_resources() code doesn't work properly
> on 32 bits platforms with 64 bits resources. The main reason is the use
> of unsigned long in various places instead of resource_size_t.
> 
> This fixes it, along with some tricks to avoid casting to 64 bits on
> platforms that don't need it in every printk around.
> 
> This is a pre-requisite for making powerpc use the generic code instead of
> its own half-useful implementation.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> This version fixes some stupid warnings when using 32 bits resources

 ... and has warnings on 64 bits platforms... GRRRR

This whole issue of printk vs. resource_size_t is a terrible mess :-(

Part of the problem is that resource_size_t can be either u32 or u64..

that is  it can be either unsigned int, unsigned long or unsigned long
long... and we have no way to reliably printk that.

Any clever idea before I start pushing filthy macros up linux/types.h ?

Cheers,
Ben.


