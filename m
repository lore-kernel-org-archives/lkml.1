Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbXC3VVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbXC3VVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbXC3VU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:20:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51537 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbXC3VLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:11:14 -0400
Date: Fri, 30 Mar 2007 14:05:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 20/37] DVB: fix nxt200x rf input switching
Message-ID: <20070330210510.GW29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dvb-fix-nxt200x-rf-input-switching.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michael Krufky <mkrufky@linuxtv.org>

DVB: fix nxt200x rf input switching

After dvb tuner refactoring, the pll buffer has been altered such that
the pll address is now stored in buf[0].  Instead of sending buf to
set_pll_input, we should send buf+1.

(cherry picked from commit f5ae29e284b328e0976789d5c199bbbe80e4b005)

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/frontends/nxt200x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/dvb/frontends/nxt200x.c
+++ b/drivers/media/dvb/frontends/nxt200x.c
@@ -562,7 +562,7 @@ static int nxt200x_setup_frontend_parame
 
 			/* set input */
 			if (state->config->set_pll_input)
-				state->config->set_pll_input(buf, 1);
+				state->config->set_pll_input(buf+1, 1);
 			break;
 		case VSB_8:
 			/* Set non-punctured clock for VSB */
@@ -571,7 +571,7 @@ static int nxt200x_setup_frontend_parame
 
 			/* set input */
 			if (state->config->set_pll_input)
-				state->config->set_pll_input(buf, 0);
+				state->config->set_pll_input(buf+1, 0);
 			break;
 		default:
 			return -EINVAL;

-- 
