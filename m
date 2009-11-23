Return-Path: <linux-kernel-owner+w=401wt.eu-S1757169AbZKWLCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169AbZKWLCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756489AbZKWLCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:02:33 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42791 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756658AbZKWLCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:02:32 -0500
Date: Mon, 23 Nov 2009 11:02:36 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Null suspend/resume functions
Message-ID: <20091123110236.GB24326@rakim.wolfsonmicro.main>
References: <ud43sjtaf.wl%morimoto.kuninori@renesas.com>
 <20091109105858.GB1245@sirena.org.uk>
 <20091109133136.GC1245@sirena.org.uk>
 <20091116153000.GB29479@sirena.org.uk>
 <20091117115236.GB1376@ucw.cz>
 <20091117124125.GD823@rakim.wolfsonmicro.main>
 <20091118160908.GD20887@elf.ucw.cz>
 <20091119112102.GF9763@rakim.wolfsonmicro.main>
 <20091121234509.GC1411@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091121234509.GC1411@ucw.cz>
X-Cookie: Avoid contact with eyes.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 22, 2009 at 12:45:10AM +0100, Pavel Machek wrote:

> So you place a comment there; it should be there anyway. Having nop
> during suspend/resume *is* unusual, and it should raise red flags.

This isn't a good assumption here.  Remember that this is for runtime PM
so if we're getting as far as these calls then the driver has already
told the core that it is idle, which probably means that the hardware is
already quieseced.  For a lot of hardware that will mean that the only
thing left to do in order to suspend is to (possibly) remove power and
in many cases (as with SH) that's going to be done by the bus rather
than the device.  It's a bit more likely that some activity will be
needed on resume but in many cases the device gets fully reprogrammed on
when it becomes active anyway.

Looking at it another way a key goal of runtime PM is to get the bus
involved in the process - if we can do things at device level to reduce
power consumption then there's no need to go through runtime PM to do
them.

> Plus, if we allowed NULLs there, we'd not know if the driver does not
> implement it because it is not neccessary, or because they don't care.

Again, in order to use runtime PM the driver must already be doing
explicit calls so it should be fairly clear that the driver is trying to
support suspend.
