Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759658AbYLQAF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759658AbYLQAF7 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYLQAFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:05:49 -0500
Received: from kroah.org ([198.145.64.141]:41161 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750998AbYLQAFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:05:48 -0500
Date: Tue, 16 Dec 2008 16:04:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
        Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
        Chris Wedgwood <reviews@ml.cw.f00f.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Chuck Ebbert <cebbert@redhat.com>,
        Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
        Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jay Vosburgh <fubar@us.ibm.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 02/22] bonding: fix miimon failure counter
Message-ID: <20081217000400.GC4504@kroah.com>
References: <20081216235704.347182084@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="bonding-fix-miimon-failure-counter.patch"
In-Reply-To: <20081217000306.GA4504@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jay Vosburgh <fubar@us.ibm.com>

commit fba4acda35f3119328bcba28aacefae14245d2bb upstream.

During the rework of the mii monitor for:

  commit f0c76d61779b153dbfb955db3f144c62d02173c2
  Author: Jay Vosburgh <fubar@us.ibm.com>
  Date:   Wed Jul 2 18:21:58 2008 -0700

    bonding: refactor mii monitor

I left out the increment of the link failure counter.  This
patch corrects that omission.

Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bonding/bond_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2370,6 +2370,9 @@ static void bond_miimon_commit(struct bo
 			continue;
 
 		case BOND_LINK_DOWN:
+			if (slave->link_failure_count < UINT_MAX)
+				slave->link_failure_count++;
+
 			slave->link = BOND_LINK_DOWN;
 
 			if (bond->params.mode == BOND_MODE_ACTIVEBACKUP ||

