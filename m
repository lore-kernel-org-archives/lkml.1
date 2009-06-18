Return-Path: <linux-kernel-owner+w=401wt.eu-S1758937AbZFRSR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937AbZFRSR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 14:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbZFRSRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 14:17:15 -0400
Received: from local.xorcom.com ([62.90.10.53]:38968 "EHLO local.xorcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756511AbZFRSRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 14:17:14 -0400
X-Greylist: delayed 1893 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Jun 2009 14:17:13 EDT
Date: Thu, 18 Jun 2009 20:45:40 +0300
From: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <greg@kroah.com>, OSLEC list <freetel-oslec@lists.sourceforge.net>
Subject: [PATCH] fix Pstate growing in OSLEC
Message-ID: <20090618174540.GT3311@xorcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Forced-Service: Sadly Using Gmail [tm]
Organization: Xorcom*
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following fix has been posted in the OSLEC mailing list by Ruslan
Cray (and shortly afterwards acepted into the OSLEC SVN tree). Sadly it
has not been forwarded the kernel.org tree until now.

See:

http://sourceforge.net/mailarchive/forum.php?thread_name=000b01c9d88f%24ec689690%2475a8a8c0%40rcraydvlpmnt&forum_name=freetel-oslec

As a side note, the OSLEC code is gathering dust in the staging tree.
As-is it is mostly useless without providing an interface for its code.
I was hoping to see the mISDN code starting to use it but so far no 
change in that front.

---
 drivers/staging/echo/echo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/echo/echo.c b/drivers/staging/echo/echo.c
index 6d7217e..faab26d 100644
--- a/drivers/staging/echo/echo.c
+++ b/drivers/staging/echo/echo.c
@@ -395,7 +395,7 @@ int16_t oslec_update(struct oslec_state *ec, int16_t tx, int16_t rx)
 		old = (int)ec->fir_state.history[ec->fir_state.curr_pos] *
 		    (int)ec->fir_state.history[ec->fir_state.curr_pos];
 		ec->Pstates +=
-		    ((new - old) + (1 << ec->log2taps)) >> ec->log2taps;
+		    ((new - old) + (1 << (ec->log2taps - 1))) >> ec->log2taps;
 		if (ec->Pstates < 0)
 			ec->Pstates = 0;
 	}
-- 
1.5.6.5


-- 
               Tzafrir Cohen
icq#16849755              jabber:tzafrir.cohen@xorcom.com
+972-50-7952406           mailto:tzafrir.cohen@xorcom.com
http://www.xorcom.com  iax:guest@local.xorcom.com/tzafrir
