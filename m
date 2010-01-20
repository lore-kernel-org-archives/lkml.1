Return-Path: <linux-kernel-owner+w=401wt.eu-S932125Ab0ATCPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab0ATCPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 21:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311Ab0ATCPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 21:15:40 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:37497 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296Ab0ATCPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 21:15:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=xJqA1iRZ6YtB7LTTtFn6get1AVESXHeVaZfr7UWPXSONlBGH6uXKZrUShfsw+fwFwf
         6lv72yhpIQhZUcHnnDU/BKk2Crwc/+LGUfj9NMHnfL035ZRxbUitOPR2Z5Z7ARG3fa9z
         TtSpDQ3xDnFHmSadCcu0t76PUKMPdybpIqIqU=
Message-ID: <4B56685E.9060909@gmail.com>
Date: Wed, 20 Jan 2010 03:20:14 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mxl5005s: bad checks of state->Mode
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regardless of the state->Mode in both cases the same value was
written.
If state->Mode wasn't set, it is always 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/media/common/tuners/mxl5005s.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

Or were the ones and zeroes in these MXL_ControlWrite in the wrong place?

diff --git a/drivers/media/common/tuners/mxl5005s.c b/drivers/media/common/tuners/mxl5005s.c
index 605e28b..3967412 100644
--- a/drivers/media/common/tuners/mxl5005s.c
+++ b/drivers/media/common/tuners/mxl5005s.c
@@ -1815,9 +1815,8 @@ static u16 MXL_BlockInit(struct dvb_frontend *fe)
 
 	/* Charge Pump Control Dig  Ana */
 	status += MXL_ControlWrite(fe, RFSYN_CHP_GAIN, state->Mode ? 5 : 8);
-	status += MXL_ControlWrite(fe,
-		RFSYN_EN_CHP_HIGAIN, state->Mode ? 1 : 1);
-	status += MXL_ControlWrite(fe, EN_CHP_LIN_B, state->Mode ? 0 : 0);
+	status += MXL_ControlWrite(fe, RFSYN_EN_CHP_HIGAIN, 1);
+	status += MXL_ControlWrite(fe, EN_CHP_LIN_B, 0);
 
 	/* AGC TOP Control */
 	if (state->AGC_Mode == 0) /* Dual AGC */ {
@@ -2161,7 +2160,7 @@ static u16 MXL_IFSynthInit(struct dvb_frontend *fe)
 		}
 	}
 
-	if (state->Mode || (state->Mode == 0 && state->IF_Mode == 0)) {
+	if (state->Mode || state->IF_Mode == 0) {
 		if (state->IF_LO == 57000000UL) {
 			status += MXL_ControlWrite(fe, IF_DIVVAL,   0x10);
 			status += MXL_ControlWrite(fe, IF_VCO_BIAS, 0x08);
