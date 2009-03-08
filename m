Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbZCHWvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbZCHWvk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 18:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbZCHWvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 18:51:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53061 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbZCHWvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 18:51:31 -0400
Message-ID: <49B44BE8.1080700@zytor.com>
Date: Sun, 08 Mar 2009 15:51:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Cliff Wickman <cpw@sgi.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] x86: access to efi reserved memory type
References: <E1Lfe8A-00056c-SH@eag09.americas.sgi.com>
In-Reply-To: <E1Lfe8A-00056c-SH@eag09.americas.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cliff Wickman wrote:
> From: Cliff Wickman <cpw@sgi.com>
> 
>  (this patch dates back to 2008-11-06
>     http://marc.info/?l=linux-kernel&m=122600658522471&w=2
>   but has never been applied.)
> 
> Give drivers addresses of memory type EFI_RESERVED_TYPE.
> This supports drivers that use vendor-specific memory, available
> only to special devices.
> 
> The walk() function scans the EFI memory map and does a callback to a
> specified function for each memory area of a specified type.
> efi_memmap_walk_reserved() provides a scan for type EFI_RESERVED_TYPE.
>  (an earlier version of this patch had proposed a new EFI type, but
>   EFI_RESERVED_TYPE should be sufficient, given that the firmware follows
>   the standard and does not use such memory for its own purposes)
> 
> A UV driver will be posted to the community in the future that will use
> these routines.
> 
> Tested on 2.6.29-rc7 (and many previous versions) running on a
> UV hardware simulator.
> 

I have multiple issues with this patch.

FIRST, this is identical to a platform driver.  I really don't
understand why it should need a special interface.

SECOND, the EFI-specific callback interface is just plain weird.

THIRD, saying "A UV driver will be posted to the community in the future
that will use these routines" is not exactly motivation.  At no point
are you technically justifying this code.

In particular, I really want to know why a plain platform device is
insufficient, and look for a better solution than this, using the
generic memory map interfaces rather than something EFI-specific.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

