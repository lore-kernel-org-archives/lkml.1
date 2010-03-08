Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab0CHLt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 06:49:27 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:39111 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab0CHLtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 06:49:24 -0500
Date: Mon, 8 Mar 2010 20:48:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Peter Huewe <peterhuewe@gmx.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Denis Turischev <denis@compulab.co.il>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Mike Turquette <mturquette@ti.com>, Magnus Damm <damm@opensource.se>,
       Yusuke Goda <goda.yusuke@renesas.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Balaji T K <balajitk@ti.com>, Moiz Sonasath <m-sonasath@ti.com>,
       Eduardo Valentin <eduardo.valentin@nokia.com>,
       Haojian Zhuang <haojian.zhuang@marvell.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>,
       Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Cory Maccarrone <darkstar6262@gmail.com>, Julia Lawall <julia@diku.dk>,
       H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [GIT PULL] MFD update for 2.6.34
Message-ID: <20100308114835.GA16081@linux-sh.org>
References: <20100307215323.GA21970@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100307215323.GA21970@sortiz.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 07, 2010 at 10:53:25PM +0100, Samuel Ortiz wrote:
> H Hartley Sweeten (3):
>       mfd: Use resource_size() in sm501
>       mfd: Use resource_size() for t7l66xb
>       mfd: Use resouce_size for tc6393xb
> 
These need to be looked at carefully, at least the sm501 change is
totally bogus, breaks everything, and stems from a total lack of
understanding of how the drivers interact.

The I/O resource that's remapped and handled by the MFD takes the full
size, while the region request is purposely trimmed down so only the
registers needed by the MFD driver are reserved by the MFD driver. Other
drivers (like sm501fb) will have their own region requests within the
same resource at different offsets, all of which are broken after this
change.

As such, 311e54c07e784fe63d421f724dcc597d1f82ccad at least needs to be
reverted. I haven't looked at the other two, but if it's a similar
mechanical change then those should be dropped, too.
