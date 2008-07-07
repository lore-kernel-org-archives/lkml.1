Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbYGGJDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbYGGJDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 05:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYGGJD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 05:03:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53839 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbYGGJD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 05:03:27 -0400
Subject: Re: [PATCH] bnx2 - use request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: Michael Chan <mchan@broadcom.com>
Cc: Bastian Blank <bastian@waldi.eu.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <C27F8246C663564A84BB7AB34397724201E1494B50@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <C27F8246C663564A84BB7AB34397724201E1494B50@IRVEXCHCCR01.corp.ad.broadcom.com>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 10:03:33 +0100
Message-Id: <1215421413.3189.199.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-06 at 21:21 -0700, Michael Chan wrote:
> David Woodhouse wrote:
> 
> > But if _Michael_ signs off on it, and if you can provide it
> > in the form
> > used in the firmware-2.6.git tree, with the firmware files added into
> > the firmware/ subdirectory so they're still being shipped with the
> > kernel and the user doesn't have to go find them elsewhere, then I
> > suppose I'll probably take it.
> >
> 
> I cannot sign off on this until I understand more about the impact
> of this change.  Unlike the tg3 firmware which hasn't changed for at
> least 4 or 5 years, the bnx2 firmware is constantly changing and it
> has to match the driver.  For example, we'll be adding multi-tx ring
> to the driver soon and it will require the feature in the firmware.

The firmware will continue to be shipped with the kernel source tree
after this patch. Before applying it, will will update the patch so that
it doesn't just make the driver use request_firmware(), but also adds
the firmware back into the firmware/ directory of the source tree.

We retain the option to build the firmware into the kernel image -- so
if the driver is built in, nothing at all needs to change.

When the driver is built at a module, the 'make modules_install' command
will install the firmware into /lib/firmware where userspace can load
it.

The real concern I see would be if you make an incompatible change in
the firmware when you add the new feature -- so that the older drivers
would no longer work with the new firmware. But mostly, people don't do
that -- I'm guessing that your planned new firmware should work just
fine with older drivers, and the older drivers just won't use the new
feature?

If it _is_ backward-incompatible, that's not really a problem. The
solution is relatively simple; you just change the name of the firmware
file that gets requested by the new driver -- so the old driver
continues to request the old name, and get the firmware that works with
it. It's a bit like an soname in userspace libraries, in that respect.

Please support this patch.

At some point in the future, we'll have a discussion about moving the
firmware/ directory out to a separate, non-GPL'd, repository, where more
firmware can be incorporated. But that's a way off yet.

-- 
dwmw2

