Return-Path: <linux-kernel-owner+w=401wt.eu-S1765499AbZDAAUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765499AbZDAAUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765284AbZDAAUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:20:20 -0400
Received: from sous-sol.org ([216.99.217.87]:55729 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764940AbZDAAUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:20:19 -0400
Message-Id: <20090331231604.521404076@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:09 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, Beat Michel Liechti <bml303@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 24/45] DVB: firedtv: FireDTV S2 problems with tuning solved
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=dvb-firedtv-firedtv-s2-problems-with-tuning-solved.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Beat Michel Liechti <bml303@gmail.com>

upstream commit: 32a0f488ce5e8a9a148491f15edc508ab5e8265b

Tuning was broken on FireDTV S2 (and presumably  FloppyDTV S2) because a
wrong opcode was sent.  The box only gave "not implemented" responses.
Changing the opcode to _TUNE_QPSK2 fixes this for good.

Cc: stable@kernel.org
Signed-off-by: Beat Michel Liechti <bml303@gmail.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/media/dvb/firewire/firedtv-avc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/media/dvb/firewire/firedtv-avc.c
+++ b/drivers/media/dvb/firewire/firedtv-avc.c
@@ -135,6 +135,7 @@ static const char *debug_fcp_opcode(unsi
 	case SFE_VENDOR_OPCODE_REGISTER_REMOTE_CONTROL:	return "RegisterRC";
 	case SFE_VENDOR_OPCODE_LNB_CONTROL:		return "LNBControl";
 	case SFE_VENDOR_OPCODE_TUNE_QPSK:		return "TuneQPSK";
+	case SFE_VENDOR_OPCODE_TUNE_QPSK2:		return "TuneQPSK2";
 	case SFE_VENDOR_OPCODE_HOST2CA:			return "Host2CA";
 	case SFE_VENDOR_OPCODE_CA2HOST:			return "CA2Host";
 	}
@@ -266,7 +267,10 @@ static void avc_tuner_tuneqpsk(struct fi
 	c->operand[0] = SFE_VENDOR_DE_COMPANYID_0;
 	c->operand[1] = SFE_VENDOR_DE_COMPANYID_1;
 	c->operand[2] = SFE_VENDOR_DE_COMPANYID_2;
-	c->operand[3] = SFE_VENDOR_OPCODE_TUNE_QPSK;
+	if (fdtv->type == FIREDTV_DVB_S2)
+		c->operand[3] = SFE_VENDOR_OPCODE_TUNE_QPSK2;
+	else
+		c->operand[3] = SFE_VENDOR_OPCODE_TUNE_QPSK;
 
 	c->operand[4] = (params->frequency >> 24) & 0xff;
 	c->operand[5] = (params->frequency >> 16) & 0xff;

