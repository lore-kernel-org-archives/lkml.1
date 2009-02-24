Return-Path: <linux-kernel-owner+w=401wt.eu-S1760075AbZBXUT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075AbZBXUT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 15:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757739AbZBXUTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 15:19:48 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:59351 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757151AbZBXUTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 15:19:47 -0500
Date: Tue, 24 Feb 2009 15:19:37 -0500
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tiwai@suse.de, katzj@redhat.com,
       cjb@laptop.org, jayakumar.alsa@gmail.com, jordan@cosmicpenguin.net,
       linux-geode@lists.infradead.org, perex@perex.cz,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 1/2] cs553x-gpio: add AMD CS5535/CS5536 GPIO driver
 support
Message-ID: <20090224151937.6bf43943@ephemeral>
In-Reply-To: <20090224120637.18073f93.akpm@linux-foundation.org>
References: <20090220221202.667fbb79@ephemeral>
	<20090224120637.18073f93.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009 12:06:37 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 20 Feb 2009 22:12:02 -0500
> Andres Salomon <dilinger@queued.net> wrote:
> 
> > 
> > This creates a CS5535/CS5536 GPIO driver which uses a gpio_chip
> > backend (allowing GPIO users to use the generic GPIO API if
> > desired) while also allowing architecture-specific users directly
> > (via the cs553x_gpio_* functions).
> > 
> > Tested on an OLPC machine.  Some Leemotes also use CS5536 (with a
> > mips cpu), which is why this is in drivers/gpio rather than
> > arch/x86.  Currently, it conflicts with older geode GPIO support;
> > once MFGPT support is reworked to also be more generic, the older
> > geode code will be removed.
> > 
> > +EXPORT_SYMBOL_GPL(cs553x_gpio_set);
> > +EXPORT_SYMBOL_GPL(cs553x_gpio_clear);
> > +EXPORT_SYMBOL_GPL(cs553x_gpio_isset);
> 
> Nothing uses these exports.  In fact these symbols could be made
> static to drivers/gpio/cs553x-gpio.c?


Not yet.  The MFGPT, DCON, and olpc stuff will use them; I'm waiting to
hear feedback on this patch before I write a generic MFGPT driver (or
skip to cleaning up and submitting the DCON driver).

