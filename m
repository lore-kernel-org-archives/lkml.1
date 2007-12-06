Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbXLFH73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbXLFH73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 02:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbXLFH7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 02:59:21 -0500
Received: from gate.crashing.org ([63.228.1.57]:54186 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbXLFH7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 02:59:21 -0500
Subject: Re: [PATCH] pci: Fix bus resource assignment on 32 bits with 64b
	resources
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Greg KH <greg@kroah.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071206063940.GA16474@kroah.com>
References: <20071205064116.D849BDE10A@ozlabs.org>
	 <1196911347.7033.15.camel@pasglop>  <20071206063940.GA16474@kroah.com>
Content-Type: text/plain
Date: Thu, 06 Dec 2007 18:58:54 +1100
Message-Id: <1196927934.7033.39.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-12-05 at 22:39 -0800, Greg KH wrote:
> > that is  it can be either unsigned int, unsigned long or unsigned
> long
> > long... and we have no way to reliably printk that.
> 
> We do this already just fine.  Take a look in the kernel, I think we
> just always cast it to long long to be uniform.

I wanted to avoid that for two reasons:

 - casts are fugly
 - it adds support code to cast & handle 64 bits to 32 bits platforms
   that wouldn't normally need it

Now, if you really think that's the way to go, I'll respin with casts
(I've used cast in subsequent patches merging bits & pieces of the
powerpc 32 and 64 bits PCI code too in fact).

I was just hoping somebody had a better idea, like a way to add a new
format specifier to printk without losing gcc type checking :-)

Cheers,
Ben.


