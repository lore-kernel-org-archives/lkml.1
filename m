Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbYKDXpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbYKDXpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757480AbYKDXiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:38:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:52005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757473AbYKDXix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:38:53 -0500
Date: Tue, 4 Nov 2008 15:31:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux1394-devel@lists.sourceforge.net,
       Jay Fenlason <fenlason@redhat.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 22/57] firewire: Survive more than 256 bus resets
Message-ID: <20081104233144.GW659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="firewire-survive-more-than-256-bus-resets.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jay Fenlason <fenlason@redhat.com>

Same as commit 4f9740d4f5a17fa6a1b097fa3ccdfb7246660307 upstream

The "color" is used during the topology building after a bus reset,
hovever in "struct fw_node"s it is stored in a u8, but in struct fw_card
it is stored in an int.  When the value wraps in one struct, but not
the other, disaster strikes.

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=10922 -
machine locks up solid if a series of bus resets occurs.


Signed-off-by: Jay Fenlason <fenlason@redhat.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/fw-transaction.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firewire/fw-transaction.h
+++ b/drivers/firewire/fw-transaction.h
@@ -248,7 +248,7 @@ struct fw_card {
 	struct fw_node *local_node;
 	struct fw_node *root_node;
 	struct fw_node *irm_node;
-	int color;
+	u8 color; /* must be u8 to match the definition in struct fw_node */
 	int gap_count;
 	bool beta_repeaters_present;
 

-- 
