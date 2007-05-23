Return-Path: <linux-kernel-owner+w=401wt.eu-S934884AbXEWTfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934884AbXEWTfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 15:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756837AbXEWTfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 15:35:11 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35777 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754956AbXEWTfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 15:35:07 -0400
Date: Wed, 23 May 2007 20:38:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: "James Bottomley" <James.Bottomley@SteelEye.com>,
       "Aubrey Li" <aubreylee@gmail.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Bernhard Walle" <bwalle@suse.de>, <linux-scsi@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [scsi] Remove __GFP_DMA
Message-ID: <20070523203846.41ac5011@the-village.bc.nu>
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1BDA@otce2k301.adaptec.com>
References: <20070521151525.GA581@suse.de>
	<Pine.LNX.4.64.0705221443030.16285@schroedinger.engr.sgi.com>
	<6d6a94c50705221941y63f4db7bj174a2265d9eaa61a@mail.gmail.com>
	<1179933494.3700.16.camel@mulgrave.il.steeleye.com>
	<AE4F746F2AECFC4DA4AADD66A1DFEF019E1BDA@otce2k301.adaptec.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 15:17:08 -0400
"Salyzyn, Mark" <mark_salyzyn@adaptec.com> wrote:

> The 31 bit limit for some of these cards is a problem, we currently only
> do __GFP_DMA for bounce buffer sg elements allocated for user supplied
> references in ioctls.
> 
> I figure we should be using pci_alloc_consistent calls for these
> allocations to more accurately acquire memory within the 31 bit limit if
> necessary, we could switch to these to remove the need for the __GFP_DMA
> flag in the aacraid driver?

That didn't used to work right on the AMD boards when I tried it last as
we ended up with a buffer that was mapped by the IOMMU for some reason
and that was not below 2GB.

