Return-Path: <linux-kernel-owner+w=401wt.eu-S1751764AbYH2BZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbYH2BZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 21:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbYH2BZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 21:25:23 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:55583 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbYH2BZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 21:25:22 -0400
Date: Thu, 28 Aug 2008 18:22:01 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Anton Vorontsov <avorontsov@ru.mvista.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] leds: make the default trigger name const
In-Reply-To: <20080728095309.GA31809@polina.dev.rtsoft.ru>
Message-ID: <Pine.LNX.4.64.0808281818400.3610@t2.domain.actdsltmp>
References: <Pine.LNX.4.64.0807181339500.10116@t2.domain.actdsltmp>
 <1217019705-24244-1-git-send-email-tpiepho@freescale.com>
 <20080727020857.GM12191@secretlab.ca> <20080727231149.1b2508da.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0807271304350.26456@t2.domain.actdsltmp>
 <20080728095309.GA31809@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default_trigger fields of struct gpio_led and thus struct led_classdev
are pretty much always assigned from a string literal, which means the
string can't be modified.  Which is fine, since there is no reason to
modify the string and in fact it never is.

But they should be marked const to prevent such code from being added, to
prevent warnings if -Wwrite-strings is used and when assigned from a
constant string other than a string literal (which produces a warning under
current kernel compiler flags), and for general good coding practices.

Signed-off-by: Trent Piepho <tpiepho@freescale.com>
---
Reposting this again.  It still applies to powerpc-next as of Aug 28 and I
don't think anyone had any problems with it.

  include/linux/leds.h |    4 ++--
  1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/leds.h b/include/linux/leds.h
index d41ccb5..d3a73f5 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -123,7 +123,7 @@ extern void ledtrig_ide_activity(void);
   */
  struct led_info {
  	const char	*name;
-	char		*default_trigger;
+	const char	*default_trigger;
  	int		flags;
  };

@@ -135,7 +135,7 @@ struct led_platform_data {
  /* For the leds-gpio driver */
  struct gpio_led {
  	const char *name;
-	char *default_trigger;
+	const char *default_trigger;
  	unsigned 	gpio;
  	u8 		active_low;
  };
-- 
1.5.4.3

