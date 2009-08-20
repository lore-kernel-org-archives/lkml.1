Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbZHTQkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbZHTQkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 12:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbZHTQkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 12:40:09 -0400
Received: from bhuna.collabora.co.uk ([93.93.131.97]:38885 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbZHTQkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 12:40:08 -0400
Date: Thu, 20 Aug 2009 12:40:02 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: Takashi Iwai <tiwai@suse.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Takashi Iwai <tiwai@suse.de>, cjb@laptop.org, deepak@laptop.org,
       linux-geode@lists.infradead.org,
       Jordan Crouse <jordan@cosmicpenguin.net>, Tobias_Mueller@twam.info
Subject: Re: [PATCH 1/3] cs5535-gpio: add AMD CS5535/CS5536 GPIO driver
 support
Message-ID: <20090820124002.58d3d25b@mycelium.queued.net>
In-Reply-To: <s5hd46qo6j3.wl%tiwai@suse.de>
References: <20090818175314.16c81ca4@mycelium.queued.net>
	<s5hd46qo6j3.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009 17:21:20 +0200
Takashi Iwai <tiwai@suse.de> wrote:

> At Tue, 18 Aug 2009 17:53:14 -0400,
> Andres Salomon wrote:
> > 
> > 
> > This creates a CS5535/CS5536 GPIO driver which uses a gpio_chip
> > backend (allowing GPIO users to use the generic GPIO API if
> > desired) while also allowing architecture-specific users directly
> > (via the cs5535_gpio_* functions).
> 
> Will be any user of cs5535_gpio_*() expected?  If not, it'd be better
> not to export stuff, IMO.
> 

The olpc-dcon driver, for one.  If desired, I can remove the exports
for now.


> > Tested on an OLPC machine.  Some Leemotes also use CS5536 (with a
> > mips cpu), which is why this is in drivers/gpio rather than
> > arch/x86. Currently, it conflicts with older geode GPIO support;
> > once MFGPT support is reworked to also be more generic, the older
> > geode code will be removed.
> 
> .... or you can rewrite the old driver to use the functions above?
> Then the ugly Kconfig check can be dropped, too.  (yeah that's an
> answer to my own question above.)

I guess in theory I could.. 


> 
> BTW CONFIG_GPIO_CS5536 and CONFIG_CS5536_GPIO are so confusing... :)
> 

Agreed.  I'd really like CONFIG_CS5535_GPIO to go away, but first there
needs to be a replacement.  CONFIG_CS5535_GPIO will probably also need
to be marked DEPRECATED for a while, too, since it's a
userspace-visible change.  I can follow up w/ a patch for that once
people are happy w/ this current set of patches.

> > Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
> 
> I can happily merge this patch series to sound GIT tree if no one
> objects, since it's basically for OLPC sound stuff.
> 
> 
> thanks,
> 
> Takashi
