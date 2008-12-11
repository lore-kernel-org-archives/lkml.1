Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbYLKEBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbYLKEBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 23:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755695AbYLKEBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 23:01:34 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:24042 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbYLKEBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 23:01:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=dY6sF8exhz8axhnckk23nGv/MbOt0tBowxSZHE0uK8gv05a8w7WZIrslEhgdwBItm4
         jWefODzm0k2c66cD6pmLuzpldfET6IJobuQr+54ktapoxRhJmwTEcRpd9Ftpji1OV51S
         sCyazXQMEvxXy/BfcP0FifqzPC/yWzEG16kn4=
Message-ID: <9cde8bff0812102001s4617524cse1d73cc5620f7f73@mail.gmail.com>
Date: Thu, 11 Dec 2008 13:01:31 +0900
From: "Nguyen Anh Quynh" <aquynh@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, stern@rowland.harvard.edu,
       "Greg KH" <gregkh@suse.de>, "Andrew Morton" <akpm@osdl.org>
Subject: [PATCH] Another unusual_devs entry for another bad Argosy usb storage device
Cc: "Kuniyasu Suzaki" <k.suzaki@aist.go.jp>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_90575_21848620.1228968091581"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_90575_21848620.1228968091581
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I have another Argosy USB storage device, which has the same problem
with the Argosy USB storage device already fixed in 2.6.27.7. But this
device has another product ID (840:84), so this patch adds a new entry
into unusual_devs to fix the mount problem.

I enclose here two patches: one against 2.6.27.8, and another against
the latest linus-git tree.

Signed-off-by: Nguyen Anh Quynh <aquynh@gmail.com>


The information about the Argosy device is like below:

#lsusb -v -d 840:84
Bus 005 Device 005: ID 0840:0084 Argosy Research, Inc.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x0840 Argosy Research, Inc.
  idProduct          0x0084
  bcdDevice            0.01
  iManufacturer           1 Generic
  iProduct                2 USB 2.0 Storage Device
  iSerial                 3 8400000000002549
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xc0
      Self Powered
    MaxPower                2mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk (Zip)
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

Before the patch, dmesg returns a lot of information like below (my
dmesg is overflown):
....
[  138.833390] sd 7:0:0:0: [sdb] Add. Sense: No additional sense information
[  138.877631] sd 7:0:0:0: [sdb] Sense Key : No Sense [current]
[  138.877643] sd 7:0:0:0: [sdb] Add. Sense: No additional sense information
[  138.921906] sd 7:0:0:0: [sdb] Sense Key : No Sense [current]
[  138.921923] sd 7:0:0:0: [sdb] Add. Sense: No additional sense information
....

After the fix, dmesg returns below information:
....
usb 5-1: new high speed USB device using ehci_hcd and address 5
usb 5-1: configuration #1 chosen from 1 choice
scsi7 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 5
usb-storage: waiting for device to settle before scanning
usb-storage: device scan complete
scsi 7:0:0:0: Direct-Access     HTS54808 0M9AT00          MG4O PQ: 0 ANSI: 0
sd 7:0:0:0: [sdb] 156301488 512-byte hardware sectors (80026 MB)
sd 7:0:0:0: [sdb] Write Protect is off
sd 7:0:0:0: [sdb] Mode Sense: 03 00 00 00
sd 7:0:0:0: [sdb] Assuming drive cache: write through
sd 7:0:0:0: [sdb] 156301488 512-byte hardware sectors (80026 MB)
sd 7:0:0:0: [sdb] Write Protect is off
sd 7:0:0:0: [sdb] Mode Sense: 03 00 00 00
sd 7:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 7:0:0:0: [sdb] Attached SCSI disk
sd 7:0:0:0: Attached scsi generic sg1 type 0
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.

------=_Part_90575_21848620.1228968091581
Content-Type: text/x-patch; name=fix-argosy-usbdisk.2.6.27.8.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fokvrpi30
Content-Disposition: attachment; filename=fix-argosy-usbdisk.2.6.27.8.patch

ZGlmZiAtTnVycCAyLjYuMjcuOC9kcml2ZXJzL3VzYi9zdG9yYWdlL3VudXN1YWxfZGV2cy5oIDIu
Ni4yNy44LWZpeHVzYi1jbGVhbi9kcml2ZXJzL3VzYi9zdG9yYWdlL3VudXN1YWxfZGV2cy5oCi0t
LSAyLjYuMjcuOC9kcml2ZXJzL3VzYi9zdG9yYWdlL3VudXN1YWxfZGV2cy5oCTIwMDgtMTItMDYg
MDU6MDM6MDIuMDAwMDAwMDAwICswOTAwCisrKyAyLjYuMjcuOC1maXh1c2ItY2xlYW4vZHJpdmVy
cy91c2Ivc3RvcmFnZS91bnVzdWFsX2RldnMuaAkyMDA4LTEyLTEwIDIwOjAwOjMzLjAwMDAwMDAw
MCArMDkwMApAQCAtMTI1OCw2ICsxMjU4LDEzIEBAIFVOVVNVQUxfREVWKCAweDA4NDAsIDB4MDA4
MiwgMHgwMDAxLCAweDAKIAkJVVNfU0NfREVWSUNFLCBVU19QUl9ERVZJQ0UsIE5VTEwsCiAJCVVT
X0ZMX0ZJWF9DQVBBQ0lUWSksCiAKKy8qIFJlcG9ydGVkIGFuZCBwYXRjaGVkIGJ5IE5ndXllbiBB
bmggUXV5bmggPGFxdXluaEBnbWFpbC5jb20+ICovCitVTlVTVUFMX0RFViggMHgwODQwLCAweDAw
ODQsIDB4MDAwMSwgMHgwMDAxLAorCQkiQXJnb3N5IiwKKwkJIlN0b3JhZ2UiLAorCQlVU19TQ19E
RVZJQ0UsIFVTX1BSX0RFVklDRSwgTlVMTCwKKwkJVVNfRkxfRklYX0NBUEFDSVRZKSwKKwogLyog
RW50cnkgYW5kIHN1cHBvcnRpbmcgcGF0Y2ggYnkgVGhlb2RvcmUgS2lsZ29yZSA8a2lsZ290YUBh
dWJ1cm4uZWR1Pi4KICAqIEZsYWcgd2lsbCBzdXBwb3J0IEJ1bGsgZGV2aWNlcyB3aGljaCB1c2Ug
YSBzdGFuZGFyZHMtdmlvbGF0aW5nIDMyLWJ5dGUKICAqIENvbW1hbmQgQmxvY2sgV3JhcHBlci4g
SGVyZSwgdGhlICJEQzJNRUdBIiBjYW1lcmFzIChzZXZlcmFsIGJyYW5kcykgd2l0aAo=
------=_Part_90575_21848620.1228968091581
Content-Type: text/x-patch; name=fix-argosy-usbdisk.linus-git.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fokvsb9j1
Content-Disposition: attachment;
 filename=fix-argosy-usbdisk.linus-git.patch

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3N0b3JhZ2UvdW51c3VhbF9kZXZzLmggYi9kcml2ZXJz
L3VzYi9zdG9yYWdlL3VudXN1YWxfZGV2cy5oCmluZGV4IGU2MWYyYmYuLmM2ZmNhMDcgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvdXNiL3N0b3JhZ2UvdW51c3VhbF9kZXZzLmgKKysrIGIvZHJpdmVycy91
c2Ivc3RvcmFnZS91bnVzdWFsX2RldnMuaApAQCAtMTMwNiw2ICsxMzA2LDEzIEBAIFVOVVNVQUxf
REVWKCAweDA4NDAsIDB4MDA4MiwgMHgwMDAxLCAweDAwMDEsCiAJCVVTX1NDX0RFVklDRSwgVVNf
UFJfREVWSUNFLCBOVUxMLAogCQlVU19GTF9GSVhfQ0FQQUNJVFkpLAogCisvKiBSZXBvcnRlZCBh
bmQgcGF0Y2hlZCBieSBOZ3V5ZW4gQW5oIFF1eW5oIDxhcXV5bmhAZ21haWwuY29tPiAqLworVU5V
U1VBTF9ERVYoIDB4MDg0MCwgMHgwMDg0LCAweDAwMDEsIDB4MDAwMSwKKwkJIkFyZ29zeSIsCisJ
CSJTdG9yYWdlIiwKKwkJVVNfU0NfREVWSUNFLCBVU19QUl9ERVZJQ0UsIE5VTEwsCisJCVVTX0ZM
X0ZJWF9DQVBBQ0lUWSksCisKIC8qIEVudHJ5IGFuZCBzdXBwb3J0aW5nIHBhdGNoIGJ5IFRoZW9k
b3JlIEtpbGdvcmUgPGtpbGdvdGFAYXVidXJuLmVkdT4uCiAgKiBGbGFnIHdpbGwgc3VwcG9ydCBC
dWxrIGRldmljZXMgd2hpY2ggdXNlIGEgc3RhbmRhcmRzLXZpb2xhdGluZyAzMi1ieXRlCiAgKiBD
b21tYW5kIEJsb2NrIFdyYXBwZXIuIEhlcmUsIHRoZSAiREMyTUVHQSIgY2FtZXJhcyAoc2V2ZXJh
bCBicmFuZHMpIHdpdGgK
------=_Part_90575_21848620.1228968091581--
