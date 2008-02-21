Return-Path: <linux-kernel-owner+w=401wt.eu-S1758780AbYBUTGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbYBUTGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 14:06:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbYBUTFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 14:05:55 -0500
Received: from verein.lst.de ([213.95.11.210]:47338 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbYBUTFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 14:05:55 -0500
Date: Thu, 21 Feb 2008 20:04:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: ??ric Piel <Eric.Piel@tremplin-utc.net>
Cc: Sergey Vlasov <vsu@altlinux.ru>, Christoph Hellwig <hch@lst.de>,
       dsdt@gaugusch.at, len.brown@intel.com, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, trenn@suse.de
Subject: Re: [PATCH] Allow populate_rootfs() to be called early (was: acpi dsts loading and populate_rootfs)
Message-ID: <20080221190455.GA7275@lst.de>
References: <20080210071226.GA23360@lst.de> <20080210071454.GA23428@lst.de> <47AEE6D1.4070402@tremplin-utc.net> <20080211164719.d42c618e.vsu@altlinux.ru> <47B0DD34.4010604@tremplin-utc.net> <47BDCACC.2030302@tremplin-utc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BDCACC.2030302@tremplin-utc.net>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 08:02:36PM +0100, ??ric Piel wrote:
> It's been a week and no one has screamed, so I guess the idea looks fine
> to everyone :-) 
> 
> Here is a boot tested patch for integration. In addition to the previous
> version, it removes also rootfs_initcall(), and uses fs_initcall_sync().
> There should be absolutely no difference in behaviour as there was no
> user of fs_initcall_sync() in the kernel.
> 
> I'm not sure what should be the best tree to go through. Maybe the ACPI
> tree, as all this is needed for CONFIG_ACPI_CUSTOM_DSDT_INITRD...

Actually I've just got a report today where we get an uninitialized
spinlock due to this in -mm.  It's probably possible to work around it,
though.

