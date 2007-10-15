Return-Path: <linux-kernel-owner+w=401wt.eu-S1760528AbXJNS4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760528AbXJNS4R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758680AbXJNS4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:56:03 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:14080 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758644AbXJNS4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:56:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:organization:x-mailer:mime-version:content-type:from;
        b=dQRYjv733q02VJgpJzMeoL1G6jUe2kaIsfoTGqLl9z5KlvoQvIBvVdhVGNi9Ut4OMhEPHdkBCWj51b8FDvFxtQtJG3vc31D6eEN1oz9vkXT7wggOaMYXB9luwIlTph/A6XOkD/cGPEFjwjx6e0wbrZh/OkQ1QRjeuKtW13NXDkE=
Date: Sun, 14 Oct 2007 21:04:03 -0700
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] : IDE-CS Add additional id string (corsair, 1GB)
Message-Id: <20071014210403.13d6f560.Kristoffer.Ericson@Gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Sun__14_Oct_2007_21_04_03_-0700_TzOrW4B3XH0_h21r"
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Sun__14_Oct_2007_21_04_03_-0700_TzOrW4B3XH0_h21r
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Greetings,

The manf string looks weird (0x0 + 0x0), but I assume its correct. Also, whitespaces seems almost intentional, so am I missing something?

Shortlog:
This patch adds id strings for Corsair 1GB (identified as Hyperstone Model1) inside legacy/ide-cs.c
It also includes some minor whitespace cleanups.

Signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>

diff --git a/drivers/ide/legacy/ide-cs.c b/drivers/ide/legacy/ide-cs.c
index 4cdb519..e8e360c 100644
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -28,7 +28,7 @@
     and other provisions required by the GPL.  If you do not delete
     the provisions above, a recipient may use your version of this
     file under either the MPL or the GPL.
-    
+
 ======================================================================*/
 
 #include <linux/module.h>
@@ -327,13 +327,13 @@ failed:
     After a card is removed, ide_release() will unregister the net
     device, and release the PCMCIA configuration.  If the device is
     still open, this will be postponed until it is closed.
-    
+
 ======================================================================*/
 
 void ide_release(struct pcmcia_device *link)
 {
     ide_info_t *info = link->priv;
-    
+
     DEBUG(0, "ide_release(0x%p)\n", link);
 
     if (info->ndev) {
@@ -353,11 +353,12 @@ void ide_release(struct pcmcia_device *link)
     stuff to run after an event is received.  A CARD_REMOVAL event
     also sets some flags to discourage the ide drivers from
     talking to the ports.
-    
+
 ======================================================================*/
 
 static struct pcmcia_device_id ide_ids[] = {
 	PCMCIA_DEVICE_FUNC_ID(4),
+	PCMCIA_DEVICE_MANF_CARD(0x0000, 0x0000),	/* Corsair */
 	PCMCIA_DEVICE_MANF_CARD(0x0007, 0x0000),	/* Hitachi */
 	PCMCIA_DEVICE_MANF_CARD(0x000a, 0x0000),	/* I-O Data CFA */
 	PCMCIA_DEVICE_MANF_CARD(0x001c, 0x0001),	/* Mitsubishi CFA */
@@ -366,7 +367,7 @@ static struct pcmcia_device_id ide_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x0098, 0x0000),	/* Toshiba */
 	PCMCIA_DEVICE_MANF_CARD(0x00a4, 0x002d),
 	PCMCIA_DEVICE_MANF_CARD(0x00ce, 0x0000),	/* Samsung */
- 	PCMCIA_DEVICE_MANF_CARD(0x0319, 0x0000),	/* Hitachi */
+	PCMCIA_DEVICE_MANF_CARD(0x0319, 0x0000),	/* Hitachi */
 	PCMCIA_DEVICE_MANF_CARD(0x2080, 0x0001),
 	PCMCIA_DEVICE_MANF_CARD(0x4e01, 0x0100),	/* Viking CFA */
 	PCMCIA_DEVICE_MANF_CARD(0x4e01, 0x0200),	/* Lexar, Viking CFA */
@@ -384,6 +385,7 @@ static struct pcmcia_device_id ide_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("FREECOM", "PCCARD-IDE", 0x5714cbf7, 0x48e0ab8e),
 	PCMCIA_DEVICE_PROD_ID12("HITACHI", "FLASH", 0xf4f43949, 0x9eb86aae),
 	PCMCIA_DEVICE_PROD_ID12("HITACHI", "microdrive", 0xf4f43949, 0xa6d76178),
+	PCMCIA_DEVICE_PROD_ID12("Hyperstone", "Model1", 0x3d5b9ef5, 0xca6ab420),
 	PCMCIA_DEVICE_PROD_ID12("IBM", "microdrive", 0xb569a6e5, 0xa6d76178),
 	PCMCIA_DEVICE_PROD_ID12("IBM", "IBM17JSSFP20", 0xb569a6e5, 0xf2508753),
 	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF8GB", 0x2e6d1829, 0xacbe682e),



-- 
Kristoffer Ericson <Kristoffer.Ericson@Gmail.com>

--Multipart=_Sun__14_Oct_2007_21_04_03_-0700_TzOrW4B3XH0_h21r
Content-Type: application/octet-stream;
 name="ide-cs.c-add-corsair-cf.patch"
Content-Disposition: attachment;
 filename="ide-cs.c-add-corsair-cf.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvaWRlL2xlZ2FjeS9pZGUtY3MuYyBiL2RyaXZlcnMvaWRlL2xl
Z2FjeS9pZGUtY3MuYwppbmRleCA0Y2RiNTE5Li5lOGUzNjBjIDEwMDY0NAotLS0gYS9kcml2ZXJz
L2lkZS9sZWdhY3kvaWRlLWNzLmMKKysrIGIvZHJpdmVycy9pZGUvbGVnYWN5L2lkZS1jcy5jCkBA
IC0yOCw3ICsyOCw3IEBACiAgICAgYW5kIG90aGVyIHByb3Zpc2lvbnMgcmVxdWlyZWQgYnkgdGhl
IEdQTC4gIElmIHlvdSBkbyBub3QgZGVsZXRlCiAgICAgdGhlIHByb3Zpc2lvbnMgYWJvdmUsIGEg
cmVjaXBpZW50IG1heSB1c2UgeW91ciB2ZXJzaW9uIG9mIHRoaXMKICAgICBmaWxlIHVuZGVyIGVp
dGhlciB0aGUgTVBMIG9yIHRoZSBHUEwuCi0gICAgCisKID09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0qLwogCiAjaW5j
bHVkZSA8bGludXgvbW9kdWxlLmg+CkBAIC0zMjcsMTMgKzMyNywxMyBAQCBmYWlsZWQ6CiAgICAg
QWZ0ZXIgYSBjYXJkIGlzIHJlbW92ZWQsIGlkZV9yZWxlYXNlKCkgd2lsbCB1bnJlZ2lzdGVyIHRo
ZSBuZXQKICAgICBkZXZpY2UsIGFuZCByZWxlYXNlIHRoZSBQQ01DSUEgY29uZmlndXJhdGlvbi4g
IElmIHRoZSBkZXZpY2UgaXMKICAgICBzdGlsbCBvcGVuLCB0aGlzIHdpbGwgYmUgcG9zdHBvbmVk
IHVudGlsIGl0IGlzIGNsb3NlZC4KLSAgICAKKwogPT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PSovCiAKIHZvaWQgaWRl
X3JlbGVhc2Uoc3RydWN0IHBjbWNpYV9kZXZpY2UgKmxpbmspCiB7CiAgICAgaWRlX2luZm9fdCAq
aW5mbyA9IGxpbmstPnByaXY7Ci0gICAgCisKICAgICBERUJVRygwLCAiaWRlX3JlbGVhc2UoMHgl
cClcbiIsIGxpbmspOwogCiAgICAgaWYgKGluZm8tPm5kZXYpIHsKQEAgLTM1MywxMSArMzUzLDEy
IEBAIHZvaWQgaWRlX3JlbGVhc2Uoc3RydWN0IHBjbWNpYV9kZXZpY2UgKmxpbmspCiAgICAgc3R1
ZmYgdG8gcnVuIGFmdGVyIGFuIGV2ZW50IGlzIHJlY2VpdmVkLiAgQSBDQVJEX1JFTU9WQUwgZXZl
bnQKICAgICBhbHNvIHNldHMgc29tZSBmbGFncyB0byBkaXNjb3VyYWdlIHRoZSBpZGUgZHJpdmVy
cyBmcm9tCiAgICAgdGFsa2luZyB0byB0aGUgcG9ydHMuCi0gICAgCisKID09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0q
LwogCiBzdGF0aWMgc3RydWN0IHBjbWNpYV9kZXZpY2VfaWQgaWRlX2lkc1tdID0gewogCVBDTUNJ
QV9ERVZJQ0VfRlVOQ19JRCg0KSwKKwlQQ01DSUFfREVWSUNFX01BTkZfQ0FSRCgweDAwMDAsIDB4
MDAwMCksCS8qIENvcnNhaXIgKi8KIAlQQ01DSUFfREVWSUNFX01BTkZfQ0FSRCgweDAwMDcsIDB4
MDAwMCksCS8qIEhpdGFjaGkgKi8KIAlQQ01DSUFfREVWSUNFX01BTkZfQ0FSRCgweDAwMGEsIDB4
MDAwMCksCS8qIEktTyBEYXRhIENGQSAqLwogCVBDTUNJQV9ERVZJQ0VfTUFORl9DQVJEKDB4MDAx
YywgMHgwMDAxKSwJLyogTWl0c3ViaXNoaSBDRkEgKi8KQEAgLTM2Niw3ICszNjcsNyBAQCBzdGF0
aWMgc3RydWN0IHBjbWNpYV9kZXZpY2VfaWQgaWRlX2lkc1tdID0gewogCVBDTUNJQV9ERVZJQ0Vf
TUFORl9DQVJEKDB4MDA5OCwgMHgwMDAwKSwJLyogVG9zaGliYSAqLwogCVBDTUNJQV9ERVZJQ0Vf
TUFORl9DQVJEKDB4MDBhNCwgMHgwMDJkKSwKIAlQQ01DSUFfREVWSUNFX01BTkZfQ0FSRCgweDAw
Y2UsIDB4MDAwMCksCS8qIFNhbXN1bmcgKi8KLSAJUENNQ0lBX0RFVklDRV9NQU5GX0NBUkQoMHgw
MzE5LCAweDAwMDApLAkvKiBIaXRhY2hpICovCisJUENNQ0lBX0RFVklDRV9NQU5GX0NBUkQoMHgw
MzE5LCAweDAwMDApLAkvKiBIaXRhY2hpICovCiAJUENNQ0lBX0RFVklDRV9NQU5GX0NBUkQoMHgy
MDgwLCAweDAwMDEpLAogCVBDTUNJQV9ERVZJQ0VfTUFORl9DQVJEKDB4NGUwMSwgMHgwMTAwKSwJ
LyogVmlraW5nIENGQSAqLwogCVBDTUNJQV9ERVZJQ0VfTUFORl9DQVJEKDB4NGUwMSwgMHgwMjAw
KSwJLyogTGV4YXIsIFZpa2luZyBDRkEgKi8KQEAgLTM4NCw2ICszODUsNyBAQCBzdGF0aWMgc3Ry
dWN0IHBjbWNpYV9kZXZpY2VfaWQgaWRlX2lkc1tdID0gewogCVBDTUNJQV9ERVZJQ0VfUFJPRF9J
RDEyKCJGUkVFQ09NIiwgIlBDQ0FSRC1JREUiLCAweDU3MTRjYmY3LCAweDQ4ZTBhYjhlKSwKIAlQ
Q01DSUFfREVWSUNFX1BST0RfSUQxMigiSElUQUNISSIsICJGTEFTSCIsIDB4ZjRmNDM5NDksIDB4
OWViODZhYWUpLAogCVBDTUNJQV9ERVZJQ0VfUFJPRF9JRDEyKCJISVRBQ0hJIiwgIm1pY3JvZHJp
dmUiLCAweGY0ZjQzOTQ5LCAweGE2ZDc2MTc4KSwKKwlQQ01DSUFfREVWSUNFX1BST0RfSUQxMigi
SHlwZXJzdG9uZSIsICJNb2RlbDEiLCAweDNkNWI5ZWY1LCAweGNhNmFiNDIwKSwKIAlQQ01DSUFf
REVWSUNFX1BST0RfSUQxMigiSUJNIiwgIm1pY3JvZHJpdmUiLCAweGI1NjlhNmU1LCAweGE2ZDc2
MTc4KSwKIAlQQ01DSUFfREVWSUNFX1BST0RfSUQxMigiSUJNIiwgIklCTTE3SlNTRlAyMCIsIDB4
YjU2OWE2ZTUsIDB4ZjI1MDg3NTMpLAogCVBDTUNJQV9ERVZJQ0VfUFJPRF9JRDEyKCJLSU5HU1RP
TiIsICJDRjhHQiIsIDB4MmU2ZDE4MjksIDB4YWNiZTY4MmUpLAo=

--Multipart=_Sun__14_Oct_2007_21_04_03_-0700_TzOrW4B3XH0_h21r--
