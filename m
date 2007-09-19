Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbXISUC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbXISUC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 16:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbXISUCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 16:02:48 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2146 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbXISUCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 16:02:47 -0400
X-Server-Uuid: 6B5CFB92-F616-4477-B110-55F967A57302
Subject: Re: bnx2 dirver's firmware images
From: "Michael Chan" <mchan@broadcom.com>
To: "Denys Vlasenko" <vda.linux@googlemail.com>
cc: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       "netdev" <netdev@vger.kernel.org>
In-Reply-To: <200709190930.39882.vda.linux@googlemail.com>
References: <200709181823.26429.vda.linux@googlemail.com>
 <20070918.112337.74737433.davem@davemloft.net>
 <1190145951.9540.230.camel@dell>
 <200709190930.39882.vda.linux@googlemail.com>
Date: Wed, 19 Sep 2007 14:00:42 -0700
Message-ID: <1190235642.9540.261.camel@dell>
MIME-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8)
X-WSS-ID: 6AEF5FD33K43376864-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-19 at 09:30 +0100, Denys Vlasenko wrote:
+       /* gzip header (1f,8b,08... 10 bytes total + possible asciz filename)
+        * is stripped, 32-bit unpacked size (LE) is prepended instead */
+       sz = *zbuf++;
+       sz = (sz << 8) + *zbuf++;
+       sz = (sz << 8) + *zbuf++;
+       sz = (sz << 8) + *zbuf++;

I don't have a problem with removing the gzip header.  It doesn't
contain very useful information other than a valid header for sanity
check.  But I don't think we need to arbitrarily add the unpacked size
in front of the gzipped data.  The driver knows the size (e.g. the size
of RAM on the chip) and should pass it to the call.  The driver should
also allocate the memory for the unpacked data instead of allocating the
memory inside the call and freeing it by the caller.  For example, the
driver may need to use pci_alloc_consistent() if the firmware is to be
DMA'ed to the chip.

Other than that, everything else looks fine.  Thanks.

