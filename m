Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbYJHTlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbYJHTlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbYJHTkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:40:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:1894 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbYJHTkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:40:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Aorh+jfVgd2LWDGiLVpOfDOe3LGKzGWUVdjy8cLXon/lLVjp7/Dm7MryzmfpiCBP9k
         ZhtsNVc0Mjd2FV0lhfNVayjcVuk5g5HVUU9+b3fcgT0OewVzICg0izfc1GZL22AmKTqA
         WQSIriKV7Mn/kZMUiMw8AYEc2lZ3P69s6Rt8I=
From: "Richard A. Holden III" <aciddeath@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Richard A. Holden III" <aciddeath@gmail.com>, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 02/10] ixj: Remove dead code in preparation for consolidating duplicate code.
Date: Wed,  8 Oct 2008 14:41:37 -0600
Message-Id: <a04aa1aa0a991f7ea2b0bd9649e4197e30b14ac9.1223497216.git.aciddeath@gmail.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <b1f8a69aa47d6aab5d5a951bc78c99c26dd67658.1223497216.git.aciddeath@gmail.com>
References: <cover.1223497216.git.aciddeath@gmail.com>
 <b1f8a69aa47d6aab5d5a951bc78c99c26dd67658.1223497216.git.aciddeath@gmail.com>
In-Reply-To: <cover.1223497216.git.aciddeath@gmail.com>
References: <cover.1223497216.git.aciddeath@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commented code hasn't changed since the kernel switched to git.

Signed-off-by: Richard A. Holden III <aciddeath@gmail.com>
---
 drivers/telephony/ixj.c |   59 +---------------------------------------------
 1 files changed, 2 insertions(+), 57 deletions(-)

diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index 1b2387e..e98bac8 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -1581,7 +1581,6 @@ static int ixj_set_port(IXJ *j, int arg)
 			ixj_mixer(0x0080, j);	/* Mute Master Left volume */
 			ixj_mixer(0x0180, j);	/* Mute Master Right volume */
 			SLIC_SetState(PLD_SLIC_STATE_STANDBY, j);
-/*			SLIC_SetState(PLD_SLIC_STATE_ACTIVE, j); */
 			break;
 		case QTI_PHONEJACK:
 			j->gpio.bytes.high = 0x0B;
@@ -1968,7 +1967,7 @@ static int ixj_hookstate(IXJ *j)
 	}
 	if (j->r_hook != fOffHook) {
 		j->r_hook = fOffHook;
-		if (j->port == PORT_SPEAKER || j->port == PORT_HANDSET) { // || (j->port == PORT_PSTN && j->flags.pots_pstn == 0)) {
+		if (j->port == PORT_SPEAKER || j->port == PORT_HANDSET) {
 			j->ex.bits.hookstate = 1;
 			ixj_kill_fasync(j, SIG_HOOKSTATE, POLL_IN);
 		} else if (!fOffHook) {
@@ -2623,7 +2622,7 @@ static int LineMonitor(IXJ *j)
 		j->dtmf_state = 1;
 		j->dtmf_current = j->dtmf.bits.digit;
 	}
-	if (j->dtmf_state && !j->dtmf.bits.dtmf_valid)	/* && j->dtmf_wp != j->dtmf_rp) */
+	if (j->dtmf_state && !j->dtmf.bits.dtmf_valid)
 	 {
 		if(!j->cidcw_wait) {
 			j->dtmfbuffer[j->dtmf_wp] = j->dtmf_current;
@@ -4496,7 +4495,6 @@ static int ixj_play_start(IXJ *j)
 		printk("Write buffer allocation for ixj board %d failed!\n", j->board);
 		return -ENOMEM;
 	}
-/*	j->write_buffers_empty = 2; */
 	j->write_buffers_empty = 1; 
 	j->write_buffer_size = j->play_frame_size * 2;
 	j->write_buffer_end = j->write_buffer + j->play_frame_size * 2;
@@ -5141,7 +5139,6 @@ static int daa_set_mode(IXJ *j, int mode)
 		}
 		if (ixjdebug & 0x0008)
 			printk(KERN_INFO "phone DAA: SOP_PU_SLEEP at %ld\n", jiffies);
-/*		if(j->daa_mode == SOP_PU_CONVERSATION) */
 		{
 			j->pld_scrw.bits.daafsyncen = 0;	/* Turn off DAA Frame Sync */
 
@@ -6897,7 +6894,6 @@ static int ixj_selfprobe(IXJ *j)
 		if (ixjdebug & 0x0002)
 			printk(KERN_INFO "Configure GPIO pins\n");
 		j->gpio.bytes.high = 0x09;
-/*  bytes.low = 0xEF;  0xF7 */
 		j->gpio.bits.gpio1 = 1;
 		j->gpio.bits.gpio2 = 1;
 		j->gpio.bits.gpio3 = 0;
@@ -6949,7 +6945,6 @@ static int ixj_selfprobe(IXJ *j)
 				j->pld_slicw.bits.spken = 1;
 				outb_p(j->pld_slicw.byte, j->XILINXbase + 0x01);
 				SLIC_SetState(PLD_SLIC_STATE_STANDBY, j);
-/*				SLIC_SetState(PLD_SLIC_STATE_ACTIVE, j); */
 				j->port = PORT_POTS;
 			}
 			ixj_set_port(j, PORT_PSTN);
@@ -7016,7 +7011,6 @@ static int ixj_selfprobe(IXJ *j)
 			} else {
 				ixj_set_port(j, PORT_POTS);
 				SLIC_SetState(PLD_SLIC_STATE_STANDBY, j);
-/*				SLIC_SetState(PLD_SLIC_STATE_ACTIVE, j); */
 			}
 		}
 	}
@@ -7814,31 +7808,6 @@ static void DAA_Coeff_US(IXJ *j)
 	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[1] = 0x0F;
 	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[0] = 0x8E;
 
-	/* Bytes for Ringing part 1 (03):1B,3B,9B,BA,D4,1C,B3,23 */
-/*	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[7] = 0x1C; */
-/*	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[6] = 0xB3; */
-/*	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[5] = 0xAB; */
-/*	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[4] = 0xAB; */
-/*	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[3] = 0x54; */
-/*	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[2] = 0x2D; */
-/*	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[1] = 0x62; */
-/*	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_1[0] = 0x2D; */
-	/* Bytes for Ringing part 2 (06):13,42,A6,BA,D4,73,CA,D5 */ 
-/*	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[7] = 0x2D; */
-/*	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[6] = 0x62; */
-/*	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[5] = 0xA6; */
-/*	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[4] = 0xBB; */
-/*	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[3] = 0x2A; */
-/*	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[2] = 0x7D; */
-/*	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[1] = 0x0A; */
-/*	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[0] = 0xD4; */
-/* */
-	/* Levelmetering Ringing        (0D):B2,45,0F,8E       */
-/*	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[3] = 0xAA; */
-/*	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[2] = 0x05; */
-/*	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[1] = 0x0F; */
-/*	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[0] = 0x8E; */
-
 	/* Caller ID 1st Tone           (0E):CA,0E,CA,09,99,99,99,99 */
 	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[7] = 0xCA;
 	j->m_DAAShadowRegs.COP_REGS.COP.CallerID1stTone[6] = 0x0E;
@@ -9192,29 +9161,6 @@ static s16 tone_table[][19] =
 		 21,		/* 21/32 in-band to broad-band ratio */
 		 0x0FF5		/* shift-mask 0x0FF (look at 16 half-frames) bit count = 5 */
 	},
-#if 0
-	{			/* f425 */
-		30881,		/* A1 = -1.884827 */
-		 -32603,	/* A2 = 0.994965 */
-		 -496,		/* B2 = -0.015144 */
-		 0,		/* B1 = 0.000000 */
-		 496,		/* B0 = 0.015144 */
-		 30880,		/* A1 = -1.884766 */
-		 -32692,	/* A2 = 0.997711 */
-		 24767,		/* B2 = 0.755859 */
-		 -23290,	/* B1 = -1.421509 */
-		 24767,		/* B0 = 0.755859 */
-		 30967,		/* A1 = -1.890076 */
-		 -32694,	/* A2 = 0.997772 */
-		 728,		/* B2 = 0.022232 */
-		 -691,		/* B1 = -0.042194 */
-		 728,		/* B0 = 0.022232 */
-		 5,		/* Internal filter scaling */
-		 159,		/* Minimum in-band energy threshold */
-		 21,		/* 21/32 in-band to broad-band ratio */
-		 0x0FF5		/* shift-mask 0x0FF (look at 16 half-frames) bit count = 5 */
-	},
-#else
 	{
 		30850,
 		-32534,
@@ -9236,7 +9182,6 @@ static s16 tone_table[][19] =
 		17,
 		0xff5
 	},
-#endif
 	{			/* f425_450[] */
 		30646,		/* A1 = 1.870544 */
 		 -32327,	/* A2 = -0.986572 */
-- 
1.5.6.4

