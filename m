Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbZA3EqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbZA3EqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 23:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZA3EqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 23:46:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47355 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbZA3EqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 23:46:11 -0500
Message-ID: <4982860E.2060605@zytor.com>
Date: Thu, 29 Jan 2009 20:46:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jonathan Campbell <jon@nerdgrounds.com>
CC: "Peter W. Morreale" <pmorreale@novell.com>, devel@driverdev.osuosl.org,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: Vramfs: filesystem driver to utilize extra RAM on VGA devices
References: <497E4531.20800@nerdgrounds.com> <497E4919.60907@zytor.com>	 <497E4C5E.2030201@nerdgrounds.com> <1233248649.7191.130.camel@hermosa.site> <4981E7BD.3040507@nerdgrounds.com> <4981E99F.30001@zytor.com> <498271DF.6090406@nerdgrounds.com>
In-Reply-To: <498271DF.6090406@nerdgrounds.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Campbell wrote:
> I don't really see the similarity between the MTD subsystem and dividing
> vram up by files. Video cards don't have "erase blocks". And MTD is not
> a filesystem. And the onboard memory mtd driver (map system RAM) only
> handles one fixed region determined at load time.
> 
> Vramfs on the other hand determines what resources to use at mount time.
> It supports multiple mounts, one per PCI device, if you want the
> combined VRAM of two VGA cards in your system.
> 
> I don't think vramfs would fit well into the MTD subsystem.

Think about it this way: it is a continuum of facilities.  Why is VRAM
different than, say, external DRAM that can only be accessed via a DMA
engine?  Now swap the DRAM with NAND flash and perform the same exercise.

Perhaps the most important reason is that you want to be able to use
this as backing store for swap.  Currently the mm doesn't handle swap
which is much faster than filesystems very well, but that should be
possible to address.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

