Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbYGYXKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbYGYXKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 19:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbYGYXKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 19:10:32 -0400
Received: from ns1.suse.de ([195.135.220.2]:58166 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbYGYXKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 19:10:31 -0400
Date: Fri, 25 Jul 2008 16:07:14 -0700
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
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Micah Dowty <micah@navi.cx>, Thomas Sailer <t.sailer@alumni.ethz.ch>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 1/9] hdlcdrv: Fix CRC calculation.
Message-ID: <20080725230714.GB1612@suse.de>
References: <20080725225425.193966072@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0001-hdlcdrv-Fix-CRC-calculation.patch"
In-Reply-To: <20080725230644.GA1612@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Micah Dowty <micah@navi.cx>

[ Upstream commit ae6134bdf3197206fba95563d755d2fa50d90ddd ]

This is a trivial patch against the hdlcdrv module that fixes its CRC
calculation. The finished CRC was overwriting the first two bytes of
each packet rather than being appended to the end.

I've tested this with 2.6.8 and 2.6.10-rc1, but hdlcdrv hasn't changed
much recently so it should work with many other kernel versions.

Signed-off-by: Micah Dowty <micah@navi.cx>
Acked-by: Thomas Sailer <t.sailer@alumni.ethz.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/hamradio/hdlcdrv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/hamradio/hdlcdrv.c
+++ b/drivers/net/hamradio/hdlcdrv.c
@@ -88,6 +88,7 @@
 static inline void append_crc_ccitt(unsigned char *buffer, int len)
 {
  	unsigned int crc = crc_ccitt(0xffff, buffer, len) ^ 0xffff;
+	buffer += len;
 	*buffer++ = crc;
 	*buffer++ = crc >> 8;
 }

-- 
