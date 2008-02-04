Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbYBDVnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbYBDVnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbYBDVmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:42:53 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1930 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbYBDVmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:42:52 -0500
Date: Mon, 4 Feb 2008 21:31:03 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux01@architechnical.net
Cc: linux-kernel@vger.kernel.org, laim.girdwood@wolfsonmicro.com
Subject: Re: [UPDATED v4] WM97xx touchscreen drivers
Message-ID: <20080204213100.GA30382@sirena.org.uk>
Mail-Followup-To: linux01@architechnical.net, linux-kernel@vger.kernel.org,
	laim.girdwood@wolfsonmicro.com
References: <3713.69.30.58.166.1202151624.squirrel@architechnical.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3713.69.30.58.166.1202151624.squirrel@architechnical.net>
X-Cookie: Flee at once, all is discovered.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 02:00:24PM -0500, linux01@architechnical.net wrote:
> Mark Brown wrote:

> > This patch series adds support for the touchscreen controllers provided
> > by Wolfson Microelectronics WM97xx series chips in both polled and
> > streaming modes.

> I integrated this patch with our 2.6.24 kernel and it broke our APM-based
> battery monitor, which uses an ADC channel on the 9712.  Support for this

The expectation of this driver is that the battery monitor driver will
register as the "wm97xx-battery" device and use the wm97xx_read_aux_adc()
function exported by the wm97xx-core driver to access the ADC.  Is your
driver using this interface?

> multi-function chip series seems to be in a few places; would it make
> sense to have one generic WM97xx driver in drivers/mfd and stack the
> codec, touchscreen, etc, drivers logically above (in their respective
> areas)?

The intention is that these drivers should be able to coexist with the
existing ASoC drivers as-is.  We do have existing users doing this - the
first publicly available example that springs to mind is tosa which
also uses the wm9712 with touchscreen and battery, together with the
ASoC driver for audio (the ASoC bits of this have been merged since ASoC
was merged in 2006, the other bits are out of tree partly due to the
fact that they depend on this driver).

>          In my experience with the Wolfson series a change to the sound
> driver breaks touchscreen, a change to the touchscreen driver changes ADC
> readings, etc,

I'm disappointed to hear that, particularly with the wm9712 since that
especially has had a reasonable degree of testing with our drivers over
a fairly long time period.

>                so I wanted to open dialog on what the right direction may
> be as various Wolfson code starts making its way into the mainline.

The most obvious way forward if we can't resolve these problems with the
existing scheme is to pull out the core driver as you say above - this
is the approach already taken by the touch drivers to allow battery
monitoring while the touchscreen is in use.

Is your kernel (or the wm9712-related code at least) publicly available?
If not would it be possible for you to share it with me off-list?  It
might help me understand what's going on here.
