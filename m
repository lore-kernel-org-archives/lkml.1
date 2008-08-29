Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbYH2W4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbYH2W4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 18:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbYH2W4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 18:56:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:18947 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbYH2W4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 18:56:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,295,1217833200"; 
   d="scan'208";a="330458425"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "=?iso-8859-1?Q?\"J.A._Magall=F3n\"?=" <jamagallon@ono.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Date: Fri, 29 Aug 2008 15:55:43 -0700
Subject: RE: Out of mtrrs
Thread-Topic: Out of mtrrs
Thread-Index: AckJ7MjJMktDNbyKTHCtYBPc16/wLAAPUnEQ
Message-ID: <7E82351C108FA840AB1866AC776AEC460B7FC128@orsmsx505.amr.corp.intel.com>
References: <BEE3259F-0ED8-4030-9CA5-D8892C9096C2@ono.com>
In-Reply-To: <BEE3259F-0ED8-4030-9CA5-D8892C9096C2@ono.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of "J.A.
>Magallón"
>Sent: Friday, August 29, 2008 8:33 AM
>To: Linux-Kernel
>Subject: Out of mtrrs
>
>Hi all...
>
>I'm using the xorg intel driver, and drm/X report it has no free mtrrs
>in kernel to set up:
>
>one:~# cat /proc/mtrr
>reg00: base=0xfffe0000 (4095MB), size= 128KB: write-protect, count=1
>reg01: base=0xfffc0000 (4095MB), size= 128KB: uncachable, count=1
>reg02: base=0x00000000 (   0MB), size= 256MB: write-back, count=1
>reg03: base=0x10000000 ( 256MB), size= 256MB: write-back, count=1
>reg04: base=0x1f800000 ( 504MB), size=   8MB: uncachable, count=1
>reg05: base=0x1f600000 ( 502MB), size=   2MB: uncachable, count=1
>reg06: base=0x1f500000 ( 501MB), size=   1MB: uncachable, count=1
>reg07: base=0x00000000 (   0MB), size= 128KB: uncachable, count=1
>
>dmesg:
>
>[drm] Initialized i915 1.6.0 20060119 on minor 0
>mtrr: no more MTRRs available
>
>one:/var/log# grep Linear x.log
>(--) intel(0): Linear framebuffer at 0x20000000
>
>I think X tries to get a mtrr at 0x20000000, but kernel has no free one
>to offer.
>
>Does this have any solution ?
>

One of the main motivations to add PAT support was this kind of errors.
With PAT aware X, this will no longer be a problem as X will map this
using PAT APIs.

Thanks,
Venki
