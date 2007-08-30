Return-Path: <linux-kernel-owner+w=401wt.eu-S933175AbXH3Sid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175AbXH3Sid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 14:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932757AbXH3SiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 14:38:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58437 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932662AbXH3SiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 14:38:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: CONFIG_HOTPLUG_CPU: kconfig bug?
Date: Thu, 30 Aug 2007 20:48:55 +0200
User-Agent: KMail/1.9.5
Cc: Roman Zippel <zippel@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, kbuild-devel@lists.sourceforge.net
References: <Pine.LNX.4.64.0708271525400.21853@blonde.wat.veritas.com> <Pine.LNX.4.64.0708300235010.1817@scrub.home> <Pine.LNX.4.64.0708301319590.32332@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0708301319590.32332@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708302048.55793.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 30 August 2007 14:40, Hugh Dickins wrote:
> On Thu, 30 Aug 2007, Roman Zippel wrote:
> > 
> > > > > > I've noticed an oddity with CONFIG_HOTPLUG_CPU in 2.6.23-rc:
> > > > > > make oldconfig seems to turn it on even when nothing wants it,
> > > > > > increasing kernel size by about 10k; but if you then edit the
> > > > > > line out of .config and make oldconfig again, it correctly
> > > > > > offers the choice and lets it be turned off after all.
> > 
> > It's somewhat a side effect of using select and defaults, the order of the 
> > config symbols becomes significant for oldconfig, if you look at the 
> > output you'll find:
> > 
> > Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL) (HOTPLUG_CPU) [Y/?] y
> > 
> > this sets it to 'y'. In this case one isn't asked about it, because there 
> > is only one choice. The patch below avoids the setting of the value here.
> 
> Thanks for working that out: your patch certainly works for me,
> and would be good to see in 2.6.23, to prevent lots of users getting
> an unnecessary CONFIG_HOTPLUG_CPU forever after.  I wonder what config
> options this might have forced in the past.

Probably CONFIG_SUSPEND, which was a new option, defaulted to 'y' and selected
CONFIG_HOTPLUG_CPU indirectly, because CONFIG_SMP was set.

Greetings,
Rafael
