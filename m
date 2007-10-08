Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbXJHSlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbXJHSlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 14:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbXJHSlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 14:41:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:3408 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbXJHSk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 14:40:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=e2EPPl254fHDWD0jHl7yYhFoOMGH4Z3ZCjd1pizJI2KuS7hZa+TMFqBjcucXJvAXzSPaPVKd6XHJvkNHeeiQ5HZxcbQtLXXLBgSbfLIb0dsnvTLJF8s+CM2uJqbHVVd5fJ9xPLgDMjdGRiRhOq59ZyV0bR4rlIxNMidQAqI6s2A=
Date: Mon, 8 Oct 2007 22:40:44 +0400
To: akpm@osdl.org
Cc: yanzheng@21cn.com, linux-kernel@vger.kernel.org
Subject: Re: + fix-vm_can_nonlinear-check-in-sys_remap_file_pages.patch added to -mm tree
Message-ID: <20071008184044.GA1875@martell.zuzino.mipt.ru>
References: <200710081705.l98H5eoj009691@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710081705.l98H5eoj009691@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 10:05:40AM -0700, akpm@linux-foundation.org wrote:
> --- a/mm/fremap.c~fix-vm_can_nonlinear-check-in-sys_remap_file_pages
> +++ a/mm/fremap.c
> @@ -160,7 +160,7 @@ asmlinkage long sys_remap_file_pages(uns
>  	if (vma->vm_private_data && !(vma->vm_flags & VM_NONLINEAR))
>  		goto out;
>  
> -	if (!vma->vm_flags & VM_CAN_NONLINEAR)
> +	if (!(vma->vm_flags & VM_CAN_NONLINEAR))

Ick.

[PATCH] typo time?

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/block/paride/pt.c                    |    2 -
 drivers/block/pktcdvd.c                      |    4 +--
 drivers/isdn/act2000/module.c                |   22 ++++++++---------
 drivers/isdn/i4l/isdn_ttyfax.c               |    2 -
 drivers/isdn/icn/icn.c                       |   22 ++++++++---------
 drivers/isdn/isdnloop/isdnloop.c             |   16 ++++++------
 drivers/media/video/pvrusb2/pvrusb2-ctrl.c   |    2 -
 drivers/net/wireless/airo.c                  |    2 -
 drivers/net/wireless/atmel.c                 |    2 -
 drivers/net/wireless/prism54/isl_ioctl.c     |    4 +--
 drivers/net/wireless/zd1211rw/zd_rf_uw2453.c |    2 -
 drivers/video/i810/i810_main.c               |    2 -
 drivers/video/sis/sis_main.c                 |    2 -
 fs/ocfs2/alloc.c                             |    2 -
 net/ieee80211/ieee80211_wx.c                 |    2 -
 15 files changed, 44 insertions(+), 44 deletions(-)

--- a/drivers/block/paride/pt.c
+++ b/drivers/block/paride/pt.c
@@ -660,7 +660,7 @@ static int pt_open(struct inode *inode, struct file *file)
 	pt_identify(tape);
 
 	err = -ENODEV;
-	if (!tape->flags & PT_MEDIA)
+	if (!(tape->flags & PT_MEDIA))
 		goto out;
 
 	err = -EROFS;
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2204,11 +2204,11 @@ static int pkt_media_speed(struct pktcdvd_device *pd, unsigned *speed)
 		return ret;
 	}
 
-	if (!buf[6] & 0x40) {
+	if (!(buf[6] & 0x40)) {
 		printk(DRIVER_NAME": Disc type is not CD-RW\n");
 		return 1;
 	}
-	if (!buf[6] & 0x4) {
+	if (!(buf[6] & 0x4)) {
 		printk(DRIVER_NAME": A1 values on media are not valid, maybe not CDRW?\n");
 		return 1;
 	}
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
--- a/drivers/isdn/i4l/isdn_ttyfax.c
+++ b/drivers/isdn/i4l/isdn_ttyfax.c
@@ -834,7 +834,7 @@ isdn_tty_cmd_FCLASS2(char **p, modem_info * info)
 		char *rp = &f->resolution;
 
 		p[0] += 2;
-		if (!info->faxonline & 1)	/* not outgoing connection */
+		if (!(info->faxonline & 1))	/* not outgoing connection */
 			PARSE_ERROR1;
 
 		for (i = 0; (((*p[0] >= '0') && (*p[0] <= '9')) || (*p[0] == ',')) && (i < 4); i++) {
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
@@ -1303,7 +1303,7 @@ isdnloop_command(isdn_ctrl * c, isdnloop_card * card)
 				}
 				break;
 		case ISDN_CMD_SETL2:
-				if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+				if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 					return -ENODEV;
 				if ((c->arg & 255) < ISDNLOOP_BCH) {
 					a = c->arg;
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
--- a/drivers/media/video/pvrusb2/pvrusb2-ctrl.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-ctrl.c
@@ -410,7 +410,7 @@ static int parse_mtoken(const char *ptr,unsigned int len,
 	int msk;
 	*valptr = 0;
 	for (idx = 0, msk = 1; valid_bits; idx++, msk <<= 1) {
-		if (!msk & valid_bits) continue;
+		if (!(msk & valid_bits)) continue;
 		valid_bits &= ~msk;
 		if (!names[idx]) continue;
 		slen = strlen(names[idx]);
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -6417,7 +6417,7 @@ static int airo_set_encode(struct net_device *dev,
 			set_wep_key(local, index, NULL, 0, perm, 1);
 		} else
 			/* Don't complain if only change the mode */
-			if(!dwrq->flags & IW_ENCODE_MODE) {
+			if(!(dwrq->flags & IW_ENCODE_MODE)) {
 				return -EINVAL;
 			}
 	}
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -1761,7 +1761,7 @@ static int atmel_set_encode(struct net_device *dev,
 			priv->default_key = index;
 		} else
 			/* Don't complain if only change the mode */
-			if (!dwrq->flags & IW_ENCODE_MODE) {
+			if (!(dwrq->flags & IW_ENCODE_MODE)) {
 				return -EINVAL;
 			}
 	}
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -1118,7 +1118,7 @@ prism54_set_encode(struct net_device *ndev, struct iw_request_info *info,
 			    mgt_set_request(priv, DOT11_OID_DEFKEYID, 0,
 					    &index);
 		} else {
-			if (!dwrq->flags & IW_ENCODE_MODE) {
+			if (!(dwrq->flags & IW_ENCODE_MODE)) {
 				/* we cannot do anything. Complain. */
 				return -EINVAL;
 			}
@@ -2630,7 +2630,7 @@ prism2_ioctl_set_encryption(struct net_device *dev,
 			    mgt_set_request(priv, DOT11_OID_DEFKEYID, 0,
 					    &index);
 		} else {
-			if (!param->u.crypt.flags & IW_ENCODE_MODE) {
+			if (!(param->u.crypt.flags & IW_ENCODE_MODE)) {
 				/* we cannot do anything. Complain. */
 				return -EINVAL;
 			}
--- a/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c
@@ -403,7 +403,7 @@ static int uw2453_init_hw(struct zd_rf *rf)
 		if (r)
 			return r;
 
-		if (!intr_status & 0xf) {
+		if (!(intr_status & 0xf)) {
 			dev_dbg_f(zd_chip_dev(chip),
 				"PLL locked on configuration %d\n", i);
 			found_config = i;
--- a/drivers/video/i810/i810_main.c
+++ b/drivers/video/i810/i810_main.c
@@ -1476,7 +1476,7 @@ static int i810fb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 	struct i810fb_par *par = info->par;
 	u8 __iomem *mmio = par->mmio_start_virtual;
 
-	if (!par->dev_flags & LOCKUP)
+	if (!(par->dev_flags & LOCKUP))
 		return -ENXIO;
 
 	if (cursor->image.width > 64 || cursor->image.height > 64)
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -427,7 +427,7 @@ sisfb_interpret_edid(struct sisfb_monitor *monitor, u8 *buffer)
 
 	monitor->feature = buffer[0x18];
 
-	if(!buffer[0x14] & 0x80) {
+	if(!(buffer[0x14] & 0x80)) {
 		if(!(buffer[0x14] & 0x08)) {
 			printk(KERN_INFO
 				"sisfb: WARNING: Monitor does not support separate syncs\n");
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3961,7 +3961,7 @@ static int __ocfs2_mark_extent_written(struct inode *inode,
 	struct ocfs2_merge_ctxt ctxt;
 	struct ocfs2_extent_list *rightmost_el;
 
-	if (!rec->e_flags & OCFS2_EXT_UNWRITTEN) {
+	if (!(rec->e_flags & OCFS2_EXT_UNWRITTEN)) {
 		ret = -EIO;
 		mlog_errno(ret);
 		goto out;
--- a/net/ieee80211/ieee80211_wx.c
+++ b/net/ieee80211/ieee80211_wx.c
@@ -708,7 +708,7 @@ int ieee80211_wx_get_encodeext(struct ieee80211_device *ieee,
 	} else
 		idx = ieee->tx_keyidx;
 
-	if (!ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY &&
+	if (!(ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) &&
 	    ext->alg != IW_ENCODE_ALG_WEP)
 		if (idx != 0 || ieee->iw_mode != IW_MODE_INFRA)
 			return -EINVAL;
