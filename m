Return-Path: <linux-kernel-owner+w=401wt.eu-S1161337AbXDKXDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161337AbXDKXDD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 19:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161368AbXDKWzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:55:06 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55682 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161359AbXDKWy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:54:59 -0400
Date: Wed, 11 Apr 2007 15:52:23 -0700
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
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 19/31] Fix tcindex classifier ABI borkage...
Message-ID: <20070411225223.GT24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-tcindex-classifier-abi-borkage.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Patrick McHardy <kaber@trash.net>

[NET_SCHED]: cls_tcindex: fix compatibility breakage

Userspace uses an integer for TCA_TCINDEX_SHIFT, the kernel was changed
to expect and use a u16 value in 2.6.11, which broke compatibility on
big endian machines. Change back to use int.

Reported by Ole Reinartz <ole.reinartz@gmx.de>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/cls_tcindex.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -245,9 +245,9 @@ tcindex_set_parms(struct tcf_proto *tp, 
 	}
 
 	if (tb[TCA_TCINDEX_SHIFT-1]) {
-		if (RTA_PAYLOAD(tb[TCA_TCINDEX_SHIFT-1]) < sizeof(u16))
+		if (RTA_PAYLOAD(tb[TCA_TCINDEX_SHIFT-1]) < sizeof(int))
 			goto errout;
-		cp.shift = *(u16 *) RTA_DATA(tb[TCA_TCINDEX_SHIFT-1]);
+		cp.shift = *(int *) RTA_DATA(tb[TCA_TCINDEX_SHIFT-1]);
 	}
 
 	err = -EBUSY;

-- 
