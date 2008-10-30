Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYJ3LDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYJ3LDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 07:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbYJ3LDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 07:03:11 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36214 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbYJ3LDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 07:03:10 -0400
Date: Thu, 30 Oct 2008 13:02:54 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: linux-pcmcia@lists.infradead.org
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH] pcmcia: fix indentation & braces disagreement - add braces
Message-ID: <Pine.LNX.4.64.0810301301260.7072@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-494574763-1225364574=:7072"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-494574763-1225364574=:7072
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

Broken by d8b0a49da4f2 (pcmcia: deprecate CS_BAD_VCC and
CS_BAD_VPP).

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
---
 drivers/pcmcia/pcmcia_resource.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pcmcia/pcmcia_resource.c b/drivers/pcmcia/pcmcia_resource.c
index afea2b2..e3b3139 100644
--- a/drivers/pcmcia/pcmcia_resource.c
+++ b/drivers/pcmcia/pcmcia_resource.c
@@ -302,9 +302,10 @@ int pcmcia_modify_configuration(struct pcmcia_device *p_dev,
 	/* We only allow changing Vpp1 and Vpp2 to the same value */
 	if ((mod->Attributes & CONF_VPP1_CHANGE_VALID) &&
 	    (mod->Attributes & CONF_VPP2_CHANGE_VALID)) {
-		if (mod->Vpp1 != mod->Vpp2)
+		if (mod->Vpp1 != mod->Vpp2) {
 			ds_dbg(s, 0, "Vpp1 and Vpp2 must be the same\n");
 			return -EINVAL;
+		}
 		s->socket.Vpp = mod->Vpp1;
 		if (s->ops->set_socket(s, &s->socket)) {
 			dev_printk(KERN_WARNING, &s->dev,
-- 
1.5.2.2

---696208474-494574763-1225364574=:7072--
