Return-Path: <linux-kernel-owner+w=401wt.eu-S965125AbXAYBuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965125AbXAYBuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 20:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965134AbXAYBuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 20:50:10 -0500
Received: from wx-out-0506.google.com ([66.249.82.228]:28066 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965125AbXAYBuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 20:50:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=cEDHBGl/pBUOiPtN56xtUSNYa6ti42iYsblDRNX/4M/oK20fXlcDa0xjB3gAaMEifaxG2SZCq6Xlz+HAB1Pv048jfZ2NqVQcw6oRtElsFc9YExOdetTV9jMkADPcQqQ7xYd0jGMeimAMApztRC6H0XczSllkBB1+sipKIjmgVWw=
Message-ID: <806dafc20701241750t53b86babn36831cadc7dfa76c@mail.gmail.com>
Date: Wed, 24 Jan 2007 20:50:06 -0500
From: "Christopher \"Monty\" Montgomery" <xiphmont@gmail.com>
To: perex@suse.cz, greg@kroah.com, mclasen@redhat.com, jrb@redhat.com,
       "Lennart Poettering" <lennart@poettering.net>,
       "Pierre Ossman" <drzeus@drzeus.cx>
Subject: [PATCH] alsa: correct nonsensical sysfs device symlinks
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       fedora-desktop-list@redhat.com
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_22370_7986218.1169689806841"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_22370_7986218.1169689806841
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch was generated against 2.6.20-rc5; it fixes a bug that
cropped up in a late 2.6.19-mm kernel.

When ALSA's sysfs device creation was converted from using
class_device_create() to device_create(), the fourth param from
class_device_create() [dev] was simply plugged into arg 2 of
device_create().  This causes the device symlinks under all the
class/sound/[node] to point to nonsensical places.  Among other
problems, this breaks HAL and all audio software that depends on HAL.

The nature of this bug is not simply a need to update HAL;
class/[node]/device symlinks are required to point to a device entry
in /sys/devices; the bug causes them to point to other places within
/sys/class.  This patch is [hopefully] a trivial change to restore the
desired behavior.

Signed-off-by: Monty Montgomery <xiphmont@gmail.com>
---

Apologies for sending patch as text/plain attachment; we've
established in the past that Gmail will not leave unformatted text
email unmunged.

------=_Part_22370_7986218.1169689806841
Content-Type: text/plain; name=alsa-sysfs-fix-2.6.20-rc5.txt; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_excl92c0
Content-Disposition: attachment; filename="alsa-sysfs-fix-2.6.20-rc5.txt"

ZGlmZiAtdXByTiAtWCBsaW51eC0yLjYuMjAtcmM1L0RvY3VtZW50YXRpb24vZG9udGRpZmYgbGlu
dXgtMi42LjIwLXJjNS9zb3VuZC9jb3JlL3NvdW5kLmMgbGludXgtMi42LjIwLXJjNS1tb250eS9z
b3VuZC9jb3JlL3NvdW5kLmMKLS0tIGxpbnV4LTIuNi4yMC1yYzUvc291bmQvY29yZS9zb3VuZC5j
CTIwMDctMDEtMTIgMTM6NTQ6MjYuMDAwMDAwMDAwIC0wNTAwCisrKyBsaW51eC0yLjYuMjAtcmM1
LW1vbnR5L3NvdW5kL2NvcmUvc291bmQuYwkyMDA3LTAxLTI0IDIwOjMwOjA3LjAwMDAwMDAwMCAt
MDUwMApAQCAtMjY1LDcgKzI2NSw5IEBAIGludCBzbmRfcmVnaXN0ZXJfZGV2aWNlKGludCB0eXBl
LCBzdHJ1Y3QKIAlzbmRfbWlub3JzW21pbm9yXSA9IHByZWc7CiAJaWYgKGNhcmQpCiAJCWRldmlj
ZSA9IGNhcmQtPmRldjsKLQlwcmVnLT5kZXYgPSBkZXZpY2VfY3JlYXRlKHNvdW5kX2NsYXNzLCBk
ZXZpY2UsIE1LREVWKG1ham9yLCBtaW5vciksCisJcHJlZy0+ZGV2ID0gZGV2aWNlX2NyZWF0ZShz
b3VuZF9jbGFzcywgCisJCQkJICAoZGV2aWNlP2RldmljZS0+cGFyZW50Ok5VTEwpLCAKKwkJCQkg
IE1LREVWKG1ham9yLCBtaW5vciksCiAJCQkJICAiJXMiLCBuYW1lKTsKIAlpZiAocHJlZy0+ZGV2
KQogCQlkZXZfc2V0X2RydmRhdGEocHJlZy0+ZGV2LCBwcml2YXRlX2RhdGEpOwo=
------=_Part_22370_7986218.1169689806841--
