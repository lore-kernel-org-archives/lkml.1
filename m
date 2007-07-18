Return-Path: <linux-kernel-owner+w=401wt.eu-S1763409AbXGRBlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763409AbXGRBlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 21:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbXGRBln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 21:41:43 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:18437 "EHLO
	outbound6-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754512AbXGRBll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 21:41:41 -0400
X-BigFish: VP
X-FB-SS: 0,
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
Date: Tue, 17 Jul 2007 19:42:24 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "Andrew Paprocki" <andrew@ishiboo.com>
cc: "Antonino A. Daplas" <adaplas@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Geode GX framebuffer driver: Arcom vs. AMD
Message-ID: <20070718014224.GA19669@cosmic.amd.com>
References: <76366b180707141201u14585c2eyeb58f0b7b279ea1b@mail.gmail.com>
 <1184445094.4692.2.camel@daplas>
 <76366b180707141405n7aeb9cf0i6d66ca5b0093bd8f@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <76366b180707141405n7aeb9cf0i6d66ca5b0093bd8f@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 18 Jul 2007 01:40:04.0022 (UTC)
 FILETIME=[90278D60:01C7C8DC]
X-WSS-ID: 6A83B0FFR0G2729605-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/07/07 17:05 -0400, Andrew Paprocki wrote:
> Tony,
> 
> Do you have the patch working already? I'd love to try this out in the
> meantime on the LX system I am developing with at the moment. I'm
> assuming you worked this into the existing Arcom framework (gxfb) and
> pulled the necessary pieces from the AMD code?

Actually no.  There was enough extra stuff in the lxfb par structure
that I just made it its own driver.  The other two Geode drivers really
try to be more generic then they should be.  There is probably code that
can be shared between the three, but the core is just different enough
that the drivers shouldn't be merged together.

> Also, question for AMD/Jordan.. Is AMD going to provide any
> support/patches for the existing gxfb and this new lxfb? (Maybe
> perhaps an AMD supported DirectFB driver? :))

You asked two different questions.  Yes, we plan to support the gxfb
and lxfb code in the kernel for the foreseeable future.  No, we are not
going to support any additional graphics engines beyond the kernel
framebuffer driver and the X driver.  Sorry.

> If anyone else is interested, I'll get around to making a patch of the
> work I just did to bring the original AMD 2.6.11 framebuffer &
> Cimarron fully up to date with the 2.6.22 tree. If AMD is going to
> continue to maintain their own driver, this will allow the use of an
> up-to-date kernel.

I don't believe we're going to continue maintaining that driver for new
kernels when the lxfb goes into the kernel.  I now really regret using 
Cimarron for that previous driver - that was a combination of laziness
on my part, and a general naivity by AMD as to how the kernel works.  
We soon realized what should have been obvious from the start - a massive
processor specific HAL to support two drivers just doesn't belong in
the kernel.  Thats why we never sent it up, and thats why we wrote
the new lxfb driver.

Jordan


