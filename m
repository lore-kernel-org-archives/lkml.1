Return-Path: <linux-kernel-owner+w=401wt.eu-S1753137AbYDHKnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbYDHKnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 06:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbYDHKnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 06:43:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:43590 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbYDHKnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 06:43:24 -0400
Date: Tue, 8 Apr 2008 12:44:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com
Subject: w35und: smaller, but trivial cleanups
Message-ID: <20080408104406.GA2111@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Smaller cleanups to wbusb.c

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 8b2bd7b21ec35aaf4e0e9ca2c0cb4e98ac3cb2f2
tree 19c10fb8de1734fbe1b62605a81af2f63d1ff25b
parent 05affe25840089b2e8c3ea4033b38efb933ddbc1
author Pavel <pavel@amd.ucw.cz> Tue, 08 Apr 2008 12:43:40 +0200
committer Pavel <pavel@amd.ucw.cz> Tue, 08 Apr 2008 12:43:40 +0200

 .../net/wireless/winbond/winbondport/linux/wbusb.c |  122 ++++++++---------------
 1 files changed, 44 insertions(+), 78 deletions(-)

diff --git a/drivers/net/wireless/winbond/winbondport/linux/wbusb.c b/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
index 62d3e49..9727477 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
@@ -12,7 +12,7 @@ MODULE_VERSION("0.1");
 
 
 //============================================================
-//vender ID and product ID can into here for others
+// vendor ID and product ID can into here for others
 //============================================================
 static struct usb_device_id Id_Table[] = 
 {
@@ -24,87 +24,68 @@ static struct usb_device_id Id_Table[] =
   {USB_DEVICE( 0x18E8, 0x6233 )},	
   {USB_DEVICE( 0x1131, 0x2035 )},
   {  }
-}
-;
-MODULE_DEVICE_TABLE(usb,Id_Table);
+};
+
+MODULE_DEVICE_TABLE(usb, Id_Table);
 
-	static struct usb_driver wb35_driver = {
-			.name =		"w35und",
-			.probe =	wb35_probe,
-			.disconnect = wb35_disconnect,
-			.id_table = Id_Table,
-	};
+static struct usb_driver wb35_driver = {
+	.name =		"w35und",
+	.probe =	wb35_probe,
+	.disconnect = wb35_disconnect,
+	.id_table = Id_Table,
+};
 
-int __init wb35_init( void )
+int __init wb35_init(void)
 {
-	printk("sizeof ADAPTER = %d\n", sizeof(ADAPTER) );
 	printk("[w35und]driver init\n");
-	return usb_register( &wb35_driver );
+	return usb_register(&wb35_driver);
 }
 
-void __exit wb35_exit( void )
+void __exit wb35_exit(void)
 {
-	printk(("[w35und]driver exit\n"));
+	printk("[w35und]driver exit\n");
 	usb_deregister( &wb35_driver );
 }
 
-module_init( wb35_init );
-module_exit( wb35_exit );
+module_init(wb35_init);
+module_exit(wb35_exit);
 
-//Usb kernel subsystem will call this function when a new device is plugged into.
+// Usb kernel subsystem will call this function when a new device is plugged into.
 int wb35_probe( struct usb_interface *intf,const struct usb_device_id *id_table )
 {
 	PADAPTER	Adapter;
 	PWBLINUX	pWbLinux;
 	PWBUSB		pWbUsb;
 	struct net_device *netdev = NULL;
-
         struct usb_host_interface *interface;
-   
-   //struct usb_interface_descriptor *interface;
-    struct usb_endpoint_descriptor *endpoint;
+	struct usb_endpoint_descriptor *endpoint;
 	int	i, ret = -1;
 	u32	ltmp;
-
-
 	struct usb_device *udev = interface_to_usbdev(intf);
-	int res = -ENOMEM;
+
 	usb_get_dev(udev);
 
 	printk("[w35und]wb35_probe ->\n");
 
-	do
-	{
-
-		// 20060630.1 Add for check HW basically
-		for( i=0; i<(sizeof(Id_Table)/sizeof(struct usb_device_id)); i++ )
-		{
-			if( (udev->descriptor.idVendor == Id_Table[i].idVendor) &&
-				(udev->descriptor.idProduct == Id_Table[i].idProduct) )
-			{
-				#ifdef _PE_USB_INI_DUMP_
-				WBDEBUG(("[w35und]This is the one we are interested about\n"));
-				#endif
+	do {
+		for (i=0; i<(sizeof(Id_Table)/sizeof(struct usb_device_id)); i++ ) {
+			if ((udev->descriptor.idVendor == Id_Table[i].idVendor) &&
+				(udev->descriptor.idProduct == Id_Table[i].idProduct)) {
+				printk("[w35und]Found supported hardware\n");
 				break;
 			}
 		}
-		if( i == (sizeof(Id_Table)/sizeof(struct usb_device_id)) )
-		{
+		if ((i == (sizeof(Id_Table)/sizeof(struct usb_device_id)))) {
 			#ifdef _PE_USB_INI_DUMP_
 			WBDEBUG(("[w35und] This is not the one we are interested about\n"));
 			#endif
-		   //Devuelve NULL en un int?? , donde definio NULL si es para otro OS?
-			return res;
+			return -ENODEV;
 		}
 
 		// 20060630.2 Check the device if it already be opened
-		ret = usb_control_msg( udev,
-					   usb_rcvctrlpipe( udev, 0 ),
-					   0x01,
-					   USB_TYPE_VENDOR|USB_RECIP_DEVICE|USB_DIR_IN,
-					   0x0, 0x400,
-					   &ltmp,
-					   4, HZ*100 );
+		ret = usb_control_msg(udev, usb_rcvctrlpipe( udev, 0 ),
+				      0x01, USB_TYPE_VENDOR|USB_RECIP_DEVICE|USB_DIR_IN,
+				      0x0, 0x400, &ltmp, 4, HZ*100 );
 		if( ret < 0 )
 			break;
 
@@ -116,7 +97,6 @@ int wb35_probe( struct usb_interface *in
 
 		if (!netdev) {
 			printk("[w35und]init_etherdev out of memory\n");
-
 			module_put(THIS_MODULE);
 			break;
 		}
@@ -124,52 +104,38 @@ int wb35_probe( struct usb_interface *in
 		// Clear out the adapter block, which sets all default values to FALSE, or NULL.
 		Adapter = netdev_priv(netdev);
 
-		OS_MEMORY_CLEAR( Adapter, sizeof(ADAPTER) );
+		memset(Adapter, 0, sizeof(ADAPTER));
 		pWbLinux = &Adapter->WbLinux;
-		pWbLinux->netdev = netdev; // Initial netdev variable of WbLinux
+		pWbLinux->netdev = netdev;
 		pWbUsb = &Adapter->sHwData.WbUsb;
 		pWbUsb->udev = udev;
 
-	        //Cambiado
 	        interface = intf->cur_altsetting;
 	        endpoint = &interface->endpoint[0].desc;
 
-	   	   //&(intf->altsetting->endpoint);
-
-		if( endpoint[2].wMaxPacketSize == 512 )
-		{
+		if (endpoint[2].wMaxPacketSize == 512) {
 			printk("[w35und] Working on USB 2.0\n");
 			pWbUsb->IsUsb20 = 1;
 		}
-		#ifdef _PE_STATE_DUMP_	
-		WBDEBUG(("WbWLanInitialize(1)\n"));
-		#endif
-		if (!WbWLanInitialize( Adapter ))
-		{
+
+		if (!WbWLanInitialize(Adapter)) {
 			printk("[w35und]WbWLanInitialize fail\n");
 			break;
 		}
-		//For test,Added by WangJS 2006.9.1
-		#ifdef _PE_STATE_DUMP_
-		WBDEBUG(("WbWLanInitialize(2)\n"));
-		#endif
 
-		//Set MAC Address - by Someone - since 2.6.24-rc2
+		// Set MAC Address
 		{
 			phw_data_t pHwData = &Adapter->sHwData;
 			hal_get_permanent_address(pHwData, netdev->dev_addr);
 		}
 
-		//////////////////////////////////////////////////
-		//Added by WangJS 2006.7.28
 		FourWayInit(Adapter);
-		//////////////////////////////////////////////////
 
 		//Moved later, to make possible the changing of MAC
 		//Needs some more work
 		dev_alloc_name(netdev, "wlan%d");
+		SET_NETDEV_DEV(netdev, &intf->dev);
 
-		SET_NETDEV_DEV( netdev, &intf->dev );
 		if (register_netdev(netdev)) {
 			printk("w35und: couldn't register the netdev!\n");
 			break;
@@ -198,7 +164,7 @@ WbUsb_destroy(  phw_data_t pHwData )
 {
 }
 
-int wb35_open( struct net_device *netdev )
+int wb35_open(struct net_device *netdev)
 {
 	PADAPTER Adapter = (PADAPTER)netdev->priv;
 	phw_data_t pHwData = &Adapter->sHwData;
@@ -211,25 +177,25 @@ int wb35_open( struct net_device *netdev
 	return 0;
 }
 
-int wb35_close( struct net_device *netdev )
+int wb35_close(struct net_device *netdev)
 {
 	netif_stop_queue(netdev);
 	return 0;
 }
 
-void wb35_disconnect( struct usb_interface *intf )
+void wb35_disconnect(struct usb_interface *intf)
 {
 	PWBLINUX pWbLinux;
-	PADAPTER Adapter = usb_get_intfdata( intf );
-	usb_set_intfdata( intf, NULL );
+	PADAPTER Adapter = usb_get_intfdata(intf);
+	usb_set_intfdata(intf, NULL);
 
         pWbLinux = &Adapter->WbLinux;
 
 	// Card remove
-	WbWlanHalt( Adapter );
+	WbWlanHalt(Adapter);
 
-	if( pWbLinux->netdev )
-		free_netdev( pWbLinux->netdev );
+	if (pWbLinux->netdev)
+		free_netdev(pWbLinux->netdev);
 }
 
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
