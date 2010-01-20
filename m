Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084Ab0ATCDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab0ATCDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 21:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881Ab0ATCDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 21:03:35 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57204 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab0ATCDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 21:03:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=QoX3nD/6RhYcoiHP/9Nzghm5B8wnp1VjxQQ3LtbklDr3TYEgGdZAivxeWHJw27jv0U
         Y+72YyX/oLNAqn4zCzzxfpEJy4vESnIuhetGCoafb2l91YM6OSZoZlJXTfNOcy4Aip0x
         WRP4ZAFuk7QglfWWXVCCjG8/UlFqJaXF0tG/k=
Message-ID: <4B56659E.3040001@gmail.com>
Date: Wed, 20 Jan 2010 03:08:30 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
       Steve Hodgson <shodgson@solarflare.com>,
       Ben Hutchings <bhutchings@solarflare.com>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] sfc: EFX_ETHTOOL_STAT calculates the offset of the efx##source_name's
 field in both cases
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EFX_ETHTOOL_STAT calculated the offset of the efx##source_name's field
Regardless of whether that field was NULL.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
This looks like a bug, but I am not sure whether I understood this correctly,
nor was it tested, was this intended?

diff --git a/drivers/net/sfc/ethtool.c b/drivers/net/sfc/ethtool.c
index 6c0bbed..722bac7 100644
--- a/drivers/net/sfc/ethtool.c
+++ b/drivers/net/sfc/ethtool.c
@@ -41,7 +41,7 @@ struct efx_ethtool_stat {
 	.source = EFX_ETHTOOL_STAT_SOURCE_##source_name,		\
 	.offset = ((((field_type *) 0) ==				\
 		      &((struct efx_##source_name *)0)->field) ?	\
-		    offsetof(struct efx_##source_name, field) :		\
+		    offsetof(struct efx_##stat_name, field) :		\
 		    offsetof(struct efx_##source_name, field)),		\
 	.get_stat = get_stat_function,					\
 }
