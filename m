Return-Path: <linux-kernel-owner+w=401wt.eu-S1759580AbXJYMr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580AbXJYMr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 08:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbXJYMrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 08:47:17 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:40081 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbXJYMrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 08:47:16 -0400
X-Greylist: delayed 1450 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Oct 2007 08:47:16 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=pXjv5lh2XDMSAdqKHmfLbXZ++rTaSINdZk+7ViZdODNTCR96XbRMI8SaaFCAi
	9j/1ov9IKPXGHNJDxjPXh1KIg==
Date: Thu, 25 Oct 2007 14:23:03 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Bill Gatliff <bgat@billgatliff.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Russell King <rmk@arm.linux.org.uk>, svs1957@gmail.com
Subject: Re: [Bugme-new] [Bug 9217] New: CONFIG_CMDLINE doesn't pass to kernel
Message-ID: <20071025122303.GB7543@xi.wantstofly.org>
References: <bug-9217-10286@http.bugzilla.kernel.org/> <20071024195717.0de6a248.akpm@linux-foundation.org> <47200F05.2050305@billgatliff.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47200F05.2050305@billgatliff.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 10:35:33PM -0500, Bill Gatliff wrote:

> >Something broke CONFIG_CMDLINE of ARM (at least) between 2.6.22 and 2.6.23.
> >
> >I don't know whether it was an ARM patch one of those kernel-wide changes. 
> >We have futzed with the command-line parsing a bit recently, but the 2.6.23
> >changelog doesn't suggest anything obvious.
> 
> What does the affected system's bootloader pass in r2?  If it's nonzero, 
> ARM's 2.6.23 may interpret it as being an ATAGS pointer.  And when that 
> happens, the system prefers the ATAGS over CONFIG_CMDLINE.
> 
> There's sanity checking in __vet_atags, but maybe it isn't enough.  
> Other than that, I can't see anything yet.

If this is the SHARP Shepherd (which seems to be the Zaurus SL-C750,
which looks like it's the one the submitter is using), it's not setting
boot_params at all:

	MACHINE_START(SHEPHERD, "SHARP Shepherd")
		.phys_io        = 0x40000000,
		.io_pg_offst    = (io_p2v(0x40000000) >> 18) & 0xfffc,
		.fixup          = fixup_corgi,
		.map_io         = pxa_map_io,
		.init_irq       = pxa25x_init_irq,
		.init_machine   = corgi_init,
		.timer          = &pxa_timer,
	MACHINE_END
