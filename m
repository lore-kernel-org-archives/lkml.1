Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbYF1TmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbYF1TmR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 15:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbYF1TmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 15:42:06 -0400
Received: from smtp.nokia.com ([192.100.122.233]:48504 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYF1TmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 15:42:05 -0400
Message-ID: <48669252.1000608@nokia.com>
Date: Sat, 28 Jun 2008 22:34:42 +0300
From: "Becker Stefan (Nokia-D/Salo)" <Stefan.Becker@nokia.com>
Organization: Nokia Devices
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
CC: ext Alan Stern <stern@rowland.harvard.edu>
Subject: BUG in 2.6.26-rc8 interrupt handling
References: <Pine.LNX.4.44L0.0806281241200.23326-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0806281241200.23326-100000@netrider.rowland.org>
Content-Type: multipart/mixed;
 boundary="------------080105020509080100060708"
X-OriginalArrivalTime: 28 Jun 2008 19:35:28.0630 (UTC) FILETIME=[1EBEE160:01C8D956]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080105020509080100060708
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

[I'm not subscribed to this list, so please CC: me]

[Subject has been changed, please read the rest of the thread for all 
the details]

On my AthlonXP single CPU laptop I experience random lockups when I 
access the external USB harddrive with kernels >2.6.23. The problem 
doesn't appear with 2.6.23.

Debugging revealed that a routine was called twice that takes a 
spinlock. But this actually shouldn't happen, because the function 
should only be invoked with interrupts disabled. A little more debugging 
revealed that apparently sometimes interrupts are enabled when the USB 
HCD interrupt handlers are called, although they are registered with 
IRQF_DISABLED.

With the attached patch ontop of 2.6.26-rc8 I get these messages:

kernel: USB_HCD_IRQ interrupts disabled 14206 enabled 6289
kernel: USB_HCD_IRQ interrupts disabled 14761 enabled 6290
kernel: USB_HCD_IRQ interrupts disabled 14761 enabled 6291

I also attached the contents from /proc/interrupts from the machine.

Any ideas what could be wrong or any suggestions in which direction I 
should continue debugging?

Regards,

	Stefan

---
Stefan Becker   Nokia-TP/Salo            Senior Specialist, EE SW
E-Mail: Stefan.Becker@nokia.com          SMS: 4871554@???.??
Office: +358-7180-71554                  FAX: +358-7180-44751
GSM   : +358-50-4871554

--------------080105020509080100060708
Content-Type: text/plain;
 name="usb-hcd-interrupts.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="usb-hcd-interrupts.patch"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2NvcmUvaGNkLmMgYi9kcml2ZXJzL3VzYi9jb3Jl
L2hjZC5jCmluZGV4IDA5YTUzZTcuLjU4MTRjNWEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvdXNi
L2NvcmUvaGNkLmMKKysrIGIvZHJpdmVycy91c2IvY29yZS9oY2QuYwpAQCAtMTY4Niw2ICsx
Njg2LDE4IEBAIGlycXJldHVybl90IHVzYl9oY2RfaXJxIChpbnQgaXJxLCB2b2lkICpfX2hj
ZCkKIAlzdHJ1Y3QgdXNiX2hjZAkJKmhjZCA9IF9faGNkOwogCWludAkJCXN0YXJ0ID0gaGNk
LT5zdGF0ZTsKIAorI2lmZGVmIERFQlVHCisJc3RhdGljIHVuc2lnbmVkIGludCBfZW5hYmxl
ZCAgPSAwOworCXN0YXRpYyB1bnNpZ25lZCBpbnQgX2Rpc2FibGVkID0gMDsKKwlpZiAocmF3
X2lycXNfZGlzYWJsZWQoKSkgeworCQlfZGlzYWJsZWQrKzsKKwl9IGVsc2UgeworCQlfZW5h
YmxlZCsrOworCQlwcmludGsoS0VSTl9DUklUICJVU0JfSENEX0lSUSBpbnRlcnJ1cHRzIGRp
c2FibGVkICVkIGVuYWJsZWQgJWRcbiIsCisJCSAgICAgICBfZGlzYWJsZWQsIF9lbmFibGVk
KTsKKwl9CisjZW5kaWYKKwogCWlmICh1bmxpa2VseShzdGFydCA9PSBIQ19TVEFURV9IQUxU
IHx8CiAJICAgICF0ZXN0X2JpdChIQ0RfRkxBR19IV19BQ0NFU1NJQkxFLCAmaGNkLT5mbGFn
cykpKQogCQlyZXR1cm4gSVJRX05PTkU7Cg==
--------------080105020509080100060708
Content-Type: text/plain;
 name="proc-interrupts.txt"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="proc-interrupts.txt"

ICAgICAgICAgICBDUFUwICAgICAgIAogIDA6ICAgICAgMzE5MDQgICAgWFQtUElDLVhUICAg
ICAgICB0aW1lcgogIDE6ICAgICAgICAxMTIgICAgWFQtUElDLVhUICAgICAgICBpODA0Mgog
IDI6ICAgICAgICAgIDAgICAgWFQtUElDLVhUICAgICAgICBjYXNjYWRlCiAgNTogICAgICAg
ICAgMSAgICBYVC1QSUMtWFQgICAgICAgIGZpcmV3aXJlX29oY2ksIFZJQTgyMzMsIFZJQTgy
WFgtTU9ERU0KICA2OiAgICAgICAgICAxICAgIFhULVBJQy1YVCAgICAgIAogIDc6ICAgICAg
ICAgIDAgICAgWFQtUElDLVhUICAgICAgICBwYXJwb3J0MAogIDk6ICAgICAgICAgNTIgICAg
WFQtUElDLVhUICAgICAgICBhY3BpCiAxMDogICAgICAgICAyMSAgICBYVC1QSUMtWFQgICAg
ICAgIHVoY2lfaGNkOnVzYjIKIDExOiAgICAgICAgIDM2ICAgIFhULVBJQy1YVCAgICAgICAg
eWVudGEsIGVoY2lfaGNkOnVzYjEsIHVoY2lfaGNkOnVzYjMKIDEyOiAgICAgICAgMTIwICAg
IFhULVBJQy1YVCAgICAgICAgaTgwNDIKIDE0OiAgICAgICAxOTU5ICAgIFhULVBJQy1YVCAg
ICAgICAgcGF0YV92aWEKIDE1OiAgICAgICAgIDM5ICAgIFhULVBJQy1YVCAgICAgICAgcGF0
YV92aWEKTk1JOiAgICAgICAgICAwICAgTm9uLW1hc2thYmxlIGludGVycnVwdHMKTE9DOiAg
ICAgICAgICAwICAgTG9jYWwgdGltZXIgaW50ZXJydXB0cwpSRVM6ICAgICAgICAgIDAgICBS
ZXNjaGVkdWxpbmcgaW50ZXJydXB0cwpDQUw6ICAgICAgICAgIDAgICBmdW5jdGlvbiBjYWxs
IGludGVycnVwdHMKVExCOiAgICAgICAgICAwICAgVExCIHNob290ZG93bnMKVFJNOiAgICAg
ICAgICAwICAgVGhlcm1hbCBldmVudCBpbnRlcnJ1cHRzClNQVTogICAgICAgICAgMCAgIFNw
dXJpb3VzIGludGVycnVwdHMKRVJSOiAgICAgICAgICAwCk1JUzogICAgICAgICAgMAo=
--------------080105020509080100060708--
