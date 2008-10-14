Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbYJNXSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbYJNXSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 19:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYJNXSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 19:18:14 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:43028 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752519AbYJNXSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 19:18:12 -0400
Message-Id: <20081014231809.686356435@fluff.org.uk>
References: <20081014231714.739345038@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Wed, 15 Oct 2008 00:17:15 +0100
From: ben@fluff.org.uk
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, Ben Dooks <ben-linux@fluff.org>
Subject: [patch 1/5] s3cmci: Make general protocol errors less noisy
Content-Disposition: inline; filename=simtec/simtec-drivers-mmc-make-errors-less-noisy.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

General errors, such as timeouts during probe do not need to
be sent to the console, so move them down to be included if the
debug is enabled.

Such errors include:
s3c2440-sdi s3c2440-sdi: s3cmci_request: no medium present

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-quilt8/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-quilt8.orig/drivers/mmc/host/s3cmci.c	2008-08-11 22:38:12.000000000 +0100
+++ linux-2.6.26-quilt8/drivers/mmc/host/s3cmci.c	2008-08-11 22:45:52.000000000 +0100
@@ -39,9 +39,9 @@ enum dbg_channels {
 	dbg_conf  = (1 << 8),
 };
 
-static const int dbgmap_err   = dbg_err | dbg_fail;
+static const int dbgmap_err   = dbg_fail;
 static const int dbgmap_info  = dbg_info | dbg_conf;
-static const int dbgmap_debug = dbg_debug;
+static const int dbgmap_debug = dbg_err | dbg_debug;
 
 #define dbg(host, channels, args...)		  \
 	do {					  \

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
