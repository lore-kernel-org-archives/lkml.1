Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbZCAQdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbZCAQdH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 11:33:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbZCAQcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 11:32:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:46974 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbZCAQcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 11:32:54 -0500
Message-ID: <49AAB8B2.8060801@suse.de>
Date: Sun, 01 Mar 2009 17:32:50 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, kkeil@suse.de, linux-isdn@vger.kernel.org,
       fseidel@suse.de, Frank Seidel <frank@f-seidel.de>,
       =?ISO-8859-1?Q?Ilpo_?= =?ISO-8859-1?Q?J=E4rvinen?= 
	<ilpo.jarvinen@helsinki.fi>,
       Andreas Eversberg <andreas@eversberg.eu>,
       Hannes Eder <hannes@hanneseder.net>, Adrian Bunk <bunk@kernel.org>
Subject: [PATCH] isdn: reduce stack size of mISDN_dsp
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Seidel <frank@f-seidel.de>

Reduce stack size memory footprint of mISDN_dsp.
(From 1468 bytes for dsp_cmx_send on i386 down
to 44).

Signed-off-by: Frank Seidel <frank@f-seidel.de>
---
 drivers/isdn/mISDN/dsp_cmx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/isdn/mISDN/dsp_cmx.c
+++ b/drivers/isdn/mISDN/dsp_cmx.c
@@ -1592,7 +1592,8 @@ dsp_cmx_send(void *arg)
 	struct dsp_conf_member *member;
 	struct dsp *dsp;
 	int mustmix, members;
-	s32 mixbuffer[MAX_POLL+100], *c;
+	static s32 mixbuffer[MAX_POLL+100];
+	s32 *c;
 	u8 *p, *q;
 	int r, rr;
 	int jittercheck = 0, delay, i;

