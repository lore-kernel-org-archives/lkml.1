Return-Path: <linux-kernel-owner+w=401wt.eu-S1161373AbXDKWzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161373AbXDKWzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161337AbXDKWyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:54:45 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55625 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161363AbXDKWyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:54:41 -0400
Date: Wed, 11 Apr 2007 15:51:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Netfilter Development Mailinglist 
	<netfilter-devel@lists.netfilter.org>,
       "David S. Miller" <davem@davemloft.net>,
       Jaroslav Kysela <perex@suse.cz>, Patrick McHardy <kaber@trash.net>
Subject: [patch 13/31] NETFILTER: ipt_CLUSTERIP: fix oops in checkentry
	function
Message-ID: <20070411225159.GN24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="netfilter-ipt_clusterip-fix-oops-in-checkentry-function.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Patrick McHardy <kaber@trash.net>

[NETFILTER]: ipt_CLUSTERIP: fix oops in checkentry function

The clusterip_config_find_get() already increases entries reference
counter, so there is no reason to do it twice in checkentry() callback.

This causes the config to be freed before it is removed from the list,
resulting in a crash when adding the next rule.

Signed-off-by: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 net/ipv4/netfilter/ipt_CLUSTERIP.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -409,12 +409,10 @@ checkentry(const char *tablename,
 				       "has invalid config pointer!\n");
 				return 0;
 			}
-			clusterip_config_entry_get(cipinfo->config);
 		} else {
 			/* Case B: This is a new rule referring to an existing
 			 * clusterip config. */
 			cipinfo->config = config;
-			clusterip_config_entry_get(cipinfo->config);
 		}
 	} else {
 		/* Case C: This is a completely new clusterip config */

-- 
