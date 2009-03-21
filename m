Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbZCUWBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbZCUWBW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 18:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbZCUWBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 18:01:11 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:59632 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbZCUWBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 18:01:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l+EoFovRxJVHwsf/28NiHsj/JoNzS3oqS75Kge6zRoCNotiWlnkanZTkbvzmTFVbR6
         znzHMmc96xPGeo5W55iV49XaOOISfKGuQWAaDb1gY+1MnjZk6AhVxub+kYWwdircuUvf
         07TvVdGDDWuPuymWtG7PbGp+kcwB+kpLGKbWY=
MIME-Version: 1.0
In-Reply-To: <20090317220251.d6fb00ff.krzysztof.h1@poczta.fm>
References: <46e1c7760901230433i3045f273oa109ce97e790bca3@mail.gmail.com>
	 <Pine.LNX.4.64.0901240951110.13803@anakin>
	 <46e1c7760901240109m5a0f3a85p788aa3ce35b49fa9@mail.gmail.com>
	 <Pine.LNX.4.64.0901241425310.13803@anakin>
	 <46e1c7760901240649v1e45bbb1v8c9997f236a3ec4c@mail.gmail.com>
	 <46e1c7760902101337qe239336n9ef2652a47f89aed@mail.gmail.com>
	 <46e1c7760902101350r5a04d076j49cc611a843e6429@mail.gmail.com>
	 <20090211142409.b88c577e.akpm@linux-foundation.org>
	 <20090317220251.d6fb00ff.krzysztof.h1@poczta.fm>
Date: Sun, 22 Mar 2009 00:01:06 +0200
Message-ID: <46e1c7760903211501s41a05aeei8bf8cf82d3261e9e@mail.gmail.com>
Subject: Re: [PATCH] fb: hide hardware cursor in graphics mode (Mach64)
From: Risto Suominen <risto.suominen@gmail.com>
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: linux-fbdev-devel@lists.sourceforge.net, geert@linux-m68k.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Helt <krzysztof.h1@wp.pl>

A hardware cursor is left enabled in
the fb_set_par() which is called when
a new console is created. This is
inconsistent with software cursor's
behaviour.

Also, this makes a hardware cursor
always visible in the Xfbdev
(Xorg kdrive) server.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Tested-by: Risto Suominen <Risto.Suominen@gmail.com>
---
Well done, Krzysztof. It solves the problem on my three computers
using the mach64 chip: PowerMac 5500, PowerMac G3 Beige, and a PC with
Mach64 GZ card.

 drivers/video/aty/mach64_accel.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/video/aty/mach64_accel.c b/drivers/video/aty/mach64_accel.c
index a8f60c3..0cc9724 100644
--- a/drivers/video/aty/mach64_accel.c
+++ b/drivers/video/aty/mach64_accel.c
@@ -39,7 +39,8 @@ void aty_reset_engine(const struct atyfb_par *par)
 {
       /* reset engine */
       aty_st_le32(GEN_TEST_CNTL,
-               aty_ld_le32(GEN_TEST_CNTL, par) & ~GUI_ENGINE_ENABLE, par);
+               aty_ld_le32(GEN_TEST_CNTL, par) &
+               ~(GUI_ENGINE_ENABLE | HWCURSOR_ENABLE), par);
       /* enable engine */
       aty_st_le32(GEN_TEST_CNTL,
               aty_ld_le32(GEN_TEST_CNTL, par) | GUI_ENGINE_ENABLE, par);
--
1.5.2.2
