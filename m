Return-Path: <linux-kernel-owner+w=401wt.eu-S1761274AbXHVI7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761274AbXHVI7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbXHVIxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:05 -0400
Received: from 1wt.eu ([62.212.114.60]:1981 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbXHVIxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:02 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084010.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:09 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Daniel Ritz <daniel.ritz@gmx.ch>,
       Nils Neumann <nils.neumann@rwth-aachen.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 25/58] pcmcia: give socket time to power down
Content-Disposition: inline; filename=0025-pcmcia-give-socket-time-to-power-down.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Give sockets up to 100ms of additional time to power down.  otherwise we
might generate false warnings with KERN_ERR priority (like in bug #8262).

Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>
Cc: Nils Neumann <nils.neumann@rwth-aachen.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/pcmcia/cs.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
index 606a467..2785d83 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -410,6 +410,9 @@ static void socket_shutdown(struct pcmcia_socket *s)
 #endif
 	s->functions = 0;
 
+	/* give socket some time to power down */
+	msleep(100);
+
 	s->ops->get_status(s, &status);
 	if (status & SS_POWERON) {
 		printk(KERN_ERR "PCMCIA: socket %p: *** DANGER *** unable to remove socket power
", s);
-- 
1.5.2.5

-- 
