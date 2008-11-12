Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbYKLAk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbYKLAk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYKLA0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:52 -0500
Received: from kroah.org ([198.145.64.141]:42555 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752506AbYKLA0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:50 -0500
Date: Tue, 11 Nov 2008 16:24:11 -0800
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
       alan@lxorguk.ukuu.org.uk, Reinette Chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 37/49] iwl3945: do not send scan command if channel count
	zero
Message-ID: <20081112002411.GL10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="iwl3945-do-not-send-scan-command-if-channel-count-zero.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Reinette Chatre <reinette.chatre@intel.com>

commit 14b5433606289dbc5b6fd70ced11462f80e95003 upstream.

Do not send scan command if no channels to scan.

This avoids a Microcode error as reported in:
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1650
http://bugzilla.kernel.org/show_bug.cgi?id=11806
http://marc.info/?l=linux-wireless&m=122437145211886&w=2

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6259,6 +6259,11 @@ static void iwl3945_bg_request_scan(stru
 				direct_mask,
 				(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
 
+	if (scan->channel_count == 0) {
+		IWL_DEBUG_SCAN("channel count %d\n", scan->channel_count);
+		goto done;
+	}
+
 	cmd.len += le16_to_cpu(scan->tx_cmd.len) +
 	    scan->channel_count * sizeof(struct iwl3945_scan_channel);
 	cmd.data = scan;

-- 
