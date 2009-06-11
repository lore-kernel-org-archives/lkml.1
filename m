Return-Path: <linux-kernel-owner+w=401wt.eu-S1763830AbZFKPQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763830AbZFKPQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755590AbZFKPQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:16:21 -0400
Received: from bhuna.collabora.co.uk ([93.93.131.97]:58977 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773AbZFKPQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:16:20 -0400
Date: Thu, 11 Jun 2009 11:16:10 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: Tobias_Mueller@twam.info
Cc: akpm@linux-foundation.org, Randy Dunlap <randy.dunlap@oracle.com>,
       deepak@laptop.org, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
       jordan@cosmicpenguin.net, cjb@laptop.org
Subject: Re: [PATCH 1/2] cs5535-gpio: add AMD CS5535/CS5536 GPIO driver  
 support
Message-ID: <20090611111610.0667898a@mycelium.queued.net>
In-Reply-To: <17be05570906110746l214f88cdh8570488e1be51b30@mail.gmail.com>
References: <20090610001033.27b7f69f@mycelium.queued.net>
	<17be05570906110746l214f88cdh8570488e1be51b30@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009 16:46:35 +0200
Tobias Müller <Tobias_Mueller@twam.info> wrote:

> 2009/6/10 Andres Salomon <dilinger@collabora.co.uk>:
> > +config GPIO_CS5535
> > +       tristate "AMD CS5535/CS5536 GPIO support"
> > +       depends on PCI && !CS5535_GPIO && !MGEODE_LX
> > +       help
> > +         The AMD CS5535 and CS5536 southbridges support 28 GPIO
> > pins that
> > +         can be used for quite a number of things.  The CS5535/6
> > is found on
> > +         AMD Geode and Lemote Yeeloong devices.
> 
> Why do you depend on !MGEODE_LX? Are there any problems?

Because arch/x86/kernel/{mfgpt,geode}_32.c are built if
CONFIG_MGEODE_LX is set, and they will happily clobber each other.  We
need to get a broken-out mfgpt driver completed, and then we can rework
or remove the arch/x86/kernel/{mfgpt,geode}_32.c stuff.

It's probably possible to add a separate config for that
(CONFIG_GEODE_LEGACY or something?) rather than having it depend upon
CONFIG_MGEODE_LX, but I haven't looked into it.  I'd rather spend the
time fixing it correctly than fretting about with the various config
permutations. :)
