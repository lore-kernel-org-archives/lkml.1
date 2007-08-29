Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbXH2SAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbXH2SAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 14:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbXH2SAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 14:00:43 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:50860 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbXH2SAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 14:00:42 -0400
Date: Wed, 29 Aug 2007 20:01:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org,
       kbuild-devel@lists.sourceforge.net
Subject: Re: CONFIG_HOTPLUG_CPU: kconfig bug?
Message-ID: <20070829180158.GA7849@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0708271525400.21853@blonde.wat.veritas.com> <20070827172654.GA21871@uranus.ravnborg.org> <Pine.LNX.4.64.0708272143150.29594@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708272143150.29594@blonde.wat.veritas.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I've noticed an oddity with CONFIG_HOTPLUG_CPU in 2.6.23-rc:
> > > make oldconfig seems to turn it on even when nothing wants it,
> > > increasing kernel size by about 10k; but if you then edit the
> > > line out of .config and make oldconfig again, it correctly
> > > offers the choice and lets it be turned off after all.

I have tried to track down what is happening here.
The culprint is:

config SUSPEND_SMP
	bool
	depends on SUSPEND_SMP_POSSIBLE && PM_SLEEP
	select HOTPLUG_CPU
	default y


It seems that due to the fact that SUSPEND_SMP is default y
then kconfig enforce the "select HOTPLUG_CPU".

And this happens despite the fact that PM_SLEEP is 'n'
(but SUSPEND_SMP_POSSIBLE is 'y').

It is somewhere in sym_calc_value() or one of the childs that
suddenly causes the change.
But I find it hard to follow this part of the logic in kconfig.

Roman - can you help here with what is going on?

	Sam
