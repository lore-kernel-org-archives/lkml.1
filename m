Return-Path: <linux-kernel-owner+w=401wt.eu-S1751828AbZGKW3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbZGKW3a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 18:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbZGKW3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 18:29:23 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:27883 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751370AbZGKW3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 18:29:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=oHgb1u/WX9tKgYAsH92EFgAICK5WnTbcrdejU+iuitxaC3g1xAJqM0PikBk/ulo9KpEvPjAhBEVgqVdcWgBFBhU+etbRzJ0lX1yFsTGKtWWAdpcOPtBJhDYoJvwieSev4OPb2qHIG2wltsMpeBvdqCyBRPqUjgq0XUviydpeeTQ=  ;
X-YMail-OSG: ITTMo1sVM1lw40rZkO4_5Oq51gvsrNGqpN.Upi0PVFW6isvlCMnaQIfIhsMgUbrKCmfaoF0C8r0OeBB4KiWnN5e8XpB4FEz.8ATX7nMgi1zhZN0weSBjkN20hXPO1dxVI6__qjQ6LOXWM5dJOgP1_5yznTdr3fnqwtfi4q5MaWqfZcBg9vt66aLedKfgB7j7zA4eNv8yh.N3LC4pmXTWNoZB8Xm.FkE1GK5xzGv5Octot45w2irGrlpT_bbFno4Zh3mpaZHNmpqU28BM
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] move mmci-omap-hs's probe function to .devinit.text
Date: Sat, 11 Jul 2009 15:29:20 -0700
User-Agent: KMail/1.9.10
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jean Pihet <jpihet@mvista.com>, Tony Lindgren <tony@atomide.com>,
       Pierre Ossman <drzeus@drzeus.cx>, Andy Lowe <alowe@mvista.com>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>
References: <20090711170548.GC5205@suse.de> <1247345591-22643-24-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-25-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1247345591-22643-25-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907111529.21165.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 July 2009, Uwe Kleine-König wrote:
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.

And that's the preferred fix ... NAK on this one.

In fact its quite rare for any SoC device to be hotpluggable,
so your default stance in such cases should be to switch over
to platform_driver_probe() instead of doing like this.


