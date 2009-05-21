Return-Path: <linux-kernel-owner+w=401wt.eu-S1753048AbZEUFmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbZEUFmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 01:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbZEUFmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 01:42:46 -0400
Received: from mail-px0-f171.google.com ([209.85.216.171]:48436 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZEUFmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 01:42:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=XIkB8vtwnIVUBD9qTbRGlPWGmhfJG1G+NkRdstQ1pPavsOM4+xDIiQo0SDKH8SN+0h
         G+uhxfzwEpPv2LzJO8LwZjbaHieoI2vevFE3uCRZXZkT+gEAONFfwa8vQMO8OljltLk/
         BoHsxzBgiOovjCKWgJNIwg0HsBOc2ItLE0CvE=
MIME-Version: 1.0
Date: Thu, 21 May 2009 13:34:33 +0800
Message-ID: <3877989d0905202234o24b973a8ge8a074ea79ccac51@mail.gmail.com>
Subject: [patch] can't switch to jiffies clocksource
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001636e0ae5eb8924a046a657f9a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636e0ae5eb8924a046a657f9a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

As this bug https://bugzilla.redhat.com/show_bug.cgi?id=496028,
echo jiffies > clocksource0/current_clocksource make system crash.
I reproduced the problem with upstream kernel.
The root cause is that jiffies is just a variable in memory,
it relies on other clock source to tick , and it never ticks on itself.

Please review, and apply.

**The patch is enclosed in text attachment*
**Using web client to send the patch* *
**below is for review, please apply attached  patch*/

Thanks,
Luming


Signed-off-by: Yu Luming <luming.yu@intel.com>

 clocksource.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


iff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index ecfd7b5..bdffe43 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -507,8 +507,9 @@ static ssize_t sysfs_override_clocksource(struct
sys_device *dev,
 		/* try to select it: */
 		list_for_each_entry(cs, &clocksource_list, list) {
 			if (strlen(cs->name) == len &&
-			    !strcmp(cs->name, override_name))
-				ovr = cs;
+			    !strcmp(cs->name, override_name) &&
+				cs != &clocksource_jiffies)
+					ovr = cs;
 		}
 	}

--001636e0ae5eb8924a046a657f9a
Content-Type: application/octet-stream; name="1.patch"
Content-Disposition: attachment; filename="1.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fuz0y6x30

ZGlmZiAtLWdpdCBhL2tlcm5lbC90aW1lL2Nsb2Nrc291cmNlLmMgYi9rZXJuZWwvdGltZS9jbG9j
a3NvdXJjZS5jCmluZGV4IGVjZmQ3YjUuLmJkZmZlNDMgMTAwNjQ0Ci0tLSBhL2tlcm5lbC90aW1l
L2Nsb2Nrc291cmNlLmMKKysrIGIva2VybmVsL3RpbWUvY2xvY2tzb3VyY2UuYwpAQCAtNTA3LDgg
KzUwNyw5IEBAIHN0YXRpYyBzc2l6ZV90IHN5c2ZzX292ZXJyaWRlX2Nsb2Nrc291cmNlKHN0cnVj
dCBzeXNfZGV2aWNlICpkZXYsCiAJCS8qIHRyeSB0byBzZWxlY3QgaXQ6ICovCiAJCWxpc3RfZm9y
X2VhY2hfZW50cnkoY3MsICZjbG9ja3NvdXJjZV9saXN0LCBsaXN0KSB7CiAJCQlpZiAoc3RybGVu
KGNzLT5uYW1lKSA9PSBsZW4gJiYKLQkJCSAgICAhc3RyY21wKGNzLT5uYW1lLCBvdmVycmlkZV9u
YW1lKSkKLQkJCQlvdnIgPSBjczsKKwkJCSAgICAhc3RyY21wKGNzLT5uYW1lLCBvdmVycmlkZV9u
YW1lKSAmJgorCQkJCWNzICE9ICZjbG9ja3NvdXJjZV9qaWZmaWVzKQorCQkJCQlvdnIgPSBjczsK
IAkJfQogCX0KIAo=
--001636e0ae5eb8924a046a657f9a--
