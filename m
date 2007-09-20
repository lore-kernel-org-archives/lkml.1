Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbXITNfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbXITNfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 09:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbXITNfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 09:35:30 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:23371 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbXITNf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 09:35:29 -0400
Date: Thu, 20 Sep 2007 15:35:18 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>
Subject: Re: 2.6.23-rc6-mm1: atomic counter underflow
Message-ID: <20070920153518.15e72a24@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070919200205.057e3fbc@gondolin.boeblingen.de.ibm.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<200709182345.13435.m.kozlowski@tuxland.pl>
	<20070919102716.09004317@gondolin.boeblingen.de.ibm.com>
	<200709191843.54902.m.kozlowski@tuxland.pl>
	<20070919200205.057e3fbc@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 20:02:05 +0200,
Cornelia Huck <cornelia.huck@de.ibm.com> wrote:

> -ECONFUSED. Perhaps DEBUG_DRIVER may help some more. Or /me getting
> some sleep.

Sleeping helped (improved reading abilities).

From: Cornelia Huck <cornelia.huck@de.ibm.com>

mmc: Avoid double sdio_unregister_bus() on module unload.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/mmc/core/core.c |    1 -
 1 files changed, 1 deletion(-)

--- linux-2.6.orig/drivers/mmc/core/core.c
+++ linux-2.6/drivers/mmc/core/core.c
@@ -820,7 +820,6 @@ static void __exit mmc_exit(void)
 {
 	sdio_unregister_bus();
 	mmc_unregister_key_type();
-	sdio_unregister_bus();
 	mmc_unregister_host_class();
 	mmc_unregister_bus();
 	destroy_workqueue(workqueue);
