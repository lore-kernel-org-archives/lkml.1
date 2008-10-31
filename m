Return-Path: <linux-kernel-owner+w=401wt.eu-S1752720AbYJaTDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbYJaTDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 15:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbYJaTDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 15:03:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40370
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751525AbYJaTDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 15:03:03 -0400
Date: Fri, 31 Oct 2008 12:02:38 -0700 (PDT)
Message-Id: <20081031.120238.156698095.davem@davemloft.net>
To: dmitrmax@gmail.com
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH] Fix PCI resource mmaping on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <eed7af970810310609o632034dia6140f7bec6fee66@mail.gmail.com>
References: <eed7af970810310513h6c466ce5h7ada2013ab4053b1@mail.gmail.com>
	<eed7af970810310609o632034dia6140f7bec6fee66@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Max Dmitrichenko" <dmitrmax@gmail.com>
Date: Fri, 31 Oct 2008 16:09:48 +0300

Please post sparc patches to the sparclinux mailing list,
CC:'d

> There is a problem discovered in recent versions of ATI Mach64 driver
> in X.org on sparc64 architecture. In short, the driver fails to mmap
> MMIO aperture (PCI resource #2).
> 
> I've found that kernel's __pci_mmap_make_offset() returns EINVAL. It
> checks whether user attempts to mmap more than the resource length,
> which is 0x1000 bytes in our case. But PAGE_SIZE on SPARC64 is 0x2000
> and this is what actually is being mmaped. So __pci_mmap_make_offset()
> failed for this PCI resource.
> 
> Signed-off-by: Max Dmitrichenko <dmitrmax@gmail.com>
> 
> Code seems to be rather old. At least it was the same in 2.6.24. I
> have no explanation why this bug exposed only now. May be before X.org
> used to use some other method to mmap PCI resource into userspace (now
> it uses libpciaccess).
> 
> The patch is against 2.6.26. Greg, please consider to include it into
> the stable trees.

No, the sparc maintainer (that's me) will submit this patch to -stable
if it is correct and appropriate.
