Return-Path: <linux-kernel-owner+w=401wt.eu-S1763957AbYBBA0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763957AbYBBA0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762999AbYBBAYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:24:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:55607 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762988AbYBBAYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:24:19 -0500
Date: Fri, 1 Feb 2008 16:20:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       maximilian attems <max@stro.at>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 07/27] IRDA: irda_create() nuke user triggable printk
Message-ID: <20080202002012.GH8368@suse.de>
References: <20080202001232.472591439@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="irda-irda_create-nuke-user-triggable-printk.patch"
In-Reply-To: <20080202001927.GA8368@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: maximilian attems <max@stro.at>

[IRDA]: irda_create() nuke user triggable printk

[ Upstream commit: 9e8d6f8959c356d8294d45f11231331c3e1bcae6 ]

easy to trigger as user with sfuzz.

irda_create() is quiet on unknown sock->type,
match this behaviour for SOCK_DGRAM unknown protocol

Signed-off-by: maximilian attems <max@stro.at>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/irda/af_irda.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -1115,8 +1115,6 @@ static int irda_create(struct socket *so
 			self->max_sdu_size_rx = TTP_SAR_UNBOUND;
 			break;
 		default:
-			IRDA_ERROR("%s: protocol not supported!\n",
-				   __FUNCTION__);
 			return -ESOCKTNOSUPPORT;
 		}
 		break;

-- 
