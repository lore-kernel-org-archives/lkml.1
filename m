Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbZGCKPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbZGCKPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbZGCKO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:14:57 -0400
Received: from mail-bw0-f207.google.com ([209.85.218.207]:42598 "EHLO
	mail-bw0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbZGCKOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:14:55 -0400
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jul 2009 06:14:54 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=d4/j2UcrphzF5RJH4CKi2qwQiYQb5FfAcvNREkJMzmJHCLn3maPG8YBAoRa7/ekZ1n
         mdR9qxtkgBBSExpW6ZG2UIrSMarmGoryEyaJ79iOSxmIkBQX10MvmMODMGr2UotKLC75
         PFO91wgk+wu3iMYRTdp35+BUKccy8gNsSTSTI=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       forest@alittletooquiet.net
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] Staging: vt6656: remove dependency on WIRELESS_EXT version
Date: Fri,  3 Jul 2009 14:07:14 +0400
Message-Id: <1246615634-14939-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the driver is in mainline now we can remove such dependency.
WIRELESS_EXT is 22 now and it is always defined.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/vt6656/device.h   |    7 ---
 drivers/staging/vt6656/hostap.h   |    8 ---
 drivers/staging/vt6656/iwctl.c    |   84 ------------------------------------
 drivers/staging/vt6656/iwctl.h    |   86 -------------------------------------
 drivers/staging/vt6656/main_usb.c |   39 +----------------
 5 files changed, 1 insertions(+), 223 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 91e2f8f..c4f9a03 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -72,16 +72,11 @@
 #endif
 /* Include Wireless Extension definition and check version - Jean II */
 #include <linux/wireless.h>
-#if WIRELESS_EXT > 12
 #include <net/iw_handler.h>	// New driver API
-#endif	/* WIRELESS_EXT > 12 */
 
-//2008-0409-07, <Add> by Einsn Liu
-#if WIRELESS_EXT > 17
 #ifndef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 #define WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 #endif
-#endif
 
 //2007-0920-01<Add>by MikeLiu
 #ifndef SndEvt_ToAPI
@@ -910,9 +905,7 @@ typedef struct __device_info {
 #endif
     UINT                    uChannel;
 
-#ifdef WIRELESS_EXT
 	struct iw_statistics	wstats;		// wireless stats
-#endif /* WIRELESS_EXT */
     BOOL                    bCommit;
 
 } DEVICE_INFO, *PSDevice;
diff --git a/drivers/staging/vt6656/hostap.h b/drivers/staging/vt6656/hostap.h
index 1fcb2f0..c5ad349 100644
--- a/drivers/staging/vt6656/hostap.h
+++ b/drivers/staging/vt6656/hostap.h
@@ -37,14 +37,6 @@
 
 /*---------------------  Export Definitions -------------------------*/
 
-#if WIRELESS_EXT < 9
-struct iw_point {
-	caddr_t pointer;
-	__u16 length;
-	__u16 flags;
-};
-#endif /* WIRELESS_EXT < 9 */
-
 #define WLAN_RATE_1M    BIT0
 #define WLAN_RATE_2M    BIT1
 #define WLAN_RATE_5M5   BIT2
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 7b42a1a..e4fdb6f 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -68,9 +68,7 @@
 #endif
 #endif
 
-#if WIRELESS_EXT > 12
 #include <net/iw_handler.h>
-#endif
 
 
 /*---------------------  Static Definitions -------------------------*/
@@ -82,8 +80,6 @@
 #define SUPPORTED_WIRELESS_EXT                  17
 #endif
 
-#ifdef WIRELESS_EXT
-
 static const long frequency_list[] = {
     2412, 2417, 2422, 2427, 2432, 2437, 2442, 2447, 2452, 2457, 2462, 2467, 2472, 2484,
     4915, 4920, 4925, 4935, 4940, 4945, 4960, 4980,
@@ -92,8 +88,6 @@ static const long frequency_list[] = {
     5700, 5745, 5765, 5785, 5805, 5825
 	};
 
-#endif
-
 
 /*---------------------  Static Classes  ----------------------------*/
 
@@ -107,10 +101,6 @@ static int          msglevel                =MSG_LEVEL_INFO;
 
 /*---------------------  Export Variables  --------------------------*/
 
-#ifdef WIRELESS_EXT
-
-#if WIRELESS_EXT > 12
-
 struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 {
 	PSDevice pDevice = netdev_priv(dev);
@@ -157,8 +147,6 @@ struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 	return &pDevice->wstats;
 }
 
-#endif
-
 
 
 /*------------------------------------------------------------------*/
@@ -207,8 +195,6 @@ int iwctl_giwnwid(struct net_device *dev,
 	//return 0;
   return -EOPNOTSUPP;
 }
-#if WIRELESS_EXT > 13
-
 /*
  * Wireless Handler : set scan
  */
@@ -309,9 +295,7 @@ int iwctl_giwscan(struct net_device *dev,
 	char *current_val = NULL;
 	struct iw_event iwe;
 	long ldBm;
-#if WIRELESS_EXT > 14
 	char buf[MAX_WPA_IE_LEN * 2 + 30];
-#endif /* WIRELESS_EXT > 14 */
 
 //2008-0409-02, <Mark> by Einsn Liu
 /*
@@ -457,14 +441,12 @@ int iwctl_giwscan(struct net_device *dev,
 	        if((current_val - current_ev) > IW_EV_LCP_LEN)
 		        current_ev = current_val;
 
-#if WIRELESS_EXT > 14
             memset(&iwe, 0, sizeof(iwe));
             iwe.cmd = IWEVCUSTOM;
             sprintf(buf, "bcn_int=%d", pBSS->wBeaconInterval);
             iwe.u.data.length = strlen(buf);
              current_ev = iwe_stream_add_point(info,current_ev, end_buf, &iwe, buf);
 
-#if WIRELESS_EXT > 17
             if ((pBSS->wWPALen > 0) && (pBSS->wWPALen <= MAX_WPA_IE_LEN)) {
                 memset(&iwe, 0, sizeof(iwe));
                 iwe.cmd = IWEVGENIE;
@@ -479,33 +461,6 @@ int iwctl_giwscan(struct net_device *dev,
                 current_ev = iwe_stream_add_point(info,current_ev, end_buf, &iwe, pBSS->byRSNIE);
             }
 
-#else // WIRELESS_EXT > 17
-            if ((pBSS->wWPALen > 0) && (pBSS->wWPALen <= MAX_WPA_IE_LEN)) {
-                u8 *p = buf;
-                memset(&iwe, 0, sizeof(iwe));
-                iwe.cmd = IWEVCUSTOM;
-		        p += sprintf(p, "wpa_ie=");
-		        for (ii = 0; ii < pBSS->wWPALen; ii++) {
-			        p += sprintf(p, "%02x", pBSS->byWPAIE[ii]);
-		        }
-		        iwe.u.data.length = strlen(buf);
-                          current_ev = iwe_stream_add_point(info,current_ev, end_buf, &iwe, buf);
-		    }
-
-
-            if ((pBSS->wRSNLen > 0) && (pBSS->wRSNLen <= MAX_WPA_IE_LEN)) {
-                u8 *p = buf;
-                memset(&iwe, 0, sizeof(iwe));
-                iwe.cmd = IWEVCUSTOM;
-		        p += sprintf(p, "rsn_ie=");
-		        for (ii = 0; ii < pBSS->wRSNLen; ii++) {
-			        p += sprintf(p, "%02x", pBSS->byRSNIE[ii]);
-		        }
-		        iwe.u.data.length = strlen(buf);
-                          current_ev = iwe_stream_add_point(info,current_ev, end_buf, &iwe, buf);
-		    }
-#endif
-#endif
         }
     }// for
 
@@ -514,8 +469,6 @@ int iwctl_giwscan(struct net_device *dev,
 
 }
 
-#endif	/* WIRELESS_EXT > 13 */
-
 
 /*
  * Wireless Handler : set frequence or channel
@@ -772,12 +725,9 @@ int iwctl_giwrange(struct net_device *dev,
 	    // 4 keys are allowed
 	    range->max_encoding_tokens = 4;
 
-#if WIRELESS_EXT > 17
 	    range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
 		    IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
-#endif
 
-#if WIRELESS_EXT > 9
 		range->min_pmp = 0;
 		range->max_pmp = 1000000;// 1 secs
 		range->min_pmt = 0;
@@ -791,8 +741,6 @@ int iwctl_giwrange(struct net_device *dev,
         range->txpower[0] = 100;
 		range->num_txpower = 1;
 		range->txpower_capa = IW_TXPOW_MWATT;
-#endif // WIRELESS_EXT > 9
-#if WIRELESS_EXT > 10
 		range->we_version_source = SUPPORTED_WIRELESS_EXT;
 		range->we_version_compiled = WIRELESS_EXT;
 		range->retry_capa = IW_RETRY_LIMIT | IW_RETRY_LIFETIME;
@@ -802,15 +750,12 @@ int iwctl_giwrange(struct net_device *dev,
 		range->max_retry = 65535;
 		range->min_r_time = 1024;
 		range->max_r_time = 65535 * 1024;
-#endif // WIRELESS_EXT > 10
-#if WIRELESS_EXT > 11
 		// Experimental measurements - boundary 11/5.5 Mb/s
 		// Note : with or without the (local->rssi), results
 		//  are somewhat different. - Jean II
 		range->avg_qual.qual = 6;
 		range->avg_qual.level = 176;	// -80 dBm
 		range->avg_qual.noise = 0;
-#endif // WIRELESS_EXT > 11
 	}
 
 
@@ -1088,11 +1033,7 @@ int iwctl_giwessid(struct net_device *dev,
 	memcpy(extra, pItemSSID->abySSID , pItemSSID->len);
 	extra[pItemSSID->len] = '\0';
         //2008-0409-03, <Add> by Einsn Liu
-        #if WIRELESS_EXT < 21
-	wrq->length = pItemSSID->len + 1;
-        #else
         wrq->length = pItemSSID->len;
-        #endif
 	wrq->flags = 1; // active
 
 
@@ -2120,8 +2061,6 @@ int iwctl_siwmlme(struct net_device *dev,
  */
 
 
-#if WIRELESS_EXT > 12
-
 /*
 static const iw_handler		iwctl_handler[] =
 {
@@ -2149,13 +2088,8 @@ static const iw_handler		iwctl_handler[] =
 	(iw_handler) iwctl_giwap,		    // SIOCGIWAP
 	(iw_handler) NULL,				    // -- hole -- 0x16
 	(iw_handler) iwctl_giwaplist,       // SIOCGIWAPLIST
-#if WIRELESS_EXT > 13
 	(iw_handler) iwctl_siwscan,         // SIOCSIWSCAN
 	(iw_handler) iwctl_giwscan,         // SIOCGIWSCAN
-#else
-	(iw_handler) NULL,
-	(iw_handler) NULL,
-#endif
 	(iw_handler) iwctl_siwessid,		// SIOCSIWESSID
 	(iw_handler) iwctl_giwessid,		// SIOCGIWESSID
 	(iw_handler) NULL,		// SIOCSIWNICKN
@@ -2176,7 +2110,6 @@ static const iw_handler		iwctl_handler[] =
 	(iw_handler) iwctl_giwencode,		// SIOCGIWENCODE
 	(iw_handler) iwctl_siwpower,		// SIOCSIWPOWER
 	(iw_handler) iwctl_giwpower,		// SIOCGIWPOWER
-#if WIRELESS_EXT > 17
 	(iw_handler) NULL,			// -- hole --
 	(iw_handler) NULL,			// -- hole --
 	(iw_handler) iwctl_siwgenie,    // SIOCSIWGENIE
@@ -2187,7 +2120,6 @@ static const iw_handler		iwctl_handler[] =
 	(iw_handler) iwctl_giwencodeext,		// SIOCGIWENCODEEXT
 	(iw_handler) NULL,				// SIOCSIWPMKSA
 	(iw_handler) NULL,				// -- hole --
-#endif // WIRELESS_EXT > 17
 
 };
 */
@@ -2218,13 +2150,8 @@ static const iw_handler		iwctl_handler[] =
 	(iw_handler) NULL,		    // SIOCGIWAP
 	(iw_handler) NULL,				    // -- hole -- 0x16
 	(iw_handler) NULL,       // SIOCGIWAPLIST
-#if WIRELESS_EXT > 13
 	(iw_handler) iwctl_siwscan,         // SIOCSIWSCAN
 	(iw_handler) iwctl_giwscan,         // SIOCGIWSCAN
-#else
-	(iw_handler) NULL,
-	(iw_handler) NULL,
-#endif
 	(iw_handler) NULL,		// SIOCSIWESSID
 	(iw_handler) NULL,		// SIOCGIWESSID
 	(iw_handler) NULL,		// SIOCSIWNICKN
@@ -2245,8 +2172,6 @@ static const iw_handler		iwctl_handler[] =
 	(iw_handler) NULL,		// SIOCGIWENCODE
 	(iw_handler) NULL,		// SIOCSIWPOWER
 	(iw_handler) NULL,		// SIOCGIWPOWER
-//2008-0409-07, <Add> by Einsn Liu
-#if WIRELESS_EXT > 17
 	(iw_handler) NULL,			// -- hole --
 	(iw_handler) NULL,			// -- hole --
 	(iw_handler) NULL,    // SIOCSIWGENIE
@@ -2257,7 +2182,6 @@ static const iw_handler		iwctl_handler[] =
 	(iw_handler) NULL,		// SIOCGIWENCODEEXT
 	(iw_handler) NULL,				// SIOCSIWPMKSA
 	(iw_handler) NULL,				// -- hole --
-#endif // WIRELESS_EXT > 17
 };
 
 
@@ -2277,9 +2201,7 @@ struct iw_priv_args iwctl_private_args[] = {
 
 const struct iw_handler_def	iwctl_handler_def =
 {
-#if WIRELESS_EXT > 16
 	.get_wireless_stats = &iwctl_get_wireless_stats,
-#endif
 	.num_standard	= sizeof(iwctl_handler)/sizeof(iw_handler),
 //	.num_private	= sizeof(iwctl_private_handler)/sizeof(iw_handler),
 //	.num_private_args = sizeof(iwctl_private_args)/sizeof(struct iw_priv_args),
@@ -2291,9 +2213,3 @@ const struct iw_handler_def	iwctl_handler_def =
 	.private	= NULL,
 	.private_args	= NULL,
 };
-
-
-#endif // WIRELESS_EXT > 12
-
-
-#endif // WIRELESS_EXT
diff --git a/drivers/staging/vt6656/iwctl.h b/drivers/staging/vt6656/iwctl.h
index e98b0de..962235f 100644
--- a/drivers/staging/vt6656/iwctl.h
+++ b/drivers/staging/vt6656/iwctl.h
@@ -50,87 +50,6 @@ extern "C" {                            /* Assume C declarations for C++ */
 #endif /* __cplusplus */
 
 
-#if WIRELESS_EXT < 18
-
-
-#define SIOCSIWMLME	        0x8B16
-#define SIOCSIWGENIE	    0x8B30
-
-// WPA : Authentication mode parameters
-#define SIOCSIWAUTH	        0x8B32
-#define SIOCGIWAUTH	        0x8B33
-
-// WPA : Extended version of encoding configuration
-#define SIOCSIWENCODEEXT    0x8B34
-#define SIOCGIWENCODEEXT    0x8B35
-
-#define IW_AUTH_WPA_VERSION		0
-#define IW_AUTH_CIPHER_PAIRWISE		1
-#define IW_AUTH_CIPHER_GROUP		2
-#define IW_AUTH_KEY_MGMT		3
-#define IW_AUTH_TKIP_COUNTERMEASURES	4
-#define IW_AUTH_DROP_UNENCRYPTED	5
-#define IW_AUTH_80211_AUTH_ALG		6
-#define IW_AUTH_WPA_ENABLED		7
-#define IW_AUTH_RX_UNENCRYPTED_EAPOL	8
-#define IW_AUTH_ROAMING_CONTROL		9
-#define IW_AUTH_PRIVACY_INVOKED		10
-
-#define IW_AUTH_WPA_VERSION_DISABLED	0x00000001
-#define IW_AUTH_WPA_VERSION_WPA		0x00000002
-#define IW_AUTH_WPA_VERSION_WPA2	0x00000004
-
-#define IW_AUTH_CIPHER_NONE	    0x00000001
-#define IW_AUTH_CIPHER_WEP40	0x00000002
-#define IW_AUTH_CIPHER_TKIP	    0x00000004
-#define IW_AUTH_CIPHER_CCMP	    0x00000008
-#define IW_AUTH_CIPHER_WEP104	0x00000010
-
-#define IW_AUTH_KEY_MGMT_802_1X	1
-#define IW_AUTH_KEY_MGMT_PSK	2
-
-#define IW_AUTH_ALG_OPEN_SYSTEM	0x00000001
-#define IW_AUTH_ALG_SHARED_KEY	0x00000002
-#define IW_AUTH_ALG_LEAP	0x00000004
-
-#define IW_AUTH_ROAMING_ENABLE	0
-#define IW_AUTH_ROAMING_DISABLE	1
-
-#define IW_ENCODE_SEQ_MAX_SIZE	8
-
-#define IW_ENCODE_ALG_NONE	0
-#define IW_ENCODE_ALG_WEP	1
-#define IW_ENCODE_ALG_TKIP	2
-#define IW_ENCODE_ALG_CCMP	3
-
-
-struct	iw_encode_ext
-{
-	__u32		ext_flags; // IW_ENCODE_EXT_*
-	__u8		tx_seq[IW_ENCODE_SEQ_MAX_SIZE]; // LSB first
-	__u8		rx_seq[IW_ENCODE_SEQ_MAX_SIZE]; // LSB first
-	struct sockaddr	addr; // ff:ff:ff:ff:ff:ff for broadcast/multicast
-			              // (group) keys or unicast address for
-			              // individual keys
-	__u16		alg; // IW_ENCODE_ALG_*
-	__u16		key_len;
-	__u8		key[0];
-};
-
-
-struct	iw_mlme
-{
-	__u16		cmd; /* IW_MLME_* */
-	__u16		reason_code;
-	struct sockaddr	addr;
-};
-
-#endif // WIRELESS_EXT < 18
-
-
-
-#ifdef WIRELESS_EXT
-
 struct iw_statistics *iwctl_get_wireless_stats (struct net_device *dev);
 
 
@@ -308,16 +227,11 @@ int iwctl_siwmlme(struct net_device *dev,
 			struct iw_point *wrq,
 			char *extra);
 #endif // #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-#endif
 //End Add -- //2008-0409-07, <Add> by Einsn Liu
 
 
-#if WIRELESS_EXT > 12
 extern const struct iw_handler_def	iwctl_handler_def;
 extern const struct iw_priv_args	iwctl_private_args;
-#else
-struct iw_request_info {};
-#endif	//WIRELESS_EXT > 12
 
 #ifdef __cplusplus
 }                                       /* End of extern "C" { */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index f94bdff..a3600c8 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -294,7 +294,6 @@ static struct usb_device_id vntwusb_table[] = {
 
 
 
-#ifdef WIRELESS_EXT
 // Frequency list (map channels to frequencies)
 /*
 static const long frequency_list[] = {
@@ -311,15 +310,9 @@ static const long frequency_list[] = {
 #define IW_ENCODE_MODE  (IW_ENCODE_DISABLED | IW_ENCODE_RESTRICTED | IW_ENCODE_OPEN)
 #endif
 
-#if WIRELESS_EXT > 12
 static const struct iw_handler_def	iwctl_handler_def;
-#else
-struct iw_request_info {};
-#endif	//WIRELESS_EXT > 12
 */
 
-#endif /* WIRELESS_EXT */
-
 
 
 /*---------------------  Static Functions  --------------------------*/
@@ -863,14 +856,8 @@ vntwusb_found1(struct usb_interface *intf, const struct usb_device_id *id)
 
     netdev->netdev_ops         = &device_netdev_ops;
 
-#ifdef WIRELESS_EXT
-
-//2007-0508-01<Add>by MikeLiu
-
-#if WIRELESS_EXT > 12
+#ifdef CONFIG_WIRELESS_EXT
 	netdev->wireless_handlers = (struct iw_handler_def *)&iwctl_handler_def;
-//	netdev->wireless_handlers = NULL;
-#endif /* WIRELESS_EXT > 12 */
 #endif /* WIRELESS_EXT */
 
    //2008-0623-01<Remark>by MikeLiu
@@ -1752,11 +1739,8 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
     PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
     PSCmdRequest        pReq;
     //BOOL                bCommit = FALSE;
-#ifdef WIRELESS_EXT
 	struct iwreq *wrq = (struct iwreq *) rq;
 	int                 rc =0;
-#endif //WIRELESS_EXT
-
 
     if (pMgmt == NULL) {
         rc = -EFAULT;
@@ -1765,9 +1749,6 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 
     switch(cmd) {
 
-#ifdef WIRELESS_EXT
-//#if WIRELESS_EXT < 13
-
 	case SIOCGIWNAME:
 		rc = iwctl_giwname(dev, NULL, (char *)&(wrq->u.name), NULL);
 		break;
@@ -1946,7 +1927,6 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 		}
 		break;
 
-#if WIRELESS_EXT > 9
 		// Get the current Tx-Power
 	case SIOCGIWTXPOW:
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWTXPOW \n");
@@ -1958,9 +1938,6 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
         rc = -EOPNOTSUPP;
 		break;
 
-#endif // WIRELESS_EXT > 9
-
-#if WIRELESS_EXT > 10
 	case SIOCSIWRETRY:
 
 		rc = iwctl_siwretry(dev, NULL, &(wrq->u.retry), NULL);
@@ -1971,8 +1948,6 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 		rc = iwctl_giwretry(dev, NULL, &(wrq->u.retry), NULL);
 		break;
 
-#endif // WIRELESS_EXT > 10
-
 		// Get range of parameters
 	case SIOCGIWRANGE:
 
@@ -2059,8 +2034,6 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 		break;
 
 
-//#endif // WIRELESS_EXT < 13
-
 //2008-0409-07, <Add> by Einsn Liu
 #ifdef  WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 	case SIOCSIWAUTH:
@@ -2118,8 +2091,6 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 #endif // #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 //End Add -- //2008-0409-07, <Add> by Einsn Liu
 
-#endif // WIRELESS_EXT
-
     case IOCTL_CMD_TEST:
 
 		if (!(pDevice->flags & DEVICE_FLAGS_OPENED)) {
@@ -2164,11 +2135,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 		    rc = 0;
 		}
 
-#if WIRELESS_EXT > 8
 		rc = hostap_ioctl(pDevice, &wrq->u.data);
-#else // WIRELESS_EXT > 8
-		rc = hostap_ioctl(pDevice, (struct iw_point *) &wrq->u.data);
-#endif // WIRELESS_EXT > 8
         break;
 
     case IOCTL_CMD_WPA:
@@ -2180,11 +2147,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 		    rc = 0;
 		}
 
-#if WIRELESS_EXT > 8
 		rc = wpa_ioctl(pDevice, &wrq->u.data);
-#else // WIRELESS_EXT > 8
-		rc = wpa_ioctl(pDevice, (struct iw_point *) &wrq->u.data);
-#endif // WIRELESS_EXT > 8
         break;
 
 	case SIOCETHTOOL:
-- 
1.6.3.3

