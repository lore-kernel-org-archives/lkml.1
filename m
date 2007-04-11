Return-Path: <linux-kernel-owner+w=401wt.eu-S1753094AbXDKQGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbXDKQGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 12:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbXDKQGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 12:06:23 -0400
Received: from are.twiddle.net ([64.81.246.98]:58105 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbXDKQGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 12:06:22 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Apr 2007 12:06:22 EDT
Date: Wed, 11 Apr 2007 09:05:20 -0700
From: Richard Henderson <rth@twiddle.net>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jay Estabrook <jay.estabrook@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] ALPHA: support graphics on non-zero PCI domains
Message-ID: <20070411160520.GB12573@twiddle.net>
Mail-Followup-To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jay Estabrook <jay.estabrook@hp.com>, linux-kernel@vger.kernel.org
References: <20070411123048.H17547@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070411123048.H17547@jurassic.park.msu.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 12:30:48PM +0400, Ivan Kokshaysky wrote:
> +VGA_MAP_MEM(unsigned long xaddr, unsigned int size)
> +{
> +	/* Create a new VGA ioport resource WRT the hose it is on. */
> +	if (pci_vga_hose && pci_vga_hose->index) {
> +		static struct resource alpha_vga =
> +		  { .name = "alpha-vga+", .start = 0x3C0, .end = 0x3DF };
> +		struct resource new_vga = alpha_vga;
> +
> +		new_vga.start += pci_vga_hose->io_space->start;
> +		new_vga.end   += pci_vga_hose->io_space->start;
> +		request_resource(&ioport_resource, &new_vga);

This leaks the local stack frame variable new_vga into the
resource tree, does it not?  Shouldn't you be kmallocing this?


r~
