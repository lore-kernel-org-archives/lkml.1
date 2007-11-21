Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbXKUT5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbXKUT5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 14:57:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbXKUT44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 14:56:56 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:37306 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbXKUT4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 14:56:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=KrxYXk4PCmnXZAMvXzwVpMtyRf6lfjztA6elv2f6h5KTwtZIxI+yS+mbJo0DsEMybijlw2S8ZrWzBNkA9euOxQRI2L83qC6NXe2466Aors5hIF4pFIqz4xEH++jP30Gu2PGPGvRGxSzIM1jIgOBuHq/PZJquoKihJ592BeGWWw0=
Date: Wed, 21 Nov 2007 22:56:42 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: PPCML <linuxppc-dev@ozlabs.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] PPC: fix missed increment on device interface counter
Message-ID: <20071121195642.GA7273@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch adds simple increment on device interface counter
(it seems to be accidently missed)

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 arch/powerpc/platforms/pasemi/electra_ide.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/pasemi/electra_ide.c b/arch/powerpc/platforms/pasemi/electra_ide.c
index 12fb0c9..8e73086 100644
--- a/arch/powerpc/platforms/pasemi/electra_ide.c
+++ b/arch/powerpc/platforms/pasemi/electra_ide.c
@@ -42,7 +42,7 @@ static int __devinit electra_ide_init(void)
 	np = of_find_compatible_node(NULL, "ide", "electra-ide");
 	i = 0;
 
-	while (np && i < MAX_IFS) {
+	while (np && i++ < MAX_IFS) {
 		memset(r, 0, sizeof(r));
 
 		/* pata_platform wants two address ranges: one for the base registers,
