Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbYFUTWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbYFUTWW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 15:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYFUTWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 15:22:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:7903 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbYFUTWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 15:22:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=YfBJqCy2W1GHtT1v3ItkurolQIwoZBbGYgymodnZXoIVbGZSILKJVeyFW0Wio3T2+Q
         y6V5ZFSG2nZAYeUgcCyz5VzA+p/IwlVVAL51MGCuynzUFcFAFT/7BiFPzM5j58nm3nvd
         Op5cQKo65wb0ifLlhcLcj2Q4SKPkilkwDSlIs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH] alpha: resurrect Cypress IDE quirk
Date: Sat, 21 Jun 2008 20:45:11 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20080620232854.GD8061@jurassic.park.msu.ru>
In-Reply-To: <20080620232854.GD8061@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806212045.12982.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 June 2008, Ivan Kokshaysky wrote:
> Which was removed in the hope that generic legacy IDE quirk in
> drivers/pci/probe.c is sufficient for Cypress IDE.
> It isn't, as this controller has non-standard BAR layout:
> secondary channel registers are in the BAR0-1 of the second
> PCI function - not in the BAR2-3 of the same function, as the
> generic quirk routine assumes.
> 
> Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

ACK, thanks for fixing it.

This actually reminds me that we should probably limit cy82c693
driver to be selectable only on alpha (I've never seen this chipset
being used on anything else + quick googling for non-alpha dmesgs
seems to confirm it)?

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: limit cy82c693 host driver to ALPHA

Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -510,6 +510,7 @@ config BLK_DEV_TRIFLEX
 
 config BLK_DEV_CY82C693
 	tristate "CY82C693 chipset support"
+	depends on ALPHA
 	select IDE_TIMINGS
 	select BLK_DEV_IDEDMA_PCI
 	help
