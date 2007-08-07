Return-Path: <linux-kernel-owner+w=401wt.eu-S934343AbXHGVOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934343AbXHGVOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935775AbXHGUyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:54:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59632 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935768AbXHGUym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:54:42 -0400
Date: Tue, 7 Aug 2007 13:47:43 -0700
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
       Latchesar Ionkov <lucho@ionkov.net>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Eric Van Hensbergen <ericvh@ericvh.myip.org>
Subject: [2.6.22.2 review 53/84] fs: 9p/conv.c error path fix
Message-ID: <20070807204743.GC23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fs-9p-conv.c-error-path-fix.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>


When buf_check_overflow() returns != 0 we will hit kfree(ERR_PTR(err))
and it will not be happy about it.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/9p/conv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/9p/conv.c
+++ b/fs/9p/conv.c
@@ -742,6 +742,7 @@ struct v9fs_fcall *v9fs_create_twrite(u3
 	if (err) {
 		kfree(fc);
 		fc = ERR_PTR(err);
+		goto error;
 	}
 
 	if (buf_check_overflow(bufp)) {

-- 
