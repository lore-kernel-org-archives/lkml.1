Return-Path: <linux-kernel-owner+w=401wt.eu-S935277AbZLPXgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935277AbZLPXgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757326AbZLPXgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:36:16 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:34038 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757323AbZLPXgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:36:15 -0500
Date: Thu, 17 Dec 2009 10:36:13 +1100
From: Simon Horman <horms@verge.net.au>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
       kexec@lists.infradead.org
Subject: Re: kexec reboot broken with ioatdma?
Message-ID: <20091216233613.GA22449@verge.net.au>
References: <ada3a3a8v1g.fsf@roland-alpha.cisco.com>
 <20091216224912.GC16219@verge.net.au>
 <aday6l27c7w.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aday6l27c7w.fsf@roland-alpha.cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 03:04:03PM -0800, Roland Dreier wrote:
> 
>  > from a kexec point of view I believe that the preferred option is the
>  > former - shutdown the device so it can be initialised using standard paths
>  > in the second kernel.
> 
> OK... however I'm not suggesting a separate kexec initialization path,
> simply adding a reset of the device in the standard initialization.
> This would be fairly normal for other types of device; for example, the
> BIOS may have left a NIC in an undefined state due to network boot.  Of
> course BIOS is unlikely to use an IOAT DMA engine but the principle of
> limiting assumptions about platform state still stands I think.

If its reset in a standard path, then yes that seems sensible to me.
I'm mainly concerned about avoiding something along the lines of:

	if (is_booting_from_kexec)
		reset_hw();

> >From a quick look, it seems tricky to get a clean shutdown of IOAT stuff
> since there doesn't seem to be a clean ordering that makes sure the
> ioatdma stuff is shutdown after everything using it.
> 
>  - R.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
