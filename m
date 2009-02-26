Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbZBZI6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbZBZI6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 03:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbZBZI6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 03:58:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61861 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbZBZI6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 03:58:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH] fix duplicate include in emu10k1.h
Date: Thu, 26 Feb 2009 09:57:27 +0100
User-Agent: KMail/1.9.9
References: <tip-57b4b9d7b56d283b6619a893341be16d1a0467a6@kernel.org> <s5h4oyhk2j5.wl%tiwai@suse.de>
In-Reply-To: <s5h4oyhk2j5.wl%tiwai@suse.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
Cc: hpa@zytor.com, mingo@redhat.com, dwmw2@infradead.org,
       acme@ghostprotocols.net, airlied@linux.ie, perex@perex.cz,
       yoshfuji@linux-ipv6.org, mchehab@redhat.com, arnd@arndb.de,
       tglx@linutronix.de, hpa@linux.intel.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902260957.30007.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18NNe2ftw32ixSrylNZyaaj/VdQVHLd8Qm6xR1
 xCPGwi/3tcEoEhAyYbRBLVIReZuM04OIcwyvYYuJ8qmFnS3KhR
 U7rflxRD77EER0mCG4QYw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The earlier patch 'make most exported headers use strict integer types'
accidentally includes <types.h> both from the common and from the
kernel-only parts.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---
On Thursday 26 February 2009, you wrote:

> > @@ -34,6 +36,8 @@
> >  #include <sound/timer.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/mutex.h>
> > +#include <linux/types.h>
> > +
> 
> Isn't the second inclusion superfluous?
> 
Yes, I must have introduced the second one first, but in the
wrong section (kernel only), and then didn't notice it when
introducing it again to fix headers_check.

--- a/include/sound/emu10k1.h
+++ b/include/sound/emu10k1.h
@@ -36,7 +36,6 @@
 #include <sound/timer.h>
 #include <linux/interrupt.h>
 #include <linux/mutex.h>
-#include <linux/types.h>
 
 #include <asm/io.h>
 
