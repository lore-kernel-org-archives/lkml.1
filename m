Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbYBWAiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbYBWAiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934102AbYBWAeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:34:07 -0500
Received: from ns2.suse.de ([195.135.220.15]:55378 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934056AbYBWAeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:34:04 -0500
Date: Fri, 22 Feb 2008 16:30:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Shan Wei <shanwei@cn.fujitsu.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 10/38] TCP: Fix a bug in strategy_allowed_congestion_control
Message-ID: <20080223003008.GK7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tcp-fix-a-bug-in-strategy_allowed_congestion_control.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
 
 Upstream commit: 16ca3f913001efdb6171a2781ef41c77474e3895

In strategy_allowed_congestion_control of the 2.6.24 kernel, when
sysctl_string return 1 on success,it should call
tcp_set_allowed_congestion_control to set the allowed congestion
control.But, it don't.  the sysctl_string return 1 on success,
otherwise return negative, never return 0.The patch fix the problem.

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/sysctl_net_ipv4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -248,7 +248,7 @@ static int strategy_allowed_congestion_c
 
 	tcp_get_available_congestion_control(tbl.data, tbl.maxlen);
 	ret = sysctl_string(&tbl, name, nlen, oldval, oldlenp, newval, newlen);
-	if (ret == 0 && newval && newlen)
+	if (ret == 1 && newval && newlen)
 		ret = tcp_set_allowed_congestion_control(tbl.data);
 	kfree(tbl.data);
 

-- 
