Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbYHBRwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbYHBRwe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 13:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbYHBRw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 13:52:26 -0400
Received: from isilmar.linta.de ([213.133.102.198]:55105 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751136AbYHBRw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 13:52:26 -0400
Date: Sat, 2 Aug 2008 19:52:18 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [git pull] PCMCIA bugfix for 2.6.27
Message-ID: <20080802175218.GA4899@comet.dominikbrodowski.net>
Mail-Followup-To: torvalds@osdl.org, akpm@osdl.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

there's a small PCMCIA bugfix available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-fixes-2.6.git

Please pull from that location. The diffstat and list of changes follows,
the individual diffs is also attached below

Thanks,
	Dominik

Dominik Brodowski (1):
      pcmcia: rsrc_nonstatic: check value, not pointer

 drivers/pcmcia/rsrc_nonstatic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

---

From: Dominik Brodowski <linux@dominikbrodowski.net>
Date: Mon, 28 Jul 2008 16:37:10 +0200
Subject: [PATCH 01/17] pcmcia: rsrc_nonstatic: check value, not pointer

Bug found by Harvey Harrison and Stephen Rothwell.

Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
---
 drivers/pcmcia/rsrc_nonstatic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pcmcia/rsrc_nonstatic.c b/drivers/pcmcia/rsrc_nonstatic.c
index d0c1d63..203e579 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -275,7 +275,7 @@ static int readable(struct pcmcia_socket *s, struct resource *res,
 		destroy_cis_cache(s);
 	}
 	s->cis_mem.res = NULL;
-	if ((ret != 0) || (count == 0))
+	if ((ret != 0) || (*count == 0))
 		return 0;
 	return 1;
 }
-- 
1.5.4.3

