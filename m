Return-Path: <linux-kernel-owner+w=401wt.eu-S1762225AbXFGOhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762225AbXFGOhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 10:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbXFGOh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 10:37:27 -0400
Received: from mx.melware.net ([217.91.97.190]:1428 "EHLO mx.melware.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbXFGOh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 10:37:26 -0400
Date: Thu, 7 Jun 2007 16:06:17 +0200 (CEST)
From: Armin Schindler <armin@melware.de>
X-X-Sender: armin@phoenix.one.melware.de
To: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: [PATCH] Leak in eicon/idifunc.c
Message-ID: <Pine.LNX.4.61.0706071604360.7559@phoenix.one.melware.de>
Organization: Cytronics & Melware
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

coverity spotted a possible leak in the idifunc.c file (bug id #1252),
in um_new_card(), if the diva_user_mode_idi_create_adapter() fails,
we dont free the memory allocated for card

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Acked-by: Armin Schindler <armin@melware.de>

--- linux-2.6/drivers/isdn/hardware/eicon/idifunc.c.orig	2007-05-22 00:22:02.000000000 +0200
+++ linux-2.6/drivers/isdn/hardware/eicon/idifunc.c	2007-05-22 00:22:52.000000000 +0200
@@ -106,6 +106,7 @@ static void um_new_card(DESCRIPTOR * d)
 	} else {
 		DBG_ERR(("could not create user mode idi card %d",
 			 adapter_nr));
+		diva_os_free(0, card);
 	}
 }
 
