Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752270AbYLRHtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbYLRHtj (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 02:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbYLRHt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 02:49:29 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49925 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbYLRHt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 02:49:29 -0500
Date: Thu, 18 Dec 2008 08:33:04 +0100
From: Pavel Machek <pavel@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow HPET force enable on ICH10 HPET
Message-ID: <20081218073304.GA2110@ucw.cz>
References: <20081216013547.GA24992@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216013547.GA24992@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-12-16 02:35:47, Andi Kleen wrote:
> Allow HPET force enable on ICH10 HPET
> 
> Intel "Smackover" x58 BIOS don't have HPET enabled in the BIOS, so allow
> to force enable it at least. The register layout is the same
> as in other recent ICHs, so all the code can be reused.
> 
> Using numerical PCI-ID because it's unlikely the PCI-ID will be used
> anywhere else.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Why not fix it properly... in the BIOS?

> @@ -170,7 +170,8 @@
>  			 ich_force_enable_hpet);
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_7,
>  			 ich_force_enable_hpet);
> -
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x3a16,	/* ICH10 */
> +			 ich_force_enable_hpet);
>  
>  static struct pci_dev *cached_dev;


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
