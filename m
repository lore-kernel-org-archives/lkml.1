Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbXJTEmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbXJTEmf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 00:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbXJTEm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 00:42:27 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:37157 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751985AbXJTEm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 00:42:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=khTJM5Lfztz+fp6NsST9UmqECkuFVZe+xnZrnVwdA8jGPdoJymykit/3ZXjD47O47MWuOABI1i8kJSUW3ipbgtO5Icj2wHMS2odbp4VGuXnDrX26vKjSFWnkB1USP211Twyagfx56IUspY3d9NIrDnTf4SdIWrNDtOhLTlWWoRA=  ;
X-YMail-OSG: VGB8kasVM1l0NzCjMTHOBQgtpCqWD2eIyf9UL_6N4n6lMSP1Z2u4aF7EpAXcx3qT4dkqJ79.FA--
Date: Fri, 19 Oct 2007 21:42:24 -0700
From: David Brownell <david-b@pacbell.net>
To: linux-kernel@vger.kernel.org
Subject: [patch 2.6.23-git] toplevel Makefile/depmod bugfix
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071020044224.DD48423A6FC@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This removes a BASH syntax error (seen building on Ubuntu Feisty).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

--- g26.orig/Makefile	2007-10-19 21:29:43.000000000 -0700
+++ g26/Makefile	2007-10-19 18:35:32.000000000 -0700
@@ -1507,7 +1507,7 @@ quiet_cmd_rmfiles = $(if $(wildcard $(rm
 # and we build for the host arch
 quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
       cmd_depmod = \
-	if [ -r System.map -a -x $(DEPMOD) -a "$(SUBARCH)" == "$(ARCH)" ]; then \
+	if [ -r System.map -a -x $(DEPMOD) -a "$(SUBARCH)" = "$(ARCH)" ]; then \
 		$(DEPMOD) -ae -F System.map                                     \
 		$(if $(strip $(INSTALL_MOD_PATH)), -b $(INSTALL_MOD_PATH) -r)   \
 		$(KERNELRELEASE);                                               \
