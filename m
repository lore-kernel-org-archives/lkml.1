Return-Path: <linux-kernel-owner+w=401wt.eu-S1761991AbXJQNxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761991AbXJQNxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 09:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbXJQNx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 09:53:27 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:44879 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737AbXJQNx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 09:53:27 -0400
Message-ID: <471613D3.5090700@tiscali.nl>
Date: Wed, 17 Oct 2007 15:53:23 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] fix not-and/or errors
References: <47161243.6060007@tiscali.nl>
In-Reply-To: <47161243.6060007@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 568f9787e58b4d24be50ab2abf1c7dab12a9ef2c
Author: Roel Kluin <12o3l@tiscali.nl>
Date:   Wed Oct 17 15:16:44 2007 +0200

    if(!x & y) should either be if(!(x & y)) or if(!x && y)
    I made changes as seemed appropriate, but please review
    
    several changes to drivers/isdn/
    
    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/isdn/act2000/module.c b/drivers/isdn/act2000/module.c
index ee2b0b9..8325022 100644
--- a/drivers/isdn/act2000/module.c
+++ b/drivers/isdn/act2000/module.c
@@ -310,7 +310,7 @@ act2000_command(act2000_card * card, isdn_ctrl * c)
 			}
 			break;
 		case ISDN_CMD_DIAL:
-			if (!card->flags & ACT2000_FLAGS_RUNNING)
+			if (!(card->flags & ACT2000_FLAGS_RUNNING))
 				return -ENODEV;
 			if (!(chan = find_channel(card, c->arg & 0x0f)))
 				break;
@@ -339,7 +339,7 @@ act2000_command(act2000_card * card, isdn_ctrl * c)
 			}
 			return ret;
 		case ISDN_CMD_ACCEPTD:
-			if (!card->flags & ACT2000_FLAGS_RUNNING)
+			if (!(card->flags & ACT2000_FLAGS_RUNNING))
 				return -ENODEV;
 			if (!(chan = find_channel(card, c->arg & 0x0f)))
 				break;
@@ -347,11 +347,11 @@ act2000_command(act2000_card * card, isdn_ctrl * c)
 				actcapi_select_b2_protocol_req(card, chan);
 			return 0;
 		case ISDN_CMD_ACCEPTB:
-			if (!card->flags & ACT2000_FLAGS_RUNNING)
+			if (!(card->flags & ACT2000_FLAGS_RUNNING))
 				return -ENODEV;
 			return 0;
 		case ISDN_CMD_HANGUP:
-			if (!card->flags & ACT2000_FLAGS_RUNNING)
+			if (!(card->flags & ACT2000_FLAGS_RUNNING))
 				return -ENODEV;
 			if (!(chan = find_channel(card, c->arg & 0x0f)))
 				break;
@@ -366,7 +366,7 @@ act2000_command(act2000_card * card, isdn_ctrl * c)
 			}
 			return 0;
 		case ISDN_CMD_SETEAZ:
-			if (!card->flags & ACT2000_FLAGS_RUNNING)
+			if (!(card->flags & ACT2000_FLAGS_RUNNING))
 				return -ENODEV;
 			if (!(chan = find_channel(card, c->arg & 0x0f)))
 				break;
@@ -386,7 +386,7 @@ act2000_command(act2000_card * card, isdn_ctrl * c)
 			actcapi_listen_req(card);
 			return 0;
 		case ISDN_CMD_CLREAZ:
-			if (!card->flags & ACT2000_FLAGS_RUNNING)
+			if (!(card->flags & ACT2000_FLAGS_RUNNING))
 				return -ENODEV;
 			if (!(chan = find_channel(card, c->arg & 0x0f)))
 				break;
@@ -394,14 +394,14 @@ act2000_command(act2000_card * card, isdn_ctrl * c)
 			actcapi_listen_req(card);
 			return 0;
 		case ISDN_CMD_SETL2:
-			if (!card->flags & ACT2000_FLAGS_RUNNING)
+			if (!(card->flags & ACT2000_FLAGS_RUNNING))
 				return -ENODEV;
 			if (!(chan = find_channel(card, c->arg & 0x0f)))
 				break;
 			chan->l2prot = (c->arg >> 8);
 			return 0;
 		case ISDN_CMD_SETL3:
-			if (!card->flags & ACT2000_FLAGS_RUNNING)
+			if (!(card->flags & ACT2000_FLAGS_RUNNING))
 				return -ENODEV;
 			if ((c->arg >> 8) != ISDN_PROTO_L3_TRANS) {
 				printk(KERN_WARNING "L3 protocol unknown\n");
@@ -524,7 +524,7 @@ if_writecmd(const u_char __user *buf, int len, int id, int channel)
         act2000_card *card = act2000_findcard(id);
 
         if (card) {
-                if (!card->flags & ACT2000_FLAGS_RUNNING)
+                if (!(card->flags & ACT2000_FLAGS_RUNNING))
                         return -ENODEV;
                 return (len);
         }
@@ -539,7 +539,7 @@ if_readstatus(u_char __user * buf, int len, int id, int channel)
         act2000_card *card = act2000_findcard(id);
 	
         if (card) {
-                if (!card->flags & ACT2000_FLAGS_RUNNING)
+                if (!(card->flags & ACT2000_FLAGS_RUNNING))
                         return -ENODEV;
                 return (act2000_readstatus(buf, len, card));
         }
@@ -554,7 +554,7 @@ if_sendbuf(int id, int channel, int ack, struct sk_buff *skb)
         act2000_card *card = act2000_findcard(id);
 	
         if (card) {
-                if (!card->flags & ACT2000_FLAGS_RUNNING)
+                if (!(card->flags & ACT2000_FLAGS_RUNNING))
                         return -ENODEV;
 		return (act2000_sendbuf(card, channel, ack, skb));
         }
diff --git a/drivers/isdn/i4l/isdn_ttyfax.c b/drivers/isdn/i4l/isdn_ttyfax.c
index a943d07..2cee7ee 100644
--- a/drivers/isdn/i4l/isdn_ttyfax.c
+++ b/drivers/isdn/i4l/isdn_ttyfax.c
@@ -834,7 +834,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		char *rp = &f->resolution;
 
 		p[0] += 2;
-		if (!info->faxonline & 1)	/* not outgoing connection */
+		if (!(info->faxonline & 1))	/* not outgoing connection */
 			PARSE_ERROR1;
 
 		for (i = 0; (((*p[0] >= '0') && (*p[0] <= '9')) || (*p[0] == ',')) && (i < 4); i++) {
@@ -906,7 +906,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 			sprintf(rs, "\r\n0-2");
 			isdn_tty_at_cout(rs, info);
 		} else {
-			if ((f->phase != ISDN_FAX_PHASE_D) || (!info->faxonline & 1))
+			if ((f->phase != ISDN_FAX_PHASE_D) || (!(info->faxonline & 1)))
 				PARSE_ERROR1;
 			par = isdn_getnum(p);
 			if ((par < 0) || (par > 2))
diff --git a/drivers/isdn/icn/icn.c b/drivers/isdn/icn/icn.c
index 82d957b..bf7997a 100644
--- a/drivers/isdn/icn/icn.c
+++ b/drivers/isdn/icn/icn.c
@@ -1302,7 +1302,7 @@ icn_command(isdn_ctrl * c, icn_card * card)
 			}
 			break;
 		case ISDN_CMD_DIAL:
-			if (!card->flags & ICN_FLAGS_RUNNING)
+			if (!(card->flags & ICN_FLAGS_RUNNING))
 				return -ENODEV;
 			if (card->leased)
 				break;
@@ -1328,7 +1328,7 @@ icn_command(isdn_ctrl * c, icn_card * card)
 			}
 			break;
 		case ISDN_CMD_ACCEPTD:
-			if (!card->flags & ICN_FLAGS_RUNNING)
+			if (!(card->flags & ICN_FLAGS_RUNNING))
 				return -ENODEV;
 			if (c->arg < ICN_BCH) {
 				a = c->arg + 1;
@@ -1348,7 +1348,7 @@ icn_command(isdn_ctrl * c, icn_card * card)
 			}
 			break;
 		case ISDN_CMD_ACCEPTB:
-			if (!card->flags & ICN_FLAGS_RUNNING)
+			if (!(card->flags & ICN_FLAGS_RUNNING))
 				return -ENODEV;
 			if (c->arg < ICN_BCH) {
 				a = c->arg + 1;
@@ -1366,7 +1366,7 @@ icn_command(isdn_ctrl * c, icn_card * card)
 			}
 			break;
 		case ISDN_CMD_HANGUP:
-			if (!card->flags & ICN_FLAGS_RUNNING)
+			if (!(card->flags & ICN_FLAGS_RUNNING))
 				return -ENODEV;
 			if (c->arg < ICN_BCH) {
 				a = c->arg + 1;
@@ -1375,7 +1375,7 @@ icn_command(isdn_ctrl * c, icn_card * card)
 			}
 			break;
 		case ISDN_CMD_SETEAZ:
-			if (!card->flags & ICN_FLAGS_RUNNING)
+			if (!(card->flags & ICN_FLAGS_RUNNING))
 				return -ENODEV;
 			if (card->leased)
 				break;
@@ -1391,7 +1391,7 @@ icn_command(isdn_ctrl * c, icn_card * card)
 			}
 			break;
 		case ISDN_CMD_CLREAZ:
-			if (!card->flags & ICN_FLAGS_RUNNING)
+			if (!(card->flags & ICN_FLAGS_RUNNING))
 				return -ENODEV;
 			if (card->leased)
 				break;
@@ -1405,7 +1405,7 @@ icn_command(isdn_ctrl * c, icn_card * card)
 			}
 			break;
 		case ISDN_CMD_SETL2:
-			if (!card->flags & ICN_FLAGS_RUNNING)
+			if (!(card->flags & ICN_FLAGS_RUNNING))
 				return -ENODEV;
 			if ((c->arg & 255) < ICN_BCH) {
 				a = c->arg;
@@ -1424,7 +1424,7 @@ icn_command(isdn_ctrl * c, icn_card * card)
 			}
 			break;
 		case ISDN_CMD_SETL3:
-			if (!card->flags & ICN_FLAGS_RUNNING)
+			if (!(card->flags & ICN_FLAGS_RUNNING))
 				return -ENODEV;
 			return 0;
 		default:
@@ -1471,7 +1471,7 @@ if_writecmd(const u_char __user *buf, int len, int id, int channel)
 	icn_card *card = icn_findcard(id);
 
 	if (card) {
-		if (!card->flags & ICN_FLAGS_RUNNING)
+		if (!(card->flags & ICN_FLAGS_RUNNING))
 			return -ENODEV;
 		return (icn_writecmd(buf, len, 1, card));
 	}
@@ -1486,7 +1486,7 @@ if_readstatus(u_char __user *buf, int len, int id, int channel)
 	icn_card *card = icn_findcard(id);
 
 	if (card) {
-		if (!card->flags & ICN_FLAGS_RUNNING)
+		if (!(card->flags & ICN_FLAGS_RUNNING))
 			return -ENODEV;
 		return (icn_readstatus(buf, len, card));
 	}
@@ -1501,7 +1501,7 @@ if_sendbuf(int id, int channel, int ack, struct sk_buff *skb)
 	icn_card *card = icn_findcard(id);
 
 	if (card) {
-		if (!card->flags & ICN_FLAGS_RUNNING)
+		if (!(card->flags & ICN_FLAGS_RUNNING))
 			return -ENODEV;
 		return (icn_sendbuf(channel, ack, skb, card));
 	}
diff --git a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnloop.c
index bb92e3c..a335c85 100644
--- a/drivers/isdn/isdnloop/isdnloop.c
+++ b/drivers/isdn/isdnloop/isdnloop.c
@@ -1184,7 +1184,7 @@ isdnloop_command(isdn_ctrl * c, isdnloop_card * card)
 			}
 			break;
 		case ISDN_CMD_DIAL:
-			if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+			if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 				return -ENODEV;
 			if (card->leased)
 				break;
@@ -1210,7 +1210,7 @@ isdnloop_command(isdn_ctrl * c, isdnloop_card * card)
 			}
 			break;
 		case ISDN_CMD_ACCEPTD:
-			if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+			if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 				return -ENODEV;
 			if (c->arg < ISDNLOOP_BCH) {
 				a = c->arg + 1;
@@ -1238,7 +1238,7 @@ isdnloop_command(isdn_ctrl * c, isdnloop_card * card)
 			}
 			break;
 		case ISDN_CMD_ACCEPTB:
-			if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+			if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 				return -ENODEV;
 			if (c->arg < ISDNLOOP_BCH) {
 				a = c->arg + 1;
@@ -1264,7 +1264,7 @@ isdnloop_command(isdn_ctrl * c, isdnloop_card * card)
 				i = isdnloop_writecmd(cbuf, strlen(cbuf), 0, card);
 				break;
 		case ISDN_CMD_HANGUP:
-				if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+				if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 					return -ENODEV;
 				if (c->arg < ISDNLOOP_BCH) {
 					a = c->arg + 1;
@@ -1273,7 +1273,7 @@ isdnloop_command(isdn_ctrl * c, isdnloop_card * card)
 				}
 				break;
 		case ISDN_CMD_SETEAZ:
-				if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+				if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 					return -ENODEV;
 				if (card->leased)
 					break;
@@ -1289,7 +1289,7 @@ isdnloop_command(isdn_ctrl * c, isdnloop_card * card)
 				}
 				break;
 		case ISDN_CMD_CLREAZ:
-				if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+				if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 					return -ENODEV;
 				if (card->leased)
 					break;
@@ -1303,7 +1303,7 @@ isdnloop_command(isdn_ctrl * c, isdnloop_card * card)
 				}
 				break;
 		case ISDN_CMD_SETL2:
-				if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+				if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 					return -ENODEV;
 				if ((c->arg & 255) < ISDNLOOP_BCH) {
 					a = c->arg;
@@ -1333,7 +1333,7 @@ isdnloop_command(isdn_ctrl * c, isdnloop_card * card)
 				}
 				break;
 		case ISDN_CMD_SETL3:
-				if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+				if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 					return -ENODEV;
 				return 0;
 		default:
@@ -1380,7 +1380,7 @@ if_writecmd(const u_char __user *buf, int len, int id, int channel)
 	isdnloop_card *card = isdnloop_findcard(id);
 
 	if (card) {
-		if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+		if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 			return -ENODEV;
 		return (isdnloop_writecmd(buf, len, 1, card));
 	}
@@ -1395,7 +1395,7 @@ if_readstatus(u_char __user *buf, int len, int id, int channel)
 	isdnloop_card *card = isdnloop_findcard(id);
 
 	if (card) {
-		if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+		if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 			return -ENODEV;
 		return (isdnloop_readstatus(buf, len, card));
 	}
@@ -1410,7 +1410,7 @@ if_sendbuf(int id, int channel, int ack, struct sk_buff *skb)
 	isdnloop_card *card = isdnloop_findcard(id);
 
 	if (card) {
-		if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+		if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 			return -ENODEV;
 		/* ack request stored in skb scratch area */
 		*(skb->head) = ack;
