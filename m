Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbXCSVjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbXCSVjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbXCSVjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:39:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:59070 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbXCSVjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:39:16 -0400
Date: Mon, 19 Mar 2007 14:37:16 -0700
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
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 02/31] Fix rtm_to_ifaddr() error return.
Message-ID: <20070319213716.GD9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-rtm_to_ifaddr-error-return.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

[IPV4]: Fix rtm_to_ifaddr() error handling.

Return negative error value (embedded in the pointer) instead of
returning NULL.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/devinet.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -503,8 +503,10 @@ static struct in_ifaddr *rtm_to_ifaddr(s
 		goto errout;
 
 	ifm = nlmsg_data(nlh);
-	if (ifm->ifa_prefixlen > 32 || tb[IFA_LOCAL] == NULL)
+	if (ifm->ifa_prefixlen > 32 || tb[IFA_LOCAL] == NULL) {
+		err = -EINVAL;
 		goto errout;
+	}
 
 	dev = __dev_get_by_index(ifm->ifa_index);
 	if (dev == NULL) {

-- 
