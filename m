Return-Path: <linux-kernel-owner+w=401wt.eu-S1751317AbZGaNej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbZGaNej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 09:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbZGaNei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 09:34:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35340 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbZGaNei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 09:34:38 -0400
Date: Fri, 31 Jul 2009 14:34:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: pHilipp Zabel <philipp.zabel@gmail.com>
Cc: Roger Quadros <quadros.roger@gmail.com>, lrg@slimlogic.co.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Add GPIO enable control to fixed voltage
	regulator driver
Message-ID: <20090731133437.GF17091@sirena.org.uk>
References: <1249044918-695-1-git-send-email-quadros.roger@gmail.com> <20090731131005.GE17091@sirena.org.uk> <74d0deb30907310625u128ea22cu6fecca53c4a23d40@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74d0deb30907310625u128ea22cu6fecca53c4a23d40@mail.gmail.com>
X-Cookie: hipatitis:
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 03:25:36PM +0200, pHilipp Zabel wrote:
> On Fri, Jul 31, 2009 at 3:10 PM, Mark
> Brown<broonie@opensource.wolfsonmicro.com> wrote:

> > This isn't needed, just use an invalid GPIO value (zero or less).

> Negative only, actually. Zero itself is a valid GPIO number (which is
> a bit unfortunate because if you forget to initialize .gpio, it will
> default to GPIO #0).

> If you drop .use_gpio_control, use gpio_is_valid(data->gpio) for this check:

Feh, better print a warning for GPIO 0 for at least a kernel release.
Fortunately we've got no mainline users of fixed voltage regulators.

> > Same comment as above with regard to the error message. ?It would be
> > nice to have the default state passed in as platform data if you can't
> > read it back to help avoid bouncing supplies at startup. ?IIRC
> > gpio_get_value() will generally take a good stab at giving the current
> > state no matter if the GPIO is input our output but I'd need to check.

> I think this is not clearly defined in the GPIO API document, so it
> could be architecture dependent.

It's not particularly; having checked gpiolib just passes this straight
through to the underlying driver.  Since they'd have to go out of their
way to do something unconstructive it should be safe to do the read and
we can worry about problem cases if they crop up.

> > If you mark the comments with /** they'll get picked up by kerneldoc.

> Maybe following the style in Documentation/kernel-doc-nano-HOWTO.txt
> would be worthwhile, then.

Indeed.
