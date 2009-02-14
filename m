Return-Path: <linux-kernel-owner+w=401wt.eu-S1763175AbZBNBKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763175AbZBNBKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761032AbZBNBBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:01:49 -0500
Received: from kroah.org ([198.145.64.141]:39681 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760877AbZBNBBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:01:46 -0500
Date: Fri, 13 Feb 2009 16:58:52 -0800
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
       alan@lxorguk.ukuu.org.uk, Paolo Abeni <paolo.abeni@gmail.com>,
       Sebastiano Di Paola <sebastiano.dipaola@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 24/47] net: packet socket packet_lookup_frame fix
Message-ID: <20090214005852.GY11282@kroah.com>
References: <20090214005130.617401075@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-packet-socket-packet_lookup_frame-fix.patch"
In-Reply-To: <20090214005726.GA11282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sebastiano Di Paola <sebastiano.dipaola@gmail.com>

[ Upstream commit f9e6934502e46c363100245f137ddf0f4b1cb574 ]

packet_lookup_frames() fails to get user frame if current frame header
status contains extra flags.
This is due to the wrong assumption on the operators precedence during
frame status tests.
Fixed by forcing the right operators precedence order with explicit brackets.

Signed-off-by: Paolo Abeni <paolo.abeni@gmail.com>
Signed-off-by: Sebastiano Di Paola <sebastiano.dipaola@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/packet/af_packet.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -220,13 +220,13 @@ static void *packet_lookup_frame(struct 
 	h.raw = po->pg_vec[pg_vec_pos] + (frame_offset * po->frame_size);
 	switch (po->tp_version) {
 	case TPACKET_V1:
-		if (status != h.h1->tp_status ? TP_STATUS_USER :
-						TP_STATUS_KERNEL)
+		if (status != (h.h1->tp_status ? TP_STATUS_USER :
+						TP_STATUS_KERNEL))
 			return NULL;
 		break;
 	case TPACKET_V2:
-		if (status != h.h2->tp_status ? TP_STATUS_USER :
-						TP_STATUS_KERNEL)
+		if (status != (h.h2->tp_status ? TP_STATUS_USER :
+						TP_STATUS_KERNEL))
 			return NULL;
 		break;
 	}

