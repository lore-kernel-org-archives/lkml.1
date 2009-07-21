Return-Path: <linux-kernel-owner+w=401wt.eu-S1755696AbZGUTEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbZGUTEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbZGUTEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:04:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42471 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbZGUTEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:04:12 -0400
Date: Tue, 21 Jul 2009 20:04:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Gurudatt, Sreenidhi B" <sreenidhi.b.gurudatt@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>
Subject: Re: x86: IPC driver patch for Intel Moorestown platform
Message-ID: <20090721190402.GD28955@sirena.org.uk>
References: <98769532B4BB14429434178695419EAE5F3F9541@bgsmsx501.gar.corp.intel.com> <200907211723.36862.arnd@arndb.de> <98769532B4BB14429434178695419EAE5F45B41A@bgsmsx501.gar.corp.intel.com> <200907211835.36195.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907211835.36195.arnd@arndb.de>
X-Cookie: Thrashing is just virtual crashing.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 06:35:36PM +0200, Arnd Bergmann wrote:
> On Tuesday 21 July 2009, Gurudatt, Sreenidhi B wrote:

> > The IPC driver APIs for host drivers communicate with the SCU 
> > (System Controller Unit) firmware on the platform. It is used
> > by many Moorestown platform specific drivers such as Audio,
> > Touch Screen, GPIO, Battery, Power Management etc for accessing

> The real difference is whether it can get autoloaded at
> boot time by udev based on the present device nodes, or
> you need to manually put it into /etc/modules.

> If you simply create platform devices at boot time,
> you get both the autoloading and a reasonable representation
> in /sys/devices/platform/mrst_ipc/... for free.

Yeah, this is sounding like the MFD framework might provide a bit of
help here - it essentially boils down to providing some helpers for
doing what you're suggesting here.  At present major users of the MFD
framework include the companion chips like the TWL4030 and WM835x which
fulfil the same sort role as described above in more traditional
embedded systems.
