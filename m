Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597Ab0CIMnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 07:43:06 -0500
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:2399 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750973Ab0CIMnE (ORCPT
	<rfc822;groupwise-jlee@novell.com:4:1>);
	Tue, 9 Mar 2010 07:43:04 -0500
Message-Id: <4B96DD0202000023000146D6@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 09 Mar 2010 05:42:58 -0700
From: "Joey Lee" <jlee@novell.com>
To: <gregkh@suse.de>
Cc: <mzxreary@0pointer.de>, <mjg59@srcf.ucam.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 58/62] msi-laptop: Support some MSI 3G netbook that
	 is need load SCM
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__PartB59F6542.3__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__PartB59F6542.3__=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

Hi Greg, 

Please kindly review the attached patch for removed the non-standard
interface "threeg" in msi-laptop driver.



Thank's a lot!
Joey Lee

於 五，2010-03-05 於 06:10 +0000，joeyli(Joey Lee) 提到：
> Hi Matthew, 
> 
> 於 四，2010-03-04 於 17:09 +0000，Matthew Garrett 提到：
> > On Thu, Mar 04, 2010 at 10:07:53AM -0700, Joey Lee wrote:
> > > Thank's for your review and suggestion.
> > > Per discuss for msi-laptop patchset, I will submit a bit patch for the
> > > following change:
> > > 	- remove threeg sysfs interface.
> > > 	- add KEY_RFKILL keymapping to msi-laptop.
> > 
> > If the key event comes through the keyboard controller, there's no need 
> > to add the mapping to msi-laptop. Doing it through udev or hal is fine.
> > 
> 
> Thank's fully undertood, now, will send patch for remove threeg sysfs
> interface.
> 
> 
> Joey Lee


--=__PartB59F6542.3__=
Content-Type: text/plain; name="0006-Removed-non-standard-interface-threeg.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="0006-Removed-non-standard-interface-threeg.patch"

>From c9dc06048fcb0b8fadd510ef26b5af7b466aeab6 Mon Sep 17 00:00:00 =
2001=0AFrom: Lee, Chun-Yi <jlee@novell.com>=0ADate: Tue, 9 Mar 2010 =
20:25:42 +0800=0ASubject: [PATCH] Removed non-standard interface =
"threeg"=0A=0AThere already have standard rfkill wwan interface for 3G =
device, so, removed=0Anon-standard interface "threeg".=0A=0ASigned-off-by: =
Lee, Chun-Yi <jlee@novell.com>=0A---=0A drivers/platform/x86/msi-laptop.c =
|   36 ------------------------------------=0A 1 files changed, 0 =
insertions(+), 36 deletions(-)=0A=0Adiff --git a/drivers/platform/x86/msi-l=
aptop.c b/drivers/platform/x86/msi-laptop.c=0Aindex c2b05da..c891522 =
100644=0A--- a/drivers/platform/x86/msi-laptop.c=0A+++ b/drivers/platform/x=
86/msi-laptop.c=0A@@ -311,29 +311,6 @@ static ssize_t store_bluetooth(struc=
t device *dev,=0A 	return set_device_state(buf, count, MSI_STANDARD_EC=
_BLUETOOTH_MASK);=0A }=0A =0A-static ssize_t show_threeg(struct device =
*dev,=0A-	struct device_attribute *attr, char *buf)=0A-{=0A-=0A-	=
int ret;=0A-=0A-	/* old msi ec not support 3G */=0A-	if =
(old_ec_model)=0A-		return -1;=0A-=0A-	ret =3D get_wireles=
s_state_ec_standard();=0A-	if (ret < 0)=0A-		return =
ret;=0A-=0A-	return sprintf(buf, "%i\n", threeg_s);=0A-}=0A-=0A-static =
ssize_t store_threeg(struct device *dev,=0A-	struct device_attribute =
*attr, const char *buf, size_t count)=0A-{=0A-	return set_device_state(buf=
, count, MSI_STANDARD_EC_3G_MASK);=0A-}=0A-=0A static ssize_t show_lcd_leve=
l(struct device *dev,=0A 	struct device_attribute *attr, char =
*buf)=0A {=0A@@ -396,7 +373,6 @@ static DEVICE_ATTR(lcd_level, 0644, =
show_lcd_level, store_lcd_level);=0A static DEVICE_ATTR(auto_brightness, =
0644, show_auto_brightness, store_auto_brightness);=0A static DEVICE_ATTR(b=
luetooth, 0444, show_bluetooth, NULL);=0A static DEVICE_ATTR(wlan, 0444, =
show_wlan, NULL);=0A-static DEVICE_ATTR(threeg, 0444, show_threeg, =
NULL);=0A =0A static struct attribute *msipf_attributes[] =3D {=0A 	=
&dev_attr_lcd_level.attr,=0A@@ -635,10 +611,8 @@ static int load_scm_model_=
init(struct platform_device *sdev)=0A 	/* allow userland write sysfs file =
 */=0A 	dev_attr_bluetooth.store =3D store_bluetooth;=0A 	dev_attr_wl=
an.store =3D store_wlan;=0A-	dev_attr_threeg.store =3D store_threeg;=0A =
	dev_attr_bluetooth.attr.mode |=3D S_IWUSR;=0A 	dev_attr_wlan.attr.=
mode |=3D S_IWUSR;=0A-	dev_attr_threeg.attr.mode |=3D S_IWUSR;=0A =0A 	/* =
disable hardware control by fn key */=0A 	result =3D ec_read(MSI_STAN=
DARD_EC_SCM_LOAD_ADDRESS, &data);=0A@@ -715,14 +689,6 @@ static int __init =
msi_init(void)=0A 	if (ret)=0A 		goto fail_platform_device2;=
=0A =0A-	if (!old_ec_model) {=0A-		if (threeg_exists)=
=0A-			ret =3D device_create_file(&msipf_device->dev,=0A-	=
					&dev_attr_threeg);=0A-		if =
(ret)=0A-			goto fail_platform_device2;=0A-	}=0A-=0A 	=
/* Disable automatic brightness control by default because=0A 	 * this =
module was probably loaded to do brightness control in=0A 	 * =
software. */=0A@@ -757,8 +723,6 @@ static void __exit msi_cleanup(void)=0A =
{=0A =0A 	sysfs_remove_group(&msipf_device->dev.kobj, &msipf_attribut=
e_group);=0A-	if (!old_ec_model && threeg_exists)=0A-		device_remo=
ve_file(&msipf_device->dev, &dev_attr_threeg);=0A 	platform_device_unr=
egister(msipf_device);=0A 	platform_driver_unregister(&msipf_driver);=
=0A 	backlight_device_unregister(msibl_device);=0A-- =0A1.6.0.2=0A=0A
--=__PartB59F6542.3__=--
