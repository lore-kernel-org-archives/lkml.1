Return-Path: <linux-kernel-owner+w=401wt.eu-S1759197AbXLUNlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197AbXLUNlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 08:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbXLUNlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 08:41:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:37156 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbXLUNlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 08:41:14 -0500
Date: Fri, 21 Dec 2007 14:41:12 +0100
From: Andi Kleen <ak@suse.de>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, ak@suse.de
Subject: Re: [PATCH] x86: Fix DMI out of memory problems
Message-ID: <20071221134111.GB8222@bingen.suse.de>
References: <Pine.LNX.4.64.0712181848430.3663@mini.warudkars.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712181848430.3663@mini.warudkars.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 07:33:00PM -0500, Parag Warudkar wrote:
>
> People with HP Desktops (including me) encounter couple of DMI errors 
> during boot - dmi_save_oem_strings_devices: out of memory and dmi_string: 
> out of memory.
>
> On some HP desktops the DMI data include OEM strings (type 11) out of which 
> only few are meaningful and most other are empty. DMI code religiously 
> creates copies of these 27 strings (65ytes each in my case) and goes OOM 
> in dmi_string().
>
> If DMI_MAX_DATA is bumped up a little then it goes and fails in 
> dmi_save_oem_strings while allocating dmi_devices of sizeof(struct 
> dmi_device) corresponding to these strings.
>
> On x86_64 since we cannot use alloc_bootmem this early, the code uses a 

FWIW the ff tree has patches to allow "really early allocation" now.
They could be used for this. I didn't implement that for i386 though,
so that would still need some variant of your patch.

Disadvantage right now: e820 memory allocation currently rounds to pages
always. I intend to fix that though because it also wastes memory
with the memnodemap for once.

The forced page rounding was recently added as another bugfix, but that needs
to be reworked.

-Andi

ftp://ftp.firstfloor.org/pub/ak/quilt/patches/early-reserve
ftp://ftp.firstfloor.org/pub/ak/quilt/patches/early-alloc

