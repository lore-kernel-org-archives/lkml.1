Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbYEQLqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbYEQLqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 07:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYEQLqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 07:46:07 -0400
Received: from server.drzeus.cx ([85.8.24.28]:48152 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752169AbYEQLqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 07:46:06 -0400
X-Greylist: delayed 538 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 May 2008 07:46:06 EDT
Date: Sat, 17 May 2008 13:36:33 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jochen Friedrich <jochen@scram.de>, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 3/4] [MMC] mmc_spi: add polling support for the card
 detect line
Message-ID: <20080517133633.5aa26938@mjolnir.drzeus.cx>
In-Reply-To: <20080516165057.GC24196@polina.dev.rtsoft.ru>
References: <20080516165057.GC24196@polina.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008 20:50:57 +0400
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> Some boards do not use interrupts on the CD line, so we want to poll
> the CD and see if there was a change. 1 second poll interval seems
> resonable.
> 

The idea isn't bad, but I'm not sure about the mechanism.

To poll a MMC slot, you do not really need a card detect at all. The
MMC layer can just shoot off some requests and see if anything
responds.  The PXA driver (if my memory serves me right) already does
this. So the best idea there would be to add this feature to the MMC
core and let the host indicate that it needs it via MMC_CAP_NEEDS_POLL
or something like that.

The card detection pin then becomes an optimisation, something that is
also useful in other ways. Have the host driver check the card detection
pin at the start of every request, and quickly fail it if there is no
card present.

That should give you what you want with much more flexibility for other
uses as well.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
