Return-Path: <linux-kernel-owner+w=401wt.eu-S1761385AbXIXQ3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385AbXIXQ3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759092AbXIXQZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:25:39 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47303 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760548AbXIXQZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:25:35 -0400
Date: Mon, 24 Sep 2007 09:20:37 -0700
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
       David Howells <dhowells@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>, Jason Lunz <lunz@falooley.org>
Subject: [13/50] MTD: Initialise s_flags in get_sb_mtd_aux()
Message-ID: <20070924162037.GN13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mtd-initialise-s_flags-in-get_sb_mtd_aux.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

changeset 48440e893d700fb8f0de95fa7d748b711d290365 from mainline.

Initialise s_flags in get_sb_mtd_aux() from the flags parameter.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Cc: Jason Lunz <lunz@falooley.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/mtdsuper.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mtd/mtdsuper.c
+++ b/drivers/mtd/mtdsuper.c
@@ -70,6 +70,8 @@ static int get_sb_mtd_aux(struct file_sy
 	DEBUG(1, "MTDSB: New superblock for device %d (\"%s\")\n",
 	      mtd->index, mtd->name);
 
+	sb->s_flags = flags;
+
 	ret = fill_super(sb, data, flags & MS_SILENT ? 1 : 0);
 	if (ret < 0) {
 		up_write(&sb->s_umount);

-- 
