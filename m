Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbYIDWUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbYIDWUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 18:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbYIDWUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 18:20:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:22815 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbYIDWUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 18:20:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=rYM4CEkkfoRetAldQ1CmbppTbcObkhVcj7AKPfye+liiql+7hrJzKWn2Rp423CtVHU
         9kx4leWvGJxwQdsCj/iSkte/VLZb/FAB5xFTgoYoHZIHdPz0XcuGZ5SfqpvGoK/2aCy2
         iGMlbO5fer89H44GInryO6cc/GB9gOzSlx3Ek=
Message-ID: <48C05F2B.1030608@gmail.com>
Date: Fri, 05 Sep 2008 00:20:27 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: HID: make compat functions static
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

does the hid-dummy module runtime-link after the change?

ANSI C standard says:
* In the set of translation units and libraries that constitutes an entire
program, each declaration of a particular identiﬁer with external linkage
denotes the same object or function. Within one translation unit, each
declaration of an identiﬁer with _internal linkage_ denotes the same object or
function. Each declaration of an identiﬁer with no linkage denotes a unique entity.
* If the declaration of a ﬁle scope identiﬁer for an object or a function
contains the storage-class speciﬁer _static_, the identiﬁer has _internal linkage_.
* For an identiﬁer declared with the storage-class speciﬁer _extern_ in a scope
in which a _prior declaration_ of that identiﬁer is visible, if the prior
declaration speciﬁes _internal_ or external linkage, the linkage of the
identiﬁer at the later declaration _is the same as the linkage speciﬁed at the
prior declaration_. If no prior declaration is visible, or if the prior
declaration speciﬁes no linkage, then the identiﬁer has external linkage.

(Note that EXPORT_SYMBOL adds extern.)

I can't find any extension of gnu C to this which would permit that so I think
and correct me if I'm wrong, the commit is incorrect? Even according to nm, the
symbol is local, e.g.:
0000000000000120 t hid_compat_monterey

From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Tue, 2 Sep 2008 16:05:43 +0000 (+0200)
Subject: HID: make compat functions static
X-Git-Url:
http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fjikos%2Fhid.git;a=commitdiff_plain;h=f72f87666264c9d4880166bcc69cb5c4cf210449

HID: make compat functions static

Done to avoid sparse warnings about undeclared functions.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---

diff --git a/include/linux/hid.h b/include/linux/hid.h
index 15ee33e..164ce7f 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -794,7 +794,7 @@ dbg_hid(const char *fmt, ...)

 #ifdef CONFIG_HID_COMPAT
 #define HID_COMPAT_LOAD_DRIVER(name)	\
-void hid_compat_##name(void) { }	\
+static void hid_compat_##name(void) { }	\
 EXPORT_SYMBOL(hid_compat_##name)
 #else
 #define HID_COMPAT_LOAD_DRIVER(name)
