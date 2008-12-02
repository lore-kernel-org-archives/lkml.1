Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbYLBGRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbYLBGRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 01:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbYLBGQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 01:16:57 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:43385 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751059AbYLBGQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 01:16:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=t60zG0qozDkIcWDxG1f3xS91Dgx7fpxiGc6lKdVtk7gdlyBM+cOsq2Mym66rVdXHEl4orUJF6cunbeOSyJy9KT0SjZet7tj1cLn333NUml2MG+E839AgXLnEVe9K7a8FAe167nU9Xb6qHtfB/vadssQVWGmw2blayZ+XNl+apww=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>, lrg@slimlogic.co.uk
Subject: [patch 2.6.28-rc7] regulator: init/link earlier
Date: Mon, 1 Dec 2008 21:50:13 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>
References: <200812011335.43551.david-b@pacbell.net> <20081201225312.GA6699@sirena.org.uk>
In-Reply-To: <20081201225312.GA6699@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812012150.13909.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Move regulator earlier in link sequence.

The regulator core currently initializes as a core_initcall() to be
available early ... but then it links way late, throwing away that
benefit, so regulators available at e.g. subsys_initcall() are not
available to subsystems which need to use them.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
It's not clear "how early" to be; this works.

 drivers/Makefile |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -18,6 +18,9 @@ obj-$(CONFIG_ARM_AMBA)		+= amba/
 
 obj-$(CONFIG_XEN)		+= xen/
 
+# regulators early, since some subsystems rely on them to initialize
+obj-$(CONFIG_REGULATOR)		+= regulator/
+
 # char/ comes before serial/ etc so that the VT console is the boot-time
 # default.
 obj-y				+= char/
@@ -101,5 +104,4 @@ obj-$(CONFIG_PPC_PS3)		+= ps3/
 obj-$(CONFIG_OF)		+= of/
 obj-$(CONFIG_SSB)		+= ssb/
 obj-$(CONFIG_VIRTIO)		+= virtio/
-obj-$(CONFIG_REGULATOR)		+= regulator/
 obj-$(CONFIG_STAGING)		+= staging/
