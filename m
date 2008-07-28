Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbYG1K7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbYG1K7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 06:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbYG1K7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 06:59:11 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:39023 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbYG1K7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 06:59:10 -0400
X-BigFish: VPS-30(zz1432R98dR1805M936fQzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K4PQID-03-D2E-01
Date: Mon, 28 Jul 2008 12:59:00 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] introduce lower_32_bits() macro
Message-ID: <20080728105900.GC7493@amd.com>
References: <1216998747-16896-1-git-send-email-joerg.roedel@amd.com> <4889FA03.6010708@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4889FA03.6010708@zytor.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 28 Jul 2008 10:59:00.0258 (UTC) FILETIME=[F0A11020:01C8F0A0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 12:06:27PM -0400, H. Peter Anvin wrote:
> Joerg Roedel wrote:
> >The file kernel.h contains the upper_32_bits macro. This patch adds the other
> >part, the lower_32_bits macro. Its first use will be in the driver for AMD
> >IOMMU.
> >Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> >---
> > include/linux/kernel.h |    6 ++++++
> > 1 files changed, 6 insertions(+), 0 deletions(-)
> >diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> >index f9cd7a5..6fd2977 100644
> >--- a/include/linux/kernel.h
> >+++ b/include/linux/kernel.h
> >@@ -73,6 +73,12 @@ extern const char linux_proc_banner[];
> >  */
> > #define upper_32_bits(n) ((u32)(((n) >> 16) >> 16))
> > +/**
> >+ * lower_32_bits - return bits 0-31 of a number
> >+ * @n: the number we're accessing
> >+ */
> >+#define lower_32_bits(n) ((n) & 0xffffffffULL)
> >+
> 
> NAK.  These are assymmetric with regards to type, which is the *last*
> thing we want.
> 
> The symmetric definition would be ((u32)(n)), but that's already
> idiomatic use, so why not use it as-is?

Ok, true. Sorry for the broken patch. I will send an updated one.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

