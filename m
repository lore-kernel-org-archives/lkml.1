Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbYBJUme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbYBJUme (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 15:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755704AbYBJUmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 15:42:00 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:29421 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755370AbYBJUly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 15:41:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ALwiHsmUQJy6CAJ0sh1Yxq0T8roS+yZmQCe0mmiwz5xcbp67RA3lHGTkgkAbUzcmbG5N1vjy4hYvLqMntRvOU/Ca9tQuuIguLtCtpNLSgL+nnWkAJJFfdIcbvZYwSULPGd1wRqYvU/iFzMp6857IvFX4230PCeW6LDWOhWzJWDI=  ;
X-YMail-OSG: PP4s4zgVM1l1I_npF4vOnfhCD77xOLuRarBa1JX6BMkQGPyzJDhVoD2ANsorFzgGhpAUGR2hFg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.24-git] parport: section fixup
Date: Sun, 10 Feb 2008 12:10:06 -0800
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802101210.06413.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix section warning for parport_ECP_supported(); it's called from a
routine exported to modules, so it can't be removed with __devinit
section pruning.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/parport/parport_pc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- g26.orig/drivers/parport/parport_pc.c	2008-02-10 10:34:53.000000000 -0800
+++ g26/drivers/parport/parport_pc.c	2008-02-10 11:19:00.000000000 -0800
@@ -1768,7 +1768,7 @@ static int parport_PS2_supported(struct 
 }
 
 #ifdef CONFIG_PARPORT_PC_FIFO
-static int __devinit parport_ECP_supported(struct parport *pb)
+static int parport_ECP_supported(struct parport *pb)
 {
 	int i;
 	int config, configb;
@@ -1992,7 +1992,7 @@ static int parport_ECPEPP_supported(stru
 /* Don't bother probing for modes we know we won't use. */
 static int __devinit parport_PS2_supported(struct parport *pb) { return 0; }
 #ifdef CONFIG_PARPORT_PC_FIFO
-static int __devinit parport_ECP_supported(struct parport *pb) { return 0; }
+static int parport_ECP_supported(struct parport *pb) { return 0; }
 #endif
 static int __devinit parport_EPP_supported(struct parport *pb) { return 0; }
 static int __devinit parport_ECPEPP_supported(struct parport *pb){return 0;}
