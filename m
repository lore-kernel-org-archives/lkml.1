Return-Path: <linux-kernel-owner+w=401wt.eu-S1757881AbZF1REK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881AbZF1REK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 13:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbZF1RDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 13:03:13 -0400
Received: from storm.alittletooquiet.net ([67.23.28.199]:60055 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbZF1RDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 13:03:10 -0400
Date: Sun, 28 Jun 2009 13:03:13 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Greg KH <greg@kroah.com>, Larry Finger <Larry.Finger@lwfinger.net>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Woody Suwalski <woodys@xandros.com>,
       =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
       Harald Welte <HaraldWelte@viatech.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/8] vt6656: Replace net_device->priv accesses with
	netdev_priv calls.
Message-ID: <20090628170313.GH9143@alittletooquiet.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mln0rGgUGuXEqmuI"
Content-Disposition: inline
In-Reply-To: <200906281759.46152.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mln0rGgUGuXEqmuI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Greg: This patch series does not differ from that which you already have.]

vt6656: Replace net_device->priv accesses with netdev_priv calls.

Signed-off-by: Forest Bond <forest@alittletooquiet.net>
---
 drivers/staging/vt6656/hostap.c   |    4 ++-
 drivers/staging/vt6656/iwctl.c    |   66 ++++++++++++++++++---------------=
---
 drivers/staging/vt6656/main_usb.c |   28 +++++++---------
 drivers/staging/vt6656/wpactl.c   |    6 ++-
 4 files changed, 52 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hosta=
p.c
index 78312f8..b6ca36a 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -103,6 +103,7 @@ static int          msglevel                =3DMSG_LEVE=
L_INFO;
=20
 static int hostap_enable_hostapd(PSDevice pDevice, int rtnl_locked)
 {
+    PSDevice apdev_priv;
 	struct net_device *dev =3D pDevice->dev;
 	int ret;
=20
@@ -113,7 +114,8 @@ static int hostap_enable_hostapd(PSDevice pDevice, int =
rtnl_locked)
 		return -ENOMEM;
 	memset(pDevice->apdev, 0, sizeof(struct net_device));
=20
-	pDevice->apdev->priv =3D pDevice;
+    apdev_priv =3D netdev_priv(pDevice->apdev);
+    *apdev_priv =3D *pDevice;
 	memcpy(pDevice->apdev->dev_addr, dev->dev_addr, ETH_ALEN);
 	pDevice->apdev->hard_start_xmit =3D pDevice->tx_80211;
 	pDevice->apdev->type =3D ARPHRD_IEEE80211;
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index a2ca0e1..e6f8c18 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -113,7 +113,7 @@ static int          msglevel                =3DMSG_LEVE=
L_INFO;
=20
 struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 {
-	PSDevice pDevice =3D dev->priv;
+	PSDevice pDevice =3D netdev_priv(dev);
 	long ldBm;
=20
 	pDevice->wstats.status =3D pDevice->eOPMode;
@@ -172,7 +172,7 @@ static int iwctl_commit(struct net_device *dev,
 //2008-0409-02, <Mark> by Einsn Liu
 /*
 #ifdef Safe_Close
-  PSDevice	        pDevice =3D (PSDevice)dev->priv;
+  PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
   if (!(pDevice->flags & DEVICE_FLAGS_OPENED))
         return -EINVAL;
 #endif
@@ -218,7 +218,7 @@ int iwctl_siwscan(struct net_device *dev,
 			 struct iw_point *wrq,
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
 	 PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);
 	struct iw_scan_req  *req =3D (struct iw_scan_req *)extra;
 	BYTE                abyScanSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
@@ -299,7 +299,7 @@ int iwctl_giwscan(struct net_device *dev,
              char *extra)
 {
     int ii, jj, kk;
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);
     PKnownBSS           pBSS;
     PWLAN_IE_SSID       pItemSSID;
@@ -582,7 +582,7 @@ int iwctl_siwfreq(struct net_device *dev,
              struct iw_freq *wrq,
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
 	int rc =3D 0;
=20
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWFREQ \n");
@@ -625,7 +625,7 @@ int iwctl_giwfreq(struct net_device *dev,
              struct iw_freq *wrq,
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);
=20
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFREQ \n");
@@ -655,7 +655,7 @@ int iwctl_siwmode(struct net_device *dev,
              __u32 *wmode,
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);
     int rc =3D 0;
=20
@@ -722,7 +722,7 @@ int iwctl_giwmode(struct net_device *dev,
              __u32 *wmode,
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);
=20
=20
@@ -764,7 +764,7 @@ int iwctl_giwrange(struct net_device *dev,
 //2008-0409-02, <Mark> by Einsn Liu
 /*
  #ifdef Safe_Close
-  PSDevice	        pDevice =3D (PSDevice)dev->priv;
+  PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
   if (!(pDevice->flags & DEVICE_FLAGS_OPENED))
         return -EINVAL;
 #endif
@@ -883,7 +883,7 @@ int iwctl_siwap(struct net_device *dev,
 			 struct sockaddr *wrq,
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);
     int rc =3D 0;
     BYTE                 ZeroBSSID[WLAN_BSSID_LEN]=3D{0x00,0x00,0x00,0x00,=
0x00,0x00};
@@ -934,7 +934,7 @@ int iwctl_giwap(struct net_device *dev,
 			 struct sockaddr *wrq,
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);
=20
=20
@@ -970,7 +970,7 @@ int iwctl_giwaplist(struct net_device *dev,
 	int ii,jj, rc =3D 0;
 	struct sockaddr sock[IW_MAX_AP];
 	struct iw_quality qual[IW_MAX_AP];
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);
=20
=20
@@ -1019,7 +1019,7 @@ int iwctl_siwessid(struct net_device *dev,
              struct iw_point *wrq,
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);
     PWLAN_IE_SSID       pItemSSID;
=20
@@ -1129,7 +1129,7 @@ int iwctl_giwessid(struct net_device *dev,
              char *extra)
 {
=20
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);
 	PWLAN_IE_SSID       pItemSSID;
=20
@@ -1164,7 +1164,7 @@ int iwctl_siwrate(struct net_device *dev,
 			 struct iw_param *wrq,
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     int rc =3D 0;
 	u8	brate =3D 0;
 	int	i;
@@ -1246,7 +1246,7 @@ int iwctl_giwrate(struct net_device *dev,
              struct iw_param *wrq,
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);
=20
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRATE \n");
@@ -1295,7 +1295,7 @@ int iwctl_siwrts(struct net_device *dev,
 			 struct iw_param *wrq,
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
 	int rc =3D 0;
=20
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRTS \n");
@@ -1323,7 +1323,7 @@ int iwctl_giwrts(struct net_device *dev,
 			 struct iw_param *wrq,
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
=20
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRTS \n");
 	wrq->value =3D pDevice->wRTSThreshold;
@@ -1342,7 +1342,7 @@ int iwctl_siwfrag(struct net_device *dev,
 			 struct iw_param *wrq,
              char *extra)
 {
-    PSDevice	        pDevice =3D (PSDevice)dev->priv;
+    PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     int rc =3D 0;
     int fthr =3D wrq->value;
=20
@@ -1371,7 +1371,7 @@ int iwctl_giwfrag(struct net_device *dev,
 			 struct iw_param *wrq,
              char *extra)
 {
-    PSDevice	        pDevice =3D (PSDevice)dev->priv;
+    PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
=20
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFRAG \n");
 	wrq->value =3D pDevice->wFragmentationThreshold;
@@ -1391,7 +1391,7 @@ int iwctl_siwretry(struct net_device *dev,
 			 struct iw_param *wrq,
              char *extra)
 {
-    PSDevice	        pDevice =3D (PSDevice)dev->priv;
+    PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     int rc =3D 0;
=20
=20
@@ -1429,7 +1429,7 @@ int iwctl_giwretry(struct net_device *dev,
 			 struct iw_param *wrq,
              char *extra)
 {
-    PSDevice	        pDevice =3D (PSDevice)dev->priv;
+    PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRETRY \n");
 	wrq->disabled =3D 0;      // Can't be disabled
=20
@@ -1460,7 +1460,7 @@ int iwctl_siwencode(struct net_device *dev,
              struct iw_point *wrq,
              char *extra)
 {
-    PSDevice	        pDevice =3D (PSDevice)dev->priv;
+    PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);
 	DWORD dwKeyIndex =3D (DWORD)(wrq->flags & IW_ENCODE_INDEX);
 	int ii,uu, rc =3D 0;
@@ -1570,7 +1570,7 @@ int iwctl_giwencode(struct net_device *dev,
              struct iw_point *wrq,
              char *extra)
 {
-    PSDevice	        pDevice =3D (PSDevice)dev->priv;
+    PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);
     int rc =3D 0;
     char abyKey[WLAN_WEP232_KEYLEN];
@@ -1616,7 +1616,7 @@ int iwctl_giwencode(struct net_device *dev,
 			struct iw_point *wrq,
 			char *extra)
 {
-	PSDevice			pDevice =3D (PSDevice)dev->priv;
+	PSDevice			pDevice =3D (PSDevice)netdev_priv(dev);
 	PSMgmtObject		pMgmt =3D &(pDevice->sMgmtObj);
 	char abyKey[WLAN_WEP232_KEYLEN];
=20
@@ -1678,7 +1678,7 @@ int iwctl_siwpower(struct net_device *dev,
 			 struct iw_param *wrq,
              char *extra)
 {
-    PSDevice            pDevice =3D (PSDevice)dev->priv;
+    PSDevice            pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);
     int rc =3D 0;
=20
@@ -1728,7 +1728,7 @@ int iwctl_giwpower(struct net_device *dev,
 			 struct iw_param *wrq,
              char *extra)
 {
-    PSDevice            pDevice =3D (PSDevice)dev->priv;
+    PSDevice            pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);
     int mode =3D pDevice->ePSMode;
=20
@@ -1760,7 +1760,7 @@ int iwctl_giwsens(struct net_device *dev,
 			 struct iw_param *wrq,
 			 char *extra)
 {
-    PSDevice	        pDevice =3D (PSDevice)dev->priv;
+    PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     long ldBm;
=20
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSENS \n");
@@ -1786,7 +1786,7 @@ int iwctl_siwauth(struct net_device *dev,
 			  struct iw_param *wrq,
 			  char *extra)
 {
-	PSDevice			pDevice =3D (PSDevice)dev->priv;
+	PSDevice			pDevice =3D (PSDevice)netdev_priv(dev);
 	PSMgmtObject	pMgmt =3D &(pDevice->sMgmtObj);
 	int ret=3D0;
 	static int wpa_version=3D0;  //must be static to save the last value,eins=
n liu
@@ -1918,7 +1918,7 @@ int iwctl_siwgenie(struct net_device *dev,
 			  struct iw_point *wrq,
 			  char *extra)
 {
-	PSDevice			pDevice =3D (PSDevice)dev->priv;
+	PSDevice			pDevice =3D (PSDevice)netdev_priv(dev);
 	PSMgmtObject	pMgmt =3D &(pDevice->sMgmtObj);
 	int ret=3D0;
=20
@@ -1951,7 +1951,7 @@ int iwctl_giwgenie(struct net_device *dev,
 			  struct iw_point *wrq,
 			  char *extra)
 {
-	PSDevice			pDevice =3D (PSDevice)dev->priv;
+	PSDevice			pDevice =3D (PSDevice)netdev_priv(dev);
 	PSMgmtObject	pMgmt =3D &(pDevice->sMgmtObj);
 	int ret=3D0;
 	int space =3D wrq->length;
@@ -1976,7 +1976,7 @@ int iwctl_siwencodeext(struct net_device *dev,
              struct iw_point *wrq,
              char *extra)
 {
-    PSDevice	        pDevice =3D (PSDevice)dev->priv;
+    PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject	pMgmt =3D &(pDevice->sMgmtObj);
 	struct iw_encode_ext *ext =3D (struct iw_encode_ext*)extra;
     struct viawget_wpa_param *param=3DNULL;
@@ -2135,7 +2135,7 @@ int iwctl_siwmlme(struct net_device *dev,
 				struct iw_point *wrq,
 				char *extra)
 {
-	PSDevice			pDevice =3D (PSDevice)dev->priv;
+	PSDevice			pDevice =3D (PSDevice)netdev_priv(dev);
 	PSMgmtObject	pMgmt =3D &(pDevice->sMgmtObj);
 	struct iw_mlme *mlme =3D (struct iw_mlme *)extra;
 	//u16 reason =3D cpu_to_le16(mlme->reason_code);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/mai=
n_usb.c
index f181d23..12a9ae0 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -866,15 +866,8 @@ vntwusb_found1(struct usb_device *udev, UINT interface=
, const struct usb_device_
   udev =3D usb_get_dev(udev);
 #endif
=20
-	pDevice =3D kmalloc(sizeof(DEVICE_INFO), GFP_KERNEL);
-	if (pDevice =3D=3D NULL) {
-	    printk(KERN_ERR DEVICE_NAME ": allocate usb device failed \n");
-	    goto err_nomem;
-	}
-    memset(pDevice, 0, sizeof(DEVICE_INFO));
-
 #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
-    netdev =3D alloc_etherdev(0);
+    netdev =3D alloc_etherdev(sizeof(DEVICE_INFO));
 #else
     netdev =3D init_etherdev(netdev, 0);
 #endif
@@ -884,6 +877,10 @@ vntwusb_found1(struct usb_device *udev, UINT interface=
, const struct usb_device_
         kfree(pDevice);
 	    goto err_nomem;
     }
+
+    pDevice =3D netdev_priv(netdev);
+    memset(pDevice, 0, sizeof(DEVICE_INFO));
+
     pDevice->dev =3D netdev;
     pDevice->usb =3D udev;
=20
@@ -899,7 +896,6 @@ vntwusb_found1(struct usb_device *udev, UINT interface,=
 const struct usb_device_
     pDevice->tx_80211 =3D device_dma0_tx_80211;
     pDevice->sMgmtObj.pAdapter =3D (PVOID)pDevice;
=20
-	netdev->priv               =3D pDevice;
     netdev->open               =3D device_open;
     netdev->hard_start_xmit    =3D device_xmit;
     netdev->stop               =3D device_close;
@@ -1205,7 +1201,7 @@ BOOL device_alloc_frag_buf(PSDevice pDevice, PSDeFrag=
ControlBlock pDeF) {
 /*-----------------------------------------------------------------*/
=20
 static int  device_open(struct net_device *dev) {
-    PSDevice    pDevice=3D(PSDevice) dev->priv;
+    PSDevice    pDevice=3D(PSDevice) netdev_priv(dev);
=20
 #ifdef WPA_SM_Transtatus
      extern SWPAResult wpa_Result;
@@ -1348,7 +1344,7 @@ free_rx_tx:
=20
=20
 static int  device_close(struct net_device *dev) {
-    PSDevice    pDevice=3D(PSDevice) dev->priv;
+    PSDevice    pDevice=3D(PSDevice) netdev_priv(dev);
     PSMgmtObject     pMgmt =3D &(pDevice->sMgmtObj);
=20
    #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,21)
@@ -1507,7 +1503,7 @@ device_release_WPADEV(pDevice);
=20
=20
 static int device_dma0_tx_80211(struct sk_buff *skb, struct net_device *de=
v) {
-    PSDevice        pDevice=3Ddev->priv;
+    PSDevice        pDevice=3Dnetdev_priv(dev);
     PBYTE           pbMPDU;
     UINT            cbMPDULen =3D 0;
=20
@@ -1535,7 +1531,7 @@ static int device_dma0_tx_80211(struct sk_buff *skb, =
struct net_device *dev) {
=20
=20
 static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
-    PSDevice    pDevice=3Ddev->priv;
+    PSDevice    pDevice=3Dnetdev_priv(dev);
     struct net_device_stats* pStats =3D &pDevice->stats;
=20
=20
@@ -1768,7 +1764,7 @@ static int Read_config_file(PSDevice pDevice) {
 }
=20
 static void device_set_multi(struct net_device *dev) {
-    PSDevice         pDevice =3D (PSDevice) dev->priv;
+    PSDevice         pDevice =3D (PSDevice) netdev_priv(dev);
     PSMgmtObject     pMgmt =3D &(pDevice->sMgmtObj);
     u32              mc_filter[2];
     int              ii;
@@ -1833,14 +1829,14 @@ static void device_set_multi(struct net_device *dev=
) {
=20
=20
 static struct net_device_stats *device_get_stats(struct net_device *dev) {
-    PSDevice pDevice=3D(PSDevice) dev->priv;
+    PSDevice pDevice=3D(PSDevice) netdev_priv(dev);
=20
     return &pDevice->stats;
 }
=20
=20
 static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd=
) {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);
     PSCmdRequest        pReq;
     //BOOL                bCommit =3D FALSE;
diff --git a/drivers/staging/vt6656/wpactl.c b/drivers/staging/vt6656/wpact=
l.c
index 9345459..37c2900 100644
--- a/drivers/staging/vt6656/wpactl.c
+++ b/drivers/staging/vt6656/wpactl.c
@@ -115,14 +115,16 @@ static void wpadev_setup(struct net_device *dev)
=20
 static int wpa_init_wpadev(PSDevice pDevice)
 {
+    PSDevice wpadev_priv;
 	struct net_device *dev =3D pDevice->dev;
          int ret=3D0;
=20
-	pDevice->wpadev =3D alloc_netdev(0, "vntwpa", wpadev_setup);
+	pDevice->wpadev =3D alloc_netdev(sizeof(PSDevice), "vntwpa", wpadev_setup=
);
 	if (pDevice->wpadev =3D=3D NULL)
 		return -ENOMEM;
=20
-	pDevice->wpadev->priv =3D pDevice;
+    wpadev_priv =3D netdev_priv(pDevice->wpadev);
+    *wpadev_priv =3D *pDevice;
 	memcpy(pDevice->wpadev->dev_addr, dev->dev_addr, U_ETHER_ADDR_LEN);
          pDevice->wpadev->base_addr =3D dev->base_addr;
 	pDevice->wpadev->irq =3D dev->irq;
--=20
1.5.6.3


--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--mln0rGgUGuXEqmuI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKR6JRRO4fQQdv5AwRArMLAKCHRxxtCBjXdkRXezLr6A5RbfXj6QCg2aun
NnqEbHzZX6quz3KiOaB7ogQ=
=OZ0l
-----END PGP SIGNATURE-----

--mln0rGgUGuXEqmuI--
