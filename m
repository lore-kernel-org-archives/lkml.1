Return-Path: <linux-kernel-owner+w=401wt.eu-S1759912AbYCUREZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912AbYCUREZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 13:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757438AbYCUREN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:04:13 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:21357 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755878AbYCUREL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:04:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=6FBGHeOQe7w2SPc8QqeAU4wwHO7T9kkMXgYN07XDja+W1nprIhPxA91wykc/VSxPWqpB8eS1+dkKGoMbIZatBb2fIuOVjpzHMOhyF49bjv3bJf1YsTgTIfAlNBqevqLyzDto2wnV2odGStB4ppNEzQlMK66OVY0y+uLHNgpgWNc=  ;
X-YMail-OSG: TiQ26A0VM1l0flY80hunnJ6yJdsQlAjCDlel8T8neKGRl8T449DyoH76xYNbyGYwsfh9oMBA0g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
Date: Fri, 21 Mar 2008 10:04:04 -0700
User-Agent: KMail/1.9.6
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Geert Uytterhoeven <geert@linux-m68k.org>,
       netdev@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-usb@vger.kernel.org,
       linux-wireless@vger.kernel.org, video4linux-list@redhat.com,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, lm-sensors@lm-sensors.org
References: <20080316184349.GA28543@khazad-dum.debian.net> <20080321003604.GC20788@khazad-dum.debian.net> <20080320180802.426ad2d1.akpm@linux-foundation.org>
In-Reply-To: <20080320180802.426ad2d1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200803211004.05106.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 March 2008, Andrew Morton wrote:
> ./drivers/net/usb/pegasus.c
> 
>   Possibly buggy: deadlockable (I assume)

Looks just unecessary to me ... ethtool MII ops get called from
a task context, as I recall, and other drivers just rely on that.

- Dave

========= CUT HERE
Remove superfluous in-atomic() check; ethtool MII ops are called
from task context.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/net/usb/pegasus.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- g26.orig/drivers/net/usb/pegasus.c	2008-03-21 08:53:28.000000000 -0700
+++ g26/drivers/net/usb/pegasus.c	2008-03-21 08:54:07.000000000 -0700
@@ -1128,12 +1128,8 @@ pegasus_get_settings(struct net_device *
 {
 	pegasus_t *pegasus;
 
-	if (in_atomic())
-		return 0;
-
 	pegasus = netdev_priv(dev);
 	mii_ethtool_gset(&pegasus->mii, ecmd);
-
 	return 0;
 }
 

