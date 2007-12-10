Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbXLJGUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbXLJGUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 01:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbXLJGUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 01:20:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:55994 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393AbXLJGUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 01:20:11 -0500
Subject: Re: [PATCH] pci: Fix bus resource assignment on 32 bits with 64b
	resources
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linuxppc-dev@ozlabs.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071210061559.2E3DDDDE02@ozlabs.org>
References: <20071210061559.2E3DDDDE02@ozlabs.org>
Content-Type: text/plain
Date: Mon, 10 Dec 2007 17:19:55 +1100
Message-Id: <1197267595.6563.58.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-12-10 at 17:15 +1100, Benjamin Herrenschmidt wrote:
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
> This version now uses casts as Greg asked for and adds proper setup
> of the prefetchable base & limit "upper" registers when using 64 bits
> resources.

Crap ! Ignore it. I forgot to quilt ref again... won't build.

Sending it again, with a separate patch fixing a warning in setup-res.c
that isn't directly related to the changes to setup-bus.c

Cheers,
Ben.


