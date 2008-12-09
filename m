Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbYLISuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbYLISuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 13:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbYLISuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 13:50:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:54345 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbYLISuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 13:50:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jDuxFOeSSJv4lpPjziCYNEGgn5J/wPdu7huhl0MQ4y61B6fs/x/5PacjxI9nVqZq5D
         JJZ+aFsbuqwdp+FjHcd8ZYUj6IslQZEmWLJ+5tx9rNbkEp9IxMMhjQHhkl5ZohVh8bOr
         u8LpoCCbU/J62wXvyoXkfI3d+fOvY/WjhoKlA=
Message-ID: <493EBDEC.8000202@gmail.com>
Date: Tue, 09 Dec 2008 19:50:20 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: kkeil@suse.de, mac@melware.de
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/33] isdn: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/isdn/hardware/eicon/di.c       |    4 +-
 drivers/isdn/hardware/eicon/message.c  |   67 ++++++++++++++++---------------
 drivers/isdn/hardware/mISDN/hfcmulti.c |   27 ++++--------
 drivers/isdn/mISDN/core.c              |    7 +--
 drivers/isdn/mISDN/dsp_audio.c         |    2 +-
 drivers/isdn/mISDN/dsp_cmx.c           |    6 +-
 drivers/isdn/mISDN/dsp_core.c          |    2 +-
 drivers/isdn/mISDN/stack.c             |    3 +-
 8 files changed, 55 insertions(+), 63 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/di.c b/drivers/isdn/hardware/eicon/di.c
index 10760b3..cfee4f2 100644
--- a/drivers/isdn/hardware/eicon/di.c
+++ b/drivers/isdn/hardware/eicon/di.c
@@ -353,7 +353,7 @@ void scom_clear_int(ADAPTER * a)
 /*------------------------------------------------------------------*/
 /* return code handler                                              */
 /*------------------------------------------------------------------*/
-byte isdn_rc(ADAPTER * a,
+static byte isdn_rc(ADAPTER *a,
              byte Rc,
              byte Id,
              byte Ch,
@@ -555,7 +555,7 @@ byte isdn_rc(ADAPTER * a,
 /*------------------------------------------------------------------*/
 /* indication handler                                               */
 /*------------------------------------------------------------------*/
-byte isdn_ind(ADAPTER * a,
+static byte isdn_ind(ADAPTER *a,
               byte Ind,
               byte Id,
               byte Ch,
diff --git a/drivers/isdn/hardware/eicon/message.c b/drivers/isdn/hardware/eicon/message.c
index 599fed8..8977fb5 100644
--- a/drivers/isdn/hardware/eicon/message.c
+++ b/drivers/isdn/hardware/eicon/message.c
@@ -592,7 +592,8 @@ word api_put(APPL   * appl, CAPI_MSG   * msg)
 /* api_parse function, check the format of api messages             */
 /*------------------------------------------------------------------*/
 
-word api_parse(byte   * msg, word length, byte * format, API_PARSE * parms)
+static word api_parse(byte *msg, word length, byte *format,
+		API_PARSE *parms)
 {
   word i;
   word p;
@@ -631,7 +632,7 @@ word api_parse(byte   * msg, word length, byte * format, API_PARSE * parms)
   return false;
 }
 
-void api_save_msg(API_PARSE   *in, byte *format, API_SAVE   *out)
+static void api_save_msg(API_PARSE   *in, byte *format, API_SAVE   *out)
 {
   word i, j, n = 0;
   byte   *p;
@@ -663,7 +664,7 @@ void api_save_msg(API_PARSE   *in, byte *format, API_SAVE   *out)
   out->parms[i].length = 0;
 }
 
-void api_load_msg(API_SAVE   *in, API_PARSE   *out)
+static void api_load_msg(API_SAVE   *in, API_PARSE   *out)
 {
   word i;
 
@@ -3414,7 +3415,8 @@ byte select_b_req(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plci,
   return false;
 }
 
-byte manufacturer_req(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plci, APPL   * appl, API_PARSE * parms)
+static byte manufacturer_req(dword Id, word Number, DIVA_CAPI_ADAPTER *a,
+		PLCI *plci, APPL *appl, API_PARSE *parms)
 {
   word command;
   word i;
@@ -3741,8 +3743,8 @@ byte manufacturer_req(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * p
   return false;
 }
 
-
-byte manufacturer_res(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plci, APPL   * appl, API_PARSE * msg)
+static byte manufacturer_res(dword Id, word Number, DIVA_CAPI_ADAPTER *a,
+		PLCI *plci, APPL *appl, API_PARSE *msg)
 {
   word indication;
 
@@ -4073,8 +4075,8 @@ capi_callback_suffix:
   send_req(plci);
 }
 
-
-void control_rc(PLCI   * plci, byte req, byte rc, byte ch, byte global_req, byte nl_rc)
+static void control_rc(PLCI *plci, byte req, byte rc, byte ch, byte global_req,
+		byte nl_rc)
 {
   dword Id;
   dword rId;
@@ -4740,7 +4742,7 @@ void control_rc(PLCI   * plci, byte req, byte rc, byte ch, byte global_req, byte
   }
 }
 
-void data_rc(PLCI   * plci, byte ch)
+static void data_rc(PLCI *plci, byte ch)
 {
   dword Id;
   DIVA_CAPI_ADAPTER   * a;
@@ -4776,7 +4778,7 @@ void data_rc(PLCI   * plci, byte ch)
   }
 }
 
-void data_ack(PLCI   * plci, byte ch)
+static void data_ack(PLCI *plci, byte ch)
 {
   dword Id;
   DIVA_CAPI_ADAPTER   * a;
@@ -4802,7 +4804,7 @@ void data_ack(PLCI   * plci, byte ch)
   }
 }
 
-void sig_ind(PLCI   * plci)
+static void sig_ind(PLCI *plci)
 {
   dword x_Id;
   dword Id;
@@ -6169,8 +6171,7 @@ static void SendSetupInfo(APPL   * appl, PLCI   * plci, dword Id, byte   * * par
   }
 }
 
-
-void SendInfo(PLCI   * plci, dword Id, byte   * * parms, byte iesent)
+static void SendInfo(PLCI *plci, dword Id, byte **parms, byte iesent)
 {
   word i;
   word j;
@@ -6345,8 +6346,8 @@ void SendInfo(PLCI   * plci, dword Id, byte   * * parms, byte iesent)
   }
 }
 
-
-byte SendMultiIE(PLCI   * plci, dword Id, byte   * * parms, byte ie_type, dword info_mask, byte setupParse)
+static byte SendMultiIE(PLCI *plci, dword Id, byte **parms, byte ie_type,
+		dword info_mask, byte setupParse)
 {
   word i;
   word j;
@@ -6465,7 +6466,7 @@ static void SendSSExtInd(APPL   * appl, PLCI   * plci, dword Id, byte   * * parm
     }
 };
 
-void nl_ind(PLCI   * plci)
+static void nl_ind(PLCI *plci)
 {
   byte ch;
   word ncci;
@@ -7247,7 +7248,7 @@ void nl_ind(PLCI   * plci)
 /* find a free PLCI                                                 */
 /*------------------------------------------------------------------*/
 
-word get_plci(DIVA_CAPI_ADAPTER   * a)
+static word get_plci(DIVA_CAPI_ADAPTER *a)
 {
   word i,j;
   PLCI   * plci;
@@ -7406,7 +7407,7 @@ static void add_ie(PLCI   * plci, byte code, byte   * p, word p_length)
 /* put a unstructured data into the buffer                          */
 /*------------------------------------------------------------------*/
 
-void add_d(PLCI   * plci, word length, byte   * p)
+static void add_d(PLCI *plci, word length, byte *p)
 {
   word i;
 
@@ -7424,7 +7425,7 @@ void add_d(PLCI   * plci, word length, byte   * p)
 /* parameter buffer                                                 */
 /*------------------------------------------------------------------*/
 
-void add_ai(PLCI   * plci, API_PARSE * ai)
+static void add_ai(PLCI *plci, API_PARSE *ai)
 {
   word i;
     API_PARSE ai_parms[5];
@@ -7445,7 +7446,8 @@ void add_ai(PLCI   * plci, API_PARSE * ai)
 /* put parameter for b1 protocol in the parameter buffer            */
 /*------------------------------------------------------------------*/
 
-word add_b1(PLCI   * plci, API_PARSE * bp, word b_channel_info, word b1_facilities)
+static word add_b1(PLCI *plci, API_PARSE *bp, word b_channel_info,
+		word b1_facilities)
 {
     API_PARSE bp_parms[8];
     API_PARSE mdm_cfg[9];
@@ -7909,7 +7911,7 @@ word add_b1(PLCI   * plci, API_PARSE * bp, word b_channel_info, word b1_faciliti
 /* put parameter for b2 and B3  protocol in the parameter buffer    */
 /*------------------------------------------------------------------*/
 
-word add_b23(PLCI   * plci, API_PARSE * bp)
+static word add_b23(PLCI *plci, API_PARSE *bp)
 {
   word i, fax_control_bits;
   byte pos, len;
@@ -8706,7 +8708,7 @@ void sig_req(PLCI   * plci, byte req, byte Id)
 /* send a request for the network layer entity                      */
 /*------------------------------------------------------------------*/
 
-void nl_req_ncci(PLCI   * plci, byte req, byte ncci)
+static void nl_req_ncci(PLCI *plci, byte req, byte ncci)
 {
   if(!plci) return;
   if(plci->adapter->adapter_disabled) return;
@@ -8728,7 +8730,7 @@ void nl_req_ncci(PLCI   * plci, byte req, byte ncci)
   plci->req_in_start = plci->req_in;
 }
 
-void send_req(PLCI   * plci)
+static void send_req(PLCI *plci)
 {
   ENTITY   * e;
   word l;
@@ -8863,7 +8865,7 @@ void send_data(PLCI   * plci)
   }
 }
 
-void listen_check(DIVA_CAPI_ADAPTER   * a)
+static void listen_check(DIVA_CAPI_ADAPTER *a)
 {
   word i,j;
   PLCI   * plci;
@@ -8906,7 +8908,8 @@ void listen_check(DIVA_CAPI_ADAPTER   * a)
 /* functions for all parameters sent in INDs                        */
 /*------------------------------------------------------------------*/
 
-void IndParse(PLCI   * plci, word * parms_id, byte   ** parms, byte multiIEsize)
+static void IndParse(PLCI *plci, word *parms_id, byte **parms,
+		byte multiIEsize)
 {
   word ploc;            /* points to current location within packet */
   byte w;
@@ -8991,7 +8994,7 @@ void IndParse(PLCI   * plci, word * parms_id, byte   ** parms, byte multiIEsize)
 /* try to match a cip from received BC and HLC                      */
 /*------------------------------------------------------------------*/
 
-byte ie_compare(byte   * ie1, byte * ie2)
+static byte ie_compare(byte *ie1, byte *ie2)
 {
   word i;
   if(!ie1 || ! ie2) return false;
@@ -9000,7 +9003,7 @@ byte ie_compare(byte   * ie1, byte * ie2)
   return true;
 }
 
-word find_cip(DIVA_CAPI_ADAPTER   * a, byte   * bc, byte   * hlc)
+static word find_cip(DIVA_CAPI_ADAPTER *a, byte *bc, byte *hlc)
 {
   word i;
   word j;
@@ -9068,7 +9071,7 @@ static byte AddInfo(byte   **add_i,
 /* voice and codec features                                         */
 /*------------------------------------------------------------------*/
 
-void SetVoiceChannel(PLCI   *plci, byte   *chi, DIVA_CAPI_ADAPTER   * a)
+static void SetVoiceChannel(PLCI *plci, byte *chi, DIVA_CAPI_ADAPTER *a)
 {
   byte voice_chi[] = "\x02\x18\x01";
   byte channel;
@@ -9086,7 +9089,7 @@ void SetVoiceChannel(PLCI   *plci, byte   *chi, DIVA_CAPI_ADAPTER   * a)
   }
 }
 
-void VoiceChannelOff(PLCI   *plci)
+static void VoiceChannelOff(PLCI   *plci)
 {
   dbug(1,dprintf("ExtDevOFF"));
   add_p(plci,FTY,"\x02\x01\x08");             /* B Off */
@@ -9098,8 +9101,8 @@ void VoiceChannelOff(PLCI   *plci)
   }
 }
 
-
-word AdvCodecSupport(DIVA_CAPI_ADAPTER   *a, PLCI   *plci, APPL   *appl, byte hook_listen)
+static word AdvCodecSupport(DIVA_CAPI_ADAPTER *a, PLCI *plci, APPL *appl,
+		byte hook_listen)
 {
   word j;
   PLCI   *splci;
@@ -9195,7 +9198,7 @@ word AdvCodecSupport(DIVA_CAPI_ADAPTER   *a, PLCI   *plci, APPL   *appl, byte ho
 }
 
 
-void CodecIdCheck(DIVA_CAPI_ADAPTER   *a, PLCI   *plci)
+static void CodecIdCheck(DIVA_CAPI_ADAPTER   *a, PLCI   *plci)
 {
 
   dbug(1,dprintf("CodecIdCheck"));
diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 1eac03f..266eac1 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -171,7 +171,7 @@ static int (*unregister_interrupt)(void);
 static int interrupt_registered;
 
 static struct hfc_multi *syncmaster;
-int plxsd_master; /* if we have a master card (yet) */
+static int plxsd_master; /* if we have a master card (yet) */
 static spinlock_t plx_lock; /* may not acquire other lock inside */
 EXPORT_SYMBOL(plx_lock);
 
@@ -422,8 +422,7 @@ HFC_wait_debug(struct hfc_multi *hc, const char *function, int line)
 #endif
 
 /* write fifo data (REGIO) */
-void
-write_fifo_regio(struct hfc_multi *hc, u_char *data, int len)
+static void write_fifo_regio(struct hfc_multi *hc, u_char *data, int len)
 {
 	outb(A_FIFO_DATA0, (hc->pci_iobase)+4);
 	while (len>>2) {
@@ -443,8 +442,7 @@ write_fifo_regio(struct hfc_multi *hc, u_char *data, int len)
 	}
 }
 /* write fifo data (PCIMEM) */
-void
-write_fifo_pcimem(struct hfc_multi *hc, u_char *data, int len)
+static void write_fifo_pcimem(struct hfc_multi *hc, u_char *data, int len)
 {
 	while (len>>2) {
 		writel(cpu_to_le32(*(u32 *)data),
@@ -465,8 +463,7 @@ write_fifo_pcimem(struct hfc_multi *hc, u_char *data, int len)
 	}
 }
 /* read fifo data (REGIO) */
-void
-read_fifo_regio(struct hfc_multi *hc, u_char *data, int len)
+static void read_fifo_regio(struct hfc_multi *hc, u_char *data, int len)
 {
 	outb(A_FIFO_DATA0, (hc->pci_iobase)+4);
 	while (len>>2) {
@@ -487,8 +484,7 @@ read_fifo_regio(struct hfc_multi *hc, u_char *data, int len)
 }
 
 /* read fifo data (PCIMEM) */
-void
-read_fifo_pcimem(struct hfc_multi *hc, u_char *data, int len)
+static void read_fifo_pcimem(struct hfc_multi *hc, u_char *data, int len)
 {
 	while (len>>2) {
 		*(u32 *)data =
@@ -705,9 +701,7 @@ vpm_out(struct hfc_multi *c, int which, unsigned short addr,
 
 }
 
-
-void
-vpm_init(struct hfc_multi *wc)
+void static vpm_init(struct hfc_multi *wc)
 {
 	unsigned char reg;
 	unsigned int mask;
@@ -789,8 +783,7 @@ vpm_init(struct hfc_multi *wc)
 	}
 }
 
-void
-vpm_check(struct hfc_multi *hctmp)
+void static vpm_check(struct hfc_multi *hctmp)
 {
 	unsigned char gpi2;
 
@@ -812,8 +805,7 @@ vpm_check(struct hfc_multi *hctmp)
  *
  */
 
-void
-vpm_echocan_on(struct hfc_multi *hc, int ch, int taps)
+void static vpm_echocan_on(struct hfc_multi *hc, int ch, int taps)
 {
 	unsigned int timeslot;
 	unsigned int unit;
@@ -844,8 +836,7 @@ vpm_echocan_on(struct hfc_multi *hc, int ch, int taps)
 	vpm_out(hc, unit, timeslot, 0x7e);
 }
 
-void
-vpm_echocan_off(struct hfc_multi *hc, int ch)
+void static vpm_echocan_off(struct hfc_multi *hc, int ch)
 {
 	unsigned int timeslot;
 	unsigned int unit;
diff --git a/drivers/isdn/mISDN/core.c b/drivers/isdn/mISDN/core.c
index 3306817..03ea96f 100644
--- a/drivers/isdn/mISDN/core.c
+++ b/drivers/isdn/mISDN/core.c
@@ -31,7 +31,7 @@ static u64		device_ids;
 #define MAX_DEVICE_ID	63
 
 static LIST_HEAD(Bprotocols);
-DEFINE_RWLOCK(bp_lock);
+static DEFINE_RWLOCK(bp_lock);
 
 struct mISDNdevice
 *get_mdevice(u_int id)
@@ -192,8 +192,7 @@ mISDN_unregister_Bprotocol(struct Bprotocol *bp)
 }
 EXPORT_SYMBOL(mISDN_unregister_Bprotocol);
 
-int
-mISDNInit(void)
+static int mISDNInit(void)
 {
 	int	err;
 
@@ -224,7 +223,7 @@ error:
 	return err;
 }
 
-void mISDN_cleanup(void)
+static void mISDN_cleanup(void)
 {
 	misdn_sock_cleanup();
 	mISDN_timer_cleanup();
diff --git a/drivers/isdn/mISDN/dsp_audio.c b/drivers/isdn/mISDN/dsp_audio.c
index 1c2dd56..de3795e 100644
--- a/drivers/isdn/mISDN/dsp_audio.c
+++ b/drivers/isdn/mISDN/dsp_audio.c
@@ -30,7 +30,7 @@ EXPORT_SYMBOL(dsp_audio_s16_to_law);
 /* alaw -> ulaw */
 u8 dsp_audio_alaw_to_ulaw[256];
 /* ulaw -> alaw */
-u8 dsp_audio_ulaw_to_alaw[256];
+static u8 dsp_audio_ulaw_to_alaw[256];
 u8 dsp_silence;
 
 
diff --git a/drivers/isdn/mISDN/dsp_cmx.c b/drivers/isdn/mISDN/dsp_cmx.c
index c2f51cc..2db0098 100644
--- a/drivers/isdn/mISDN/dsp_cmx.c
+++ b/drivers/isdn/mISDN/dsp_cmx.c
@@ -1540,11 +1540,11 @@ send_packet:
 	schedule_work(&dsp->workq);
 }
 
-u32	samplecount;
+static u32	samplecount;
 struct timer_list dsp_spl_tl;
 u32	dsp_spl_jiffies; /* calculate the next time to fire */
-u32	dsp_start_jiffies; /* jiffies at the time, the calculation begins */
-struct timeval dsp_start_tv; /* time at start of calculation */
+static u32 dsp_start_jiffies; /* jiffies at the time, the calculation begins */
+static struct timeval dsp_start_tv; /* time at start of calculation */
 
 void
 dsp_cmx_send(void *arg)
diff --git a/drivers/isdn/mISDN/dsp_core.c b/drivers/isdn/mISDN/dsp_core.c
index 2f10ed8..41af063 100644
--- a/drivers/isdn/mISDN/dsp_core.c
+++ b/drivers/isdn/mISDN/dsp_core.c
@@ -161,7 +161,7 @@
 #include "core.h"
 #include "dsp.h"
 
-const char *mISDN_dsp_revision = "2.0";
+static const char *mISDN_dsp_revision = "2.0";
 
 static int debug;
 static int options;
diff --git a/drivers/isdn/mISDN/stack.c b/drivers/isdn/mISDN/stack.c
index 54cfddc..5adee7f 100644
--- a/drivers/isdn/mISDN/stack.c
+++ b/drivers/isdn/mISDN/stack.c
@@ -36,8 +36,7 @@ _queue_message(struct mISDNstack *st, struct sk_buff *skb)
 	}
 }
 
-int
-mISDN_queue_message(struct mISDNchannel *ch, struct sk_buff *skb)
+int static mISDN_queue_message(struct mISDNchannel *ch, struct sk_buff *skb)
 {
 	_queue_message(ch->st, skb);
 	return 0;

