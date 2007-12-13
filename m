Return-Path: <linux-kernel-owner+w=401wt.eu-S1765040AbXLMHVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765040AbXLMHVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762733AbXLMG65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:58:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55801 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761855AbXLMG6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:58:55 -0500
Date: Wed, 12 Dec 2007 22:53:55 -0800
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
       "Rafael J. Wysocki" <rjw@sisk.pl>, David Chinner <dgc@sgi.com>,
       Lachlan McIlroy <lachlan@sgi.com>, Oliver Pintr <oliver.pntr@gmail.com>
Subject: [patch 60/60] XFS: Make xfsbufd threads freezable
Message-ID: <20071213065355.GJ6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="xfs-make-xfsbufd-threads-freezable.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Rafael J. Wysocki <rjw@sisk.pl>

patch 978c7b2ff49597ab76ff7529a933bd366941ac25 in mainline

Fix breakage caused by commit 831441862956fffa17b9801db37e6ea1650b0f69
that did not introduce the necessary call to set_freezable() in
xfs/linux-2.6/xfs_buf.c .

SGI-PV: 974224
SGI-Modid: xfs-linux-melb:xfs-kern:30203a

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: David Chinner <dgc@sgi.com>
Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
Cc: Oliver Pintr <oliver.pntr@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_buf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1744,6 +1744,8 @@ xfsbufd(
 
 	current->flags |= PF_MEMALLOC;
 
+	set_freezable();
+
 	do {
 		if (unlikely(freezing(current))) {
 			set_bit(XBT_FORCE_SLEEP, &target->bt_flags);

-- 
