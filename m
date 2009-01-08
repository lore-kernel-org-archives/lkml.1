Return-Path: <linux-kernel-owner+w=401wt.eu-S1760925AbZAHWwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925AbZAHWwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763522AbZAHWwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:52:31 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:58264 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763497AbZAHWw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:52:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xbojAoGM4l+GxGz2xS9WeYpvqbgrh38UpR6yw1xbQymPeayoSPFtpOwxgFOXXOMDIc
         QB5QIwMEsWqGZcFdwTdd8Azq+0BE8vUjEAJ5r/fL5wKhO34ID2cvTDw/A3SeQ2+YvT2G
         91RhdrBdcIagTC2Pd6mY3Q4iZBXP2oIQJyyK8=
Message-ID: <b1bc6a000901081452j3cce22dfy82a160cbcab0c5ed@mail.gmail.com>
Date: Thu, 8 Jan 2009 14:52:28 -0800
From: "adam radford" <aradford@gmail.com>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: Re: [Benchmarks] How do I set the memory invalidate bit for a 3ware 9550SXU-12 controller?
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-ide-arrays@lists.math.uh.edu
In-Reply-To: <alpine.DEB.1.10.0901080846430.29454@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.10.0901080846430.29454@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2009 at 6:20 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> System = RHEL5 x86_64
> Kernel = 2.6.18-53.1.13.el5

> Invalidate' (lspci now shows that the 3Ware controller 9550 is in 'MemWINV+'
> instead of 'MemWINV-' mode), maybe enhancing write throughput. The 9650 is
> in 'MemWINV-' mode. This seems somewhat frequent with SuperMicro mainboards,

The 3ware 9650SE is PCIe based, and memory-write-invalidate
does not apply.  See the following link from "PCI Express System
Architecture":

http://books.google.com/books?id=sBtKutWpVh8C&pg=PA787&lpg=PA787&dq=PCIe+memory+write+invalidate&source=web&ots=fZE68z97DP&sig=qWnb8nTRBrQL2g8DwZwLpiFWE4c

> How do I change MemWINV+ to MemWINV- using setpci?
>

Why would you want to turn this bit off?

> Does anyone know how to set it via setpci?

You mean unset it (as per your above request)?

You shouldn't use 'setpci' to just artibrarily set and unset the
memwinv bit.  For this bit to work correctly, the PCI device
must have its cache line size set correctly.  The kernel call
pci_try_set_mwi() does this by calling pci_set_cachline_size().   The
3ware driver in kernels 2.6.25 and higher makes this call to attempt
to turn on MWI support for motherboards that to not automatically have
it enabled.

You should not be trying to turn this bit off as it most likely will not help
your performance by doing so.

-Adam
