Return-Path: <linux-kernel-owner+w=401wt.eu-S1762459AbZBNBHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762459AbZBNBHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758474AbZBNBBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:01:39 -0500
Received: from kroah.org ([198.145.64.141]:39566 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757936AbZBNBBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:01:38 -0500
Date: Fri, 13 Feb 2009 16:58:35 -0800
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
       alan@lxorguk.ukuu.org.uk, Vlad Yasevich <vladislav.yasevich@hp.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 16/47] sctp: Fix crc32c calculations on big-endian arhes.
Message-ID: <20090214005835.GQ11282@kroah.com>
References: <20090214005130.617401075@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sctp-fix-crc32c-calculations-on-big-endian-arhes.patch"
In-Reply-To: <20090214005726.GA11282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vlad Yasevich <vladislav.yasevich@hp.com>

[ Upstream commit 9c5ff5f75d0d0a1c7928ecfae3f38418b51a88e3 ]

crc32c algorithm provides a byteswaped result.  On little-endian
arches, the result ends up in big-endian/network byte order.
On big-endinan arches, the result ends up in little-endian
order and needs to be byte swapped again.  Thus calling cpu_to_le32
gives the right output.

Tested-by: Jukka Taimisto <jukka.taimisto@mail.suomi.net>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/sctp/checksum.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/net/sctp/checksum.h
+++ b/include/net/sctp/checksum.h
@@ -79,5 +79,5 @@ static inline __be32 sctp_update_cksum(_
 
 static inline __be32 sctp_end_cksum(__be32 crc32)
 {
-	return ~crc32;
+	return (__force __be32)~cpu_to_le32((__force u32)crc32);
 }

