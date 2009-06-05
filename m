Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbZFEFKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbZFEFKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 01:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbZFEFKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 01:10:23 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:57327 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbZFEFKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 01:10:22 -0400
Message-ID: <4A28A8BC.6090408@gmail.com>
Date: Fri, 05 Jun 2009 10:40:20 +0530
From: Pranith Kumar <pranith.hacks@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.0.12) Gecko/20070530 Red Hat/1.0.9-2.el4 SeaMonkey/1.0.9
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [TRIVIAL][PATCH 1/1] Fix warning in staging/otus/ioctl.c
References: <430c80e90905290054n7416802cq7128394db5de036d@mail.gmail.com> <20090602214745.GB25921@kroah.com> <430c80e90906022349l6fa7a9b4lb73f0ab1980b3e63@mail.gmail.com> <20090603152152.GB25560@kroah.com> <4A27616C.6030802@gmail.com> <20090604175612.GB18605@kroah.com>
In-Reply-To: <20090604175612.GB18605@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jun 2009 05:10:21.0734 (UTC) FILETIME=[ED199C60:01C9E59B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Jun 04, 2009 at 11:23:48AM +0530, Pranith Kumar wrote:
>   
>> Greg KH wrote:
>>     
>>> On Wed, Jun 03, 2009 at 12:19:26PM +0530, Pranith Kumar wrote:
>>>   
>>>       
>>>> I am using Gmail, which does this. I haven't figured out how to
>>>> configure this thing yet.
>>>>     
>>>>         
>>>
> Nope, the patch is linewrapped and the whitespace is still messed up :(
>
> Care to retry?
>
>   
Ok, checked this with checkpatch.pl and it shows no errors. Fingers crossed.

Signed-off-by: D Pranith Kumar <bobby.prani@gmail.com>

diff --git a/drivers/staging/otus/ioctl.c b/drivers/staging/otus/ioctl.c
index ce04218..5e8bd94 100644
--- a/drivers/staging/otus/ioctl.c
+++ b/drivers/staging/otus/ioctl.c
@@ -2045,6 +2045,7 @@ int usbdrv_wpa_ioctl(struct net_device *dev, 
struct athr_wlan_param *zdparm)
     struct zsKeyInfo keyInfo;
     struct usbdrv_private *macp = dev->ml_priv;
     u16_t vapId = 0;
+   int ii;
 
     /* zmw_get_wlan_dev(dev); */
 
@@ -2168,7 +2169,6 @@ int usbdrv_wpa_ioctl(struct net_device *dev, 
struct athr_wlan_param *zdparm)
         /* DUMP key context */
         /* #ifdef WPA_DEBUG */
         if (keyInfo.keyLength > 0) {
-            int ii;
             printk(KERN_WARNING
                         "Otus: Key Context:\n");
             for (ii = 0; ii < keyInfo.keyLength; ) {
@@ -2266,7 +2266,6 @@ int usbdrv_wpa_ioctl(struct net_device *dev, 
struct athr_wlan_param *zdparm)
         /* zfiWlanSetWpaIe(dev, zdparm->u.generic_elem.data,
         * zdparm->u.generic_elem.len);
         */
-        int ii;
         u8_t len = zdparm->u.generic_elem.len;
         u8_t *wpaie = (u8_t *)zdparm->u.generic_elem.data;
 
@@ -2401,7 +2400,7 @@ int usbdrv_ioctl(struct net_device *dev, struct 
ifreq *ifr, int cmd)
     struct athr_wlan_param zdparm;
     struct usbdrv_private *macp = dev->ml_priv;
 
-    int err = 0;
+    int err = 0, val = 0;
     int changed = 0;
 
     /* regp = macp->regp; */
@@ -2445,7 +2444,7 @@ int usbdrv_ioctl(struct net_device *dev, struct 
ifreq *ifr, int cmd)
             err = -EPERM;
             break;
         }
-        int val = *((int *) wrq->u.name);
+       val = *((int *) wrq->u.name);
         if ((val < 0) || (val > 2)) {
             err = -EINVAL;
             break;


