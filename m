Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbYJHTlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbYJHTlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbYJHTkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:40:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:8491 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbYJHTko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:40:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NYZ1NFhr4eYIIcn8oBPk2tvsCi6/DOkMPSVAUBbXxI0l6W9Ljvy8dHNat2RblsHVOY
         uDFbJH3vqY5Av44JNOQrD98UloBkigOc0wZLeRrB40JWEWoKfkg1uWdpARhjylbPxUlH
         6XsaPMUmA3KG2H1abI5xmWXbYrHxUADzYfw4I=
From: "Richard A. Holden III" <aciddeath@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Richard A. Holden III" <aciddeath@gmail.com>, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 01/10] ixj: Remove code duplication for processing codec names.
Date: Wed,  8 Oct 2008 14:41:36 -0600
Message-Id: <b1f8a69aa47d6aab5d5a951bc78c99c26dd67658.1223497216.git.aciddeath@gmail.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <cover.1223497216.git.aciddeath@gmail.com>
References: <cover.1223497216.git.aciddeath@gmail.com>
In-Reply-To: <cover.1223497216.git.aciddeath@gmail.com>
References: <cover.1223497216.git.aciddeath@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard A. Holden III <aciddeath@gmail.com>
---
 drivers/telephony/ixj.c |  124 ++++++++++++++---------------------------------
 1 files changed, 36 insertions(+), 88 deletions(-)

diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index ec7aeb5..1b2387e 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -7122,6 +7122,40 @@ IXJ *ixj_pcmcia_probe(unsigned long dsp, unsigned long xilinx)
 
 EXPORT_SYMBOL(ixj_pcmcia_probe);		/* Fpr PCMCIA */
 
+static int sprintf_codec_name(int len, char *buf, unsigned int codec)
+{
+	switch (codec) {
+	case G723_63:
+		return sprintf(buf + len, "G.723.1 6.3");
+	case G723_53:
+		return sprintf(buf + len, "G.723.1 5.3");
+	case TS85:
+		return sprintf(buf + len, "TrueSpeech 8.5");
+	case TS48:
+		return sprintf(buf + len, "TrueSpeech 4.8");
+	case TS41:
+		return sprintf(buf + len, "TrueSpeech 4.1");
+	case G728:
+		return sprintf(buf + len, "G.728");
+	case G729:
+		return sprintf(buf + len, "G.729");
+	case G729B:
+		return sprintf(buf + len, "G.729B");
+	case ULAW:
+		return sprintf(buf + len, "uLaw");
+	case ALAW:
+		return sprintf(buf + len, "aLaw");
+	case LINEAR16:
+		return sprintf(buf + len, "16 bit Linear");
+	case LINEAR8:
+		return sprintf(buf + len, "8 bit Linear");
+	case WSS:
+		return sprintf(buf + len, "Windows Sound System");
+	default:
+		return sprintf(buf + len, "NO CODEC CHOSEN");
+	}
+}
+
 static int ixj_get_status_proc(char *buf)
 {
 	int len;
@@ -7191,95 +7225,9 @@ static int ixj_get_status_proc(char *buf)
 				len += sprintf(buf + len, "\nCaller ID data not sent");
 
 			len += sprintf(buf + len, "\nPlay CODEC ");
-			switch (j->play_codec) {
-			case G723_63:
-				len += sprintf(buf + len, "G.723.1 6.3");
-				break;
-			case G723_53:
-				len += sprintf(buf + len, "G.723.1 5.3");
-				break;
-			case TS85:
-				len += sprintf(buf + len, "TrueSpeech 8.5");
-				break;
-			case TS48:
-				len += sprintf(buf + len, "TrueSpeech 4.8");
-				break;
-			case TS41:
-				len += sprintf(buf + len, "TrueSpeech 4.1");
-				break;
-			case G728:
-				len += sprintf(buf + len, "G.728");
-				break;
-			case G729:
-				len += sprintf(buf + len, "G.729");
-				break;
-			case G729B:
-				len += sprintf(buf + len, "G.729B");
-				break;
-			case ULAW:
-				len += sprintf(buf + len, "uLaw");
-				break;
-			case ALAW:
-				len += sprintf(buf + len, "aLaw");
-				break;
-			case LINEAR16:
-				len += sprintf(buf + len, "16 bit Linear");
-				break;
-			case LINEAR8:
-				len += sprintf(buf + len, "8 bit Linear");
-				break;
-			case WSS:
-				len += sprintf(buf + len, "Windows Sound System");
-				break;
-			default:
-				len += sprintf(buf + len, "NO CODEC CHOSEN");
-				break;
-			}
+			len += sprintf_codec_name(len, buf, j->play_codec);
 			len += sprintf(buf + len, "\nRecord CODEC ");
-			switch (j->rec_codec) {
-			case G723_63:
-				len += sprintf(buf + len, "G.723.1 6.3");
-				break;
-			case G723_53:
-				len += sprintf(buf + len, "G.723.1 5.3");
-				break;
-			case TS85:
-				len += sprintf(buf + len, "TrueSpeech 8.5");
-				break;
-			case TS48:
-				len += sprintf(buf + len, "TrueSpeech 4.8");
-				break;
-			case TS41:
-				len += sprintf(buf + len, "TrueSpeech 4.1");
-				break;
-			case G728:
-				len += sprintf(buf + len, "G.728");
-				break;
-			case G729:
-				len += sprintf(buf + len, "G.729");
-				break;
-			case G729B:
-				len += sprintf(buf + len, "G.729B");
-				break;
-			case ULAW:
-				len += sprintf(buf + len, "uLaw");
-				break;
-			case ALAW:
-				len += sprintf(buf + len, "aLaw");
-				break;
-			case LINEAR16:
-				len += sprintf(buf + len, "16 bit Linear");
-				break;
-			case LINEAR8:
-				len += sprintf(buf + len, "8 bit Linear");
-				break;
-			case WSS:
-				len += sprintf(buf + len, "Windows Sound System");
-				break;
-			default:
-				len += sprintf(buf + len, "NO CODEC CHOSEN");
-				break;
-			}
+			len += sprintf_codec_name(len, buf, j->rec_codec);
 			len += sprintf(buf + len, "\nAEC ");
 			switch (j->aec_level) {
 			case AEC_OFF:
-- 
1.5.6.4

