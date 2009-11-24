Return-Path: <linux-kernel-owner+w=401wt.eu-S932733AbZKXLGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733AbZKXLGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 06:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932223AbZKXLF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 06:05:59 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49866 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202AbZKXLF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 06:05:59 -0500
Date: Tue, 24 Nov 2009 11:06:01 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: mfd tree build warning
Message-ID: <20091124110601.GA26097@sirena.org.uk>
References: <20091124164219.c5d54461.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124164219.c5d54461.sfr@canb.auug.org.au>
X-Cookie: Your code should be more efficient!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 04:42:19PM +1100, Stephen Rothwell wrote:

> I have been getting these warnings from the x86_64 allmodconfig build for
> a long time:

> drivers/mfd/wm8350-regmap.c:3177:2: warning: #warning No WM8350 config modes supported - select at least one of the
> drivers/mfd/wm8350-regmap.c:3178:2: warning: #warning MFD_WM8350_CONFIG_MODE_n options from the board driver.

> This may not be a problem, I just thought I should let you know.

It's not a real problem.  Any actual system using the driver will need
to have explicit code which registers the I2C device for the WM8350,
that code will need to set up the particular build for the board.  The
build time warning is there to try to make it a bit more obvious what's
needed.

Allowing the driver to be built without one of these defined provides
build coverage which is helpful for subsystem maintainers.

I might send a patch taking away the compile time warning, I'm not sure
how likely it is that people will notice it.
