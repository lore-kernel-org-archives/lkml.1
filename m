Return-Path: <linux-kernel-owner+w=401wt.eu-S1764321AbYD2RbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764321AbYD2RbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758385AbYD2RVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:21:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:43491 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759261AbYD2RVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:21:47 -0400
Date: Tue, 29 Apr 2008 10:19:01 -0700
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
       Jeff Garzik <jgarzik@redhat.com>
Subject: [27/37] tehuti: move ioctl perm check closer to function start
	(CVE-2008-1675)
Message-ID: <20080429171901.GB14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tehuti-move-ioctl-perm-check-closer-to-function-start.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jeff Garzik <jeff@garzik.org>

Commit f946dffed6334f08da065a89ed65026ebf8b33b4 upstream

Noticed by davem.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/tehuti.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/tehuti.c
+++ b/drivers/net/tehuti.c
@@ -649,6 +649,9 @@ static int bdx_ioctl_priv(struct net_dev
 		DBG("%d 0x%x 0x%x\n", data[0], data[1], data[2]);
 	}
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	switch (data[0]) {
 
 	case BDX_OP_READ:
@@ -664,8 +667,6 @@ static int bdx_ioctl_priv(struct net_dev
 		break;
 
 	case BDX_OP_WRITE:
-		if (!capable(CAP_NET_ADMIN))
-			return -EPERM;
 		error = bdx_range_check(priv, data[1]);
 		if (error < 0)
 			return error;

-- 
