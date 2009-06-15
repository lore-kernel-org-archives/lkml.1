Return-Path: <linux-kernel-owner+w=401wt.eu-S1757626AbZFOJN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626AbZFOJN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbZFOJNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:13:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:2511 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbZFOJNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:13:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=vKYozXvWRFR6+n9zeMt2fd8HbR5Kp7ctP7moqXr14s98mbsoPAiMp6YSStawMmr+ET
         +CgKgtF8y4DgAFl4nKCf0d0MP/0H2RJit3U7jd1w56rmSEuVZP+Asesca7nzbDiDSqhp
         D5NVTzxx0W8xAIJSvX4fWXVXiUcR3xNy5xBqE=
MIME-Version: 1.0
Date: Mon, 15 Jun 2009 11:07:38 +0200
Message-ID: <9a518b600906150207l1be4c0e4w6e2ec2ece6b89181@mail.gmail.com>
Subject: [PATCH] force key-release events for Samsung p560 and r560 laptops in 
	atkbd.c
From: Gordon <gkoefner@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0cd29b4cc8c50b046c5f6394
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd29b4cc8c50b046c5f6394
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi all,
certain FN keys on the Samsung P560 and R560 laptops do not produce
"unknown key pressed" events in dmesg. But if I use setkeycodes to
make them known the keyboard gets 'stuck'. These keys seem to not send
keyrelease events.

Attached is a patch for the SAMSUNG P560 laptop, the DMI match just
needs to be modified to work for the R560 model as well. keycodes are
afaik (a colleague has the R560) the same for both. I modified an
existing patch for the NC10 from bugzilla as it is basically the same
problem.

Thread:
http://bugzilla.kernel.org/show_bug.cgi?id=3D12021

and here is my bug report:
https://bugs.launchpad.net/ubuntu/+source/hal-info/+bug/338182

I hope someone can include this patch into newer releases of the kernel :)

with best regards,
Gordon K=F6fner

--000e0cd29b4cc8c50b046c5f6394
Content-Type: text/x-patch; charset=US-ASCII; name="atkbd-samsung-p560.patch"
Content-Disposition: attachment; filename="atkbd-samsung-p560.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fvyy23a40

LS0tIGxpbnV4LTIuNi4yOC1vbGQvZHJpdmVycy9pbnB1dC9rZXlib2FyZC9hdGtiZC5jCTIwMDgt
MTItMTMgMjM6NTI6MjYuMDAwMDAwMDAwICswMDAwCisrKyBsaW51eC0yLjYuMjgvZHJpdmVycy9p
bnB1dC9rZXlib2FyZC9hdGtiZC5jCTIwMDgtMTItMTQgMTg6MTY6MjMuMDAwMDAwMDAwICswMDAw
CkBAIC04ODQsNiArODg0LDIxIEBAIHN0YXRpYyB2b2lkIGF0a2JkX2ludmVudGVjX2tleW1hcF9m
aXh1cCgKIH0KIAogLyoKKyAqIFNhbXN1bmcgUDU2MCB3aXRoIEZuK0Y/IGtleSByZWxlYXNlIG5v
dCB3b3JraW5nCisgKi8KK3N0YXRpYyB2b2lkIGF0a2JkX3NhbXN1bmdfa2V5bWFwX2ZpeHVwKHN0
cnVjdCBhdGtiZCAqYXRrYmQpCit7CisJY29uc3QgdW5zaWduZWQgaW50IGZvcmNlZF9yZWxlYXNl
X2tleXNbXSA9IHsKKwkJMHg4MiwgMHg4MywgMHg4NCwgMHg4NiwgMHg4OCwgMHg4OSwgMHhiMSwg
MHhiMywgMHhmNworCX07CisJaW50IGk7CisJaWYgKGF0a2JkLT5zZXQgPT0gMikKKwkJZm9yIChp
ID0gMDsgaSA8IEFSUkFZX1NJWkUoZm9yY2VkX3JlbGVhc2Vfa2V5cyk7IGkrKykKKwkJCV9fc2V0
X2JpdChmb3JjZWRfcmVsZWFzZV9rZXlzW2ldLAorCQkJCWF0a2JkLT5mb3JjZV9yZWxlYXNlX21h
c2spOworfQorCisvKgogICogYXRrYmRfc2V0X2tleWNvZGVfdGFibGUoKSBpbml0aWFsaXplcyBr
ZXlib2FyZCdzIGtleWNvZGUgdGFibGUKICAqIGFjY29yZGluZyB0byB0aGUgc2VsZWN0ZWQgc2Nh
bmNvZGUgc2V0CiAgKi8KQEAgLTE0OTMsNiArMTUwOCwxNSBAQCBzdGF0aWMgc3RydWN0IGRtaV9z
eXN0ZW1faWQgYXRrYmRfZG1pX3F1CiAJCS5jYWxsYmFjayA9IGF0a2JkX3NldHVwX2ZpeHVwLAog
CQkuZHJpdmVyX2RhdGEgPSBhdGtiZF9pbnZlbnRlY19rZXltYXBfZml4dXAsCiAJfSwKKwl7CisJ
CS5pZGVudCA9ICJTYW1zdW5nIFA1NjAiLAorCQkubWF0Y2hlcyA9IHsKKwkJCURNSV9NQVRDSChE
TUlfU1lTX1ZFTkRPUiwgIlNBTVNVTkcgRUxFQ1RST05JQ1MgQ08uLCBMVEQuIiksCisJCQlETUlf
TUFUQ0goRE1JX1BST0RVQ1RfTkFNRSwgIlA1NjAiKSwKKwkJfSwKKwkJLmNhbGxiYWNrID0gYXRr
YmRfc2V0dXBfZml4dXAsCisJCS5kcml2ZXJfZGF0YSA9IGF0a2JkX3NhbXN1bmdfa2V5bWFwX2Zp
eHVwLAorCX0sCiAJeyB9CiB9OwogCg==
--000e0cd29b4cc8c50b046c5f6394--
