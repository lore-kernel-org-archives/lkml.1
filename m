Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbZKTSVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbZKTSVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 13:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbZKTSVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 13:21:23 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:63438 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbZKTSVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 13:21:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=qowA/KbD2UYPxWpFGp/+62vdhxNQ89h0zD4qCNIbzPkfrQ0n7FOZ0kd6cQWmYeSGXp
         v/0bOGSw7qRpcj4tFrHKnzAbECcBeV8UI8FkdOOtl2t4kmk2JWvINgtFxcKp82nMBHBw
         u1TRSW+RTKnrViEqlaqeMWjcm5+7v9f3Pckr4=
Message-ID: <4B06E125.6090305@gmail.com>
Date: Fri, 20 Nov 2009 19:34:13 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, mkrufky@linuxtv.org
Subject: [PATCH] V4L/DVB: Fix test in copy_reg_bits()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reg_pair2[j].reg was tested twice.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/media/common/tuners/mxl5007t.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

I think this was intended?

diff --git a/drivers/media/common/tuners/mxl5007t.c b/drivers/media/common/tuners/mxl5007t.c
index 2d02698..7eb1bf7 100644
--- a/drivers/media/common/tuners/mxl5007t.c
+++ b/drivers/media/common/tuners/mxl5007t.c
@@ -196,7 +196,7 @@ static void copy_reg_bits(struct reg_pair_t *reg_pair1,
 	i = j = 0;
 
 	while (reg_pair1[i].reg || reg_pair1[i].val) {
-		while (reg_pair2[j].reg || reg_pair2[j].reg) {
+		while (reg_pair2[j].reg || reg_pair2[j].val) {
 			if (reg_pair1[i].reg != reg_pair2[j].reg) {
 				j++;
 				continue;
