Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbXEQIpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbXEQIpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 04:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbXEQIpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 04:45:08 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:62788 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754040AbXEQIpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 04:45:07 -0400
Date: Thu, 17 May 2007 10:45:00 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Arnd Bergmann <arnd@arndb.de>
cc: linuxppc-dev@ozlabs.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: Slab allocators: Define common size limitations
In-Reply-To: <200705162342.08601.arnd@arndb.de>
Message-ID: <Pine.LNX.4.62.0705171044030.1803@pademelon.sonytel.be>
References: <Pine.LNX.4.64.0705152313490.5832@schroedinger.engr.sgi.com>
 <Pine.LNX.4.62.0705160855470.24080@pademelon.sonytel.be> <200705162342.08601.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007, Arnd Bergmann wrote:
> On Wednesday 16 May 2007, Geert Uytterhoeven wrote:
> > What are the changes a large allocation will actually succeed?
> > Is there an alignment rule for large allocations?
> > 
> > E.g. for one of the PS3 drivers I need a physically contiguous 256 KiB-aligned
> > block of 256 KiB. Currently I'm using __alloc_bootmem() for that, but maybe
> > kmalloc() becomes a suitable alternative now?
> 
> kmalloc is limited to 128KiB on most architectures. Normally there is no
> need to use it anyway, just use __get_free_pages(). It will generally
> succeed at early boot time, but not after the system has been running
> for some time.

Exactly my understanding. And __get_free_pages() returns PAGE_SIZE-aligned
memory. So I'll keep the current code.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
