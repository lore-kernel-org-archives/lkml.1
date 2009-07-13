Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbZGMQJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbZGMQJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 12:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756492AbZGMQJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 12:09:10 -0400
Received: from gw1.transmode.se ([213.115.205.20]:44966 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756483AbZGMQJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 12:09:08 -0400
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jul 2009 12:09:08 EDT
In-Reply-To: <20090713151911.GA28114@oksana.dev.rtsoft.ru>
References: <20090713151911.GA28114@oksana.dev.rtsoft.ru>
Subject: Re: [PATCH 0/2] Setting GPIOs simultaneously
X-KeepSent: F188389D:68E638A2-C12575F2:00568C5B;
 type=4; name=$KeepSent
To: avorontsov@ru.mvista.com
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
X-Mailer: Lotus Notes Release 8.5 December 05, 2008
Message-ID: <OFF188389D.68E638A2-ONC12575F2.00568C5B-C12575F2.0057FC95@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Mon, 13 Jul 2009 18:01:02 +0200
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5 HF407|May 07, 2009) at
 2009-07-13 18:01:03
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Anton Vorontsov <avorontsov@ru.mvista.com> wrote on 13/07/2009 17:19:11:
>
> Hi all,
>
> I've been sitting on these patches for some time, but now it appears
> that the set_sync() feature is needed elsewhere. So here are the
> patches.
>
> Joakim, I think this is what you need.

Yes, it sure looks so :) I will have to look closer later as
I will be traveling the next few days.

Question though, have you considered using a bitmask instead of
an array:
static void qe_gpio_set_sync(struct gpio_chip *gc, unsigned int num,
	 		      unsigned int gpio_mask, unsigned int vals)
If you want to set bit 0, 3 and 8 you would set positions 0, 3 and 8 in gpio_mask
to ones. Similarly in vals, set bit positions 0, 3 and 8 to requested value.

While being at it, the reason for me needing this is that the spi_mpc83xx driver
was recently converted to a OF only driver so I have no way of defining my own
CS function anymore. While OF is good I don't feel that OF drivers should block the native
method, OF should be a layer on top of the native methods.

 Jocke

