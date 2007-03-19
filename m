Return-Path: <linux-kernel-owner+w=401wt.eu-S932785AbXCSVi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785AbXCSVi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbXCSVi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:38:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:55436 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbXCSViz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:38:55 -0400
Date: Mon, 19 Mar 2007 14:37:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Olaf Kirch <olaf.kirch@oracle.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 01/31] Fix another NULL pointer deref in ipv6_sockglue.c
Message-ID: <20070319213704.GC9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-another-null-pointer-deref-in-ipv6_sockglue.c.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Olaf Kirch <olaf.kirch@oracle.com>

[IPV6]: Fix for ipv6_setsockopt NULL dereference

I came across this bug in http://bugzilla.kernel.org/show_bug.cgi?id=8155

Signed-off-by: Olaf Kirch <olaf.kirch@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/ipv6_sockglue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -414,7 +414,7 @@ static int do_ipv6_setsockopt(struct soc
 		}
 
 		/* routing header option needs extra check */
-		if (optname == IPV6_RTHDR && opt->srcrt) {
+		if (optname == IPV6_RTHDR && opt && opt->srcrt) {
 			struct ipv6_rt_hdr *rthdr = opt->srcrt;
 			switch (rthdr->type) {
 			case IPV6_SRCRT_TYPE_0:

-- 
