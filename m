Return-Path: <linux-kernel-owner+w=401wt.eu-S1758834AbYELUqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbYELUqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 16:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYELUqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 16:46:10 -0400
Received: from bar.sig21.net ([88.198.146.85]:38574 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbYELUqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 16:46:09 -0400
Date: Mon, 12 May 2008 22:46:34 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Oliver Endriss <o.endriss@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew de Quincey <adq_dvb@lidskialf.net>
Subject: Re: [patch, 2.6.26-rc2] dvb: drivers/media/dvb/ttpci/fdump
	firmware build error fix
Message-ID: <20080512204634.GA10620@linuxtv.org>
References: <20080512101231.GA11755@elte.hu> <200805121930.10909@orion.escape-edv.de> <20080512194630.GA10174@linuxtv.org> <200805122218.15887@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805122218.15887@orion.escape-edv.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-21-Score: -3.9 (---)
X-Spam-21-Report: No, score=-3.9 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.480,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 10:18:15PM +0200, Oliver Endriss wrote:
> Johannes Stezenbach wrote:
> > On Mon, May 12, 2008 at 07:30:10PM +0200, Oliver Endriss wrote:
> > > Ingo Molnar wrote:
> > >> -     depends on DVB_AV7110 && !STANDALONE
> > >> +     depends on DVB_AV7110 && !STANDALONE && !PREVENT_FIRMWARE_BUILD
> > 
> > > If you set DVB_AV7110_FIRMWARE=y, the firmware file under
> > > DVB_AV7110_FIRMWARE_FILE must exist...
> > 
> > The point of PREVENT_FIRMWARE_BUILD is to make build testing
> > with "make randconfig" possible. I think you should ACK
> > this patch, it doesn't have any downsides for users of
> > this driver.
> 
> No. If randconfig deselects both STANDALONE and PREVENT_FIRMWARE_BUILD,
> the same problem will happen again...

You can put PREVENT_FIRMWARE_BUILD=y in your allrandom.config.

> The driver depends on STANDALONE, and that should be sufficient:
> | CONFIG_STANDALONE:
> |   Select this option if you don't have magic firmware for drivers that
> |   need it.

this is for excluding drivers which don't _work_ without firmware

> while CONFIG_PREVENT_FIRMWARE_BUILD means:
> | CONFIG_PREVENT_FIRMWARE_BUILD:
> |   Say yes to avoid building firmware. Firmware is usually shipped
> |   with the driver, and only when updating the firmware a rebuild
> |   should be made.

and this is for excluding drivers which don't _build_ without firmware
(badly worded, it certainly doesn't mean to build the firmware,
but build a C source file from the firmware)


Johannes
