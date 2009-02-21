Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbZBUDDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbZBUDDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 22:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbZBUDDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 22:03:12 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:41775 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985AbZBUDDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 22:03:11 -0500
Date: Fri, 20 Feb 2009 22:03:03 -0500
From: Andres Salomon <dilinger@queued.net>
To: drzeus-sdhci@drzeus.cx
Cc: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org, cjb@laptop.org
Subject: Re: OLPC XO-1 sdhci regression
Message-ID: <20090220220303.63720634@ephemeral>
In-Reply-To: <20090220124343.707b83b4@ephemeral>
References: <20090220124343.707b83b4@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Feb 2009 12:43:43 -0500
Andres Salomon <dilinger@queued.net> wrote:

> Hi Pierre,
> 
> With the current Linus git tree, the sdhci driver fails to find the
> partition table on cards during bootup on OLPC XO-1 machines.  This
> makes booting off of SD impossible.  The errors go something like
> this:
> 
[...]


A quirk proposed by Anton fixes the issue.  The attached patch adds the
quirk for the Marvell CAFE controller.



Subject: [PATCH] SDHCI: Add NO_BUSY_IRQ quirk for Marvell CAFE host chip

As described here: http://lkml.org/lkml/2009/2/20/265

The CAFE chip is broken due to commit e809517f6fa5803a5a1cd56026f0e2190fc13d5c.
Anton added a quirk here: http://lkml.org/lkml/2009/2/20/279 that fixes
CAFE's problem.  This adds the quirk for CAFE.

Obviously, this depends upon Anton's patch.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/mmc/host/sdhci-pci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 8cff5f5..406da9a 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -107,6 +107,7 @@ static const struct sdhci_pci_fixes sdhci_ene_714 = {
 
 static const struct sdhci_pci_fixes sdhci_cafe = {
 	.quirks		= SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER |
+			  SDHCI_QUIRK_NO_BUSY_IRQ |
 			  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL,
 };
 
-- 
1.5.6.5



