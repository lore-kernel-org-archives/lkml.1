Return-Path: <linux-kernel-owner+w=401wt.eu-S1764255AbXHANkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764255AbXHANkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 09:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762572AbXHANkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 09:40:43 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:20666 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761763AbXHANkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 09:40:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from:sender;
        b=PmQcrRNrpmmPo8FZdfvx71IWK9WuC4C2klJhnLEtCFkhoQDstDuxFavPcRPxy8O88aTL4eYOyGNppDdQgOAAbKbHUqUF8uop236dOX0i2f2Sx5uWId8NwRFC914rVw2VQQb+Wqi8nnoxfdwx6tLlAnjuRAQPwHgu1UiFkBLBylo=
Date: Wed, 1 Aug 2007 21:39:12 +0800
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: [PATCH] drivers/scsi/advansys.c: fix advansys_board_found compile
	error
Message-ID: <20070801133912.GA11027@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <46B0842D.3060703@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B0842D.3060703@googlemail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
From: Eugene Teo <eugeneteo@kernel.sg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gabriel,

Hope the following trivial patch helps.

<quote sender="Gabriel C">
> Getting this with a randconfig ( http://194.231.229.228/MM/randconfig-auto-10 )
> 
[...]
> drivers/scsi/advansys.c:794:2: warning: #warning this driver is still not properly converted to the DMA API
> drivers/scsi/advansys.c: In function 'advansys_board_found':
> drivers/scsi/advansys.c:17781: error: implicit declaration of function 'to_pci_dev'
[...]

This patch fixes the following compile error:

drivers/scsi/advansys.c: In function 'advansys_board_found':
drivers/scsi/advansys.c:17781: error: implicit declaration of function
'to_pci_dev'

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 drivers/scsi/advansys.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 79c0b6e..908f02b 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -774,6 +774,7 @@
 #include <linux/stat.h>
 #include <linux/spinlock.h>
 #include <linux/dma-mapping.h>
+#include <linux/pci.h>
 
 #include <asm/io.h>
 #include <asm/system.h>

