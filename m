Return-Path: <linux-kernel-owner+w=401wt.eu-S1758314AbYFJUxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314AbYFJUxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757706AbYFJUvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:51:06 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:30333 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140AbYFJUvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:51:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=S8VcKnCjbEq9l6t5fKW7FZfHusJCtKA9ZsoPHgiIwexVSQW1ytJkWnMw46fZovnh58
         uLr57qf7V4u3/68JfzxSwAS72LzkbD15Y/nbQk0zlXckfM63XkM8IPJkX33i/uBZinXY
         bjg+qbtrPADYgDZFjLX57/B8lCzw2qT9AyOyo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 10 Jun 2008 22:52:39 +0200
Message-Id: <20080610205239.18469.78221.sendpatchset@localhost.localdomain>
In-Reply-To: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
References: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
Subject: [PATCH 11/14] ide: remove superfluous BUG_ON() from set_geometry_intr()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ide_set_handler() bugs on ->handler == NULL so no need to do it
in set_geometry_intr().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-taskfile.c |    1 -
 1 file changed, 1 deletion(-)

Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -163,7 +163,6 @@ static ide_startstop_t set_geometry_intr
 	if (stat & (ERR_STAT|DRQ_STAT))
 		return ide_error(drive, "set_geometry_intr", stat);
 
-	BUG_ON(HWGROUP(drive)->handler != NULL);
 	ide_set_handler(drive, &set_geometry_intr, WAIT_WORSTCASE, NULL);
 	return ide_started;
 }
