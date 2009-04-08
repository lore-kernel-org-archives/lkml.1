Return-Path: <linux-kernel-owner+w=401wt.eu-S1760982AbZDHAwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760982AbZDHAwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 20:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758328AbZDHAvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 20:51:52 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:46207 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757048AbZDHAvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 20:51:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KjkeXlKJRt3tFxblUoHHl1qBWAh2ldp0TGDhDTML7Mx6+ZQbHsDbSKU9+wIz9TICs9ANE8SMPOomNfxLs+I5ZuG9nCLIddyulEEpJHCIIKM48xiDA232ZD541vZWrKMTVTU/3gNiOkzPCGDWf+2H+en6Uz09wEN8KzV79UJEh9g=  ;
X-YMail-OSG: h1SSWrIVM1kSBytmw.ySFzn2SmsteVQhLUoGjTED.sjU.Z3V29C.fcWZa..eLg5cG94.17FFqa5OHdR4GFDvbDbmdfXg99NGaI0RxPtA4w5UidgiSu6a6gU6KSQImZkxinfQenXVlMceqwJIXyxoAbNioOERb3YiC0PXx6w6LvzhQXmJbOL_XCoEVUHaCw3.IA.eBsCBpFfdAN5O1_FJnG4KeZAqmObNX_WkJJvpZHgVx1wlt4HOT7PBq8w0ZD_18.PyVi8ZchD_De70T3EV2K_0KkbQWU0A18JkwJL0Yv87Z3a_Q2zsHTExlECGOSzDUUBl0fK9VVapCsdRyWQ4B2.I4Fu6gw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: leds: just ignore invalid GPIOs in leds-gpio
Date: Tue, 7 Apr 2009 17:51:49 -0700
User-Agent: KMail/1.9.10
Cc: Richard Purdie <rpurdie@linux.intel.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
References: <200904062059.n36Kxlum026774@hera.kernel.org> <alpine.LRH.2.00.0904071359010.23019@vixen.sonytel.be>
In-Reply-To: <alpine.LRH.2.00.0904071359010.23019@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904071751.49507.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 April 2009, Geert Uytterhoeven wrote:
> | drivers/leds/leds-gpio.c:85: warning: 'return' with no value, in function
> | returning non-void
> 
> So what should we return here? -ENODEV? -EINVAL? Anything else?

Success:  0.  The point is to ignore them, not fail!


See the appended.

- Dave

========== CUT HERE
From: David Brownell <dbrownell@users.sourceforge.net>

Fix build problems with leds-gpio:

  CC      drivers/leds/leds-gpio.o
drivers/leds/leds-gpio.c: In function 'create_gpio_led':
drivers/leds/leds-gpio.c:85: warning: 'return' with no value, in function returning non-void

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

---
 drivers/leds/leds-gpio.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -82,7 +84,7 @@ static int __devinit create_gpio_led(con
 	if (!gpio_is_valid(template->gpio)) {
 		printk(KERN_INFO "Skipping unavilable LED gpio %d (%s)\n", 
 				template->gpio, template->name);
-		return;
+		return 0;
 	}
 
 	ret = gpio_request(template->gpio, template->name);

