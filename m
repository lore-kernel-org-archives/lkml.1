Return-Path: <linux-kernel-owner+w=401wt.eu-S1760303AbYFYQiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760303AbYFYQiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYFYQiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:38:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41791 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbYFYQiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:38:08 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 25 Jun 2008 18:37:43 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-sbp2: fix parsing of logical unit directories
To: linux1394-devel@lists.sourceforge.net,
       Kevin Valentine <kevin.valentine@gmail.com>
cc: linux-kernel@vger.kernel.org, Richard Sharpe <realrichardsharpe@gmail.com>
In-Reply-To: <486272D0.7090506@s5r6.in-berlin.de>
Message-ID: <tkrat.24168af4c57c3bde@s5r6.in-berlin.de>
References: <46b8a8850806241911t1da66504i960b3013d1dd6ba8@mail.gmail.com> 
 <48622A83.8000809@s5r6.in-berlin.de>
 <46b8a8850806250757y4aa4b27au79fd9037ebc3c80@mail.gmail.com>
 <486272D0.7090506@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Tue, 24 Jun 2008 19:11:13 -0700
From: Richard Sharpe <realrichardsharpe@gmail.com>

There is a small off-by-one bug in firewire-sbp2. This causes problems
when a device exports multiple LUN Directories. I found it when trying
to talk to a SONY DVD Jukebox.

Signed-off-by: Richard Sharpe <realrichardsharpe@gmail.com>
Acked-by: Kristian Høgsberg <krh@redhat.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (op. order, changelog)
---

Kevin, this bug probably prevented the detection of the second drive in
the PowerFile C200 when you tested the new drivers.

 drivers/firewire/fw-sbp2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -1066,7 +1066,8 @@ static int sbp2_scan_unit_dir(struct sbp
 			break;
 
 		case SBP2_CSR_LOGICAL_UNIT_DIRECTORY:
-			if (sbp2_scan_logical_unit_dir(tgt, ci.p + value) < 0)
+			/* Adjust for the increment in the iterator */
+			if (sbp2_scan_logical_unit_dir(tgt, ci.p - 1 + value) < 0)
 				return -ENOMEM;
 			break;
 		}

-- 
Stefan Richter
-=====-==--- -==- ==--=
http://arcgraph.de/sr/

