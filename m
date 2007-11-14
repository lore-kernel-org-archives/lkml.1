Return-Path: <linux-kernel-owner+w=401wt.eu-S1757143AbXKNDzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbXKNDzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 22:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbXKNDyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 22:54:49 -0500
Received: from smtp114.sbc.mail.mud.yahoo.com ([68.142.198.213]:20707 "HELO
	smtp114.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756644AbXKNDyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 22:54:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0DDuFLRaLP5KePeawt7h4lcq0J8Qa5+2b0ntQHTiit5cfquUec97l9YBYvAsNsdxTzYFK5gfiuy/boNePk7QnXJorv6zODPRfhX4Z3TiXvJaeqbOk2Y4vzMYnLBYWa2qd9us9VOWIhNTtQHHdMixnXRCTkyHol0Gm40laX+F8CI=  ;
X-YMail-OSG: 2BdHjAEVM1myTgMbydqG786lNdsr2W6iDX6ulOqeCh.72b0MZaFMOy0y_XJMmzsGVqsZb8Z4uDsuUGQV6uqSOb0WqOmhyiKAH7G3XzOpT48J45WyG8s-
From: David Brownell <david-b@pacbell.net>
To: "eric miao" <eric.y.miao@gmail.com>
Subject: Re: [patch/rfc 1/4] GPIO implementation framework
Date: Tue, 13 Nov 2007 19:53:40 -0800
User-Agent: KMail/1.9.6
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Jean Delvare" <khali@linux-fr.org>,
       "Kevin Hilman" <khilman@mvista.com>, "Paul Mundt" <lethal@linux-sh.org>,
       "Ben Dooks" <ben@trinity.fluff.org>
References: <200710291809.29936.david-b@pacbell.net> <f17812d70711131700n74236a8naa6dbfc5cb62e42d@mail.gmail.com> <200711131925.11734.david-b@pacbell.net>
In-Reply-To: <200711131925.11734.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200711131953.41752.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007, David Brownell wrote:
>   http://marc.info/?l=linux-kernel&m=119463810905330&w=2
>   http://marc.info/?l=linux-kernel&m=119463811005344&w=2
>   http://marc.info/?l=linux-kernel&m=119463811105352&w=2
> 
> Plus the appended tweak. 

-ENOPATCH ... ;)

==========
Minor fixups to the gpiolib code.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 lib/gpiolib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- g26.orig/lib/gpiolib.c	2007-11-12 15:06:45.000000000 -0800
+++ g26/lib/gpiolib.c	2007-11-12 15:07:36.000000000 -0800
@@ -28,7 +28,7 @@
 #define	extra_checks	0
 #endif
 
-/* gpio_lock protects the table of chips and to gpio_chip->requested.
+/* gpio_lock protects the table of chips and gpio_chip->requested.
  * While any gpio is requested, its gpio_chip is not removable.  It's
  * a raw spinlock to ensure safe access from hardirq contexts, and to
  * shrink bitbang overhead:  per-bit preemption would be very wrong.
@@ -533,6 +533,6 @@ static int __init gpiolib_debugfs_init(v
 				NULL, NULL, &gpiolib_operations);
 	return 0;
 }
-postcore_initcall(gpiolib_debugfs_init);
+subsys_initcall(gpiolib_debugfs_init);
 
 #endif	/* DEBUG_FS */

