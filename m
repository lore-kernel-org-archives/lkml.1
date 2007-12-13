Return-Path: <linux-kernel-owner+w=401wt.eu-S1762222AbXLMGsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762222AbXLMGsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759176AbXLMGif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:38:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56676 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821AbXLMGie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:38:34 -0500
Date: Wed, 12 Dec 2007 22:35:29 -0800
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
Subject: [patch 32/36] XFS: Make xfsbufd threads freezable
Message-ID: <20071213063529.GG25301@kroah.com>
References: <20071213062511.265908583@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="xfs-make-xfsbufd-threads-freezable.patch"
In-Reply-To: <20071213063308.GA25301@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
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
@@ -1733,6 +1733,8 @@ xfsbufd(
 
 	current->flags |= PF_MEMALLOC;
 
+	set_freezable();
+
 	do {
 		if (unlikely(freezing(current))) {
 			set_bit(XBT_FORCE_SLEEP, &target->bt_flags);

-- 
