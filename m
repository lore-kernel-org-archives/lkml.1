Return-Path: <linux-kernel-owner+w=401wt.eu-S934320AbXGTPIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934320AbXGTPIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933652AbXGTPIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:08:37 -0400
Received: from mail.suse.de ([195.135.220.2]:49362 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933654AbXGTPIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:08:36 -0400
Date: Fri, 20 Jul 2007 08:06:27 -0700
From: Greg KH <gregkh@suse.de>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kay.sievers@vrfy.org
Subject: Re: kobject link failure
Message-ID: <20070720150627.GA12822@suse.de>
References: <Pine.LNX.4.64.0707191956510.31013@fbirervta.pbzchgretzou.qr> <469FA94E.20002@googlemail.com> <20070720080059.GA29639@suse.de> <20070720113221.390ed32a@gondolin.boeblingen.de.ibm.com> <20070720135813.0e416b2b@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720135813.0e416b2b@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 01:58:13PM +0200, Cornelia Huck wrote:
> On Fri, 20 Jul 2007 11:32:21 +0200,
> Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> 
> > Hm, this would be an interface change (the uevent attribute used to
> > exist even for !CONFIG_HOTPLUG, it just triggered nothing). How about
> > moving kobject_actions[] out of the #ifdef (maybe next to
> > kobject_action)?
> 
> Leaving kobject_actions[] in kobject_uevent.c, but putting it outside
> the #ifdef looks indeed like the best solution to me. This way, we
> avoid adding #ifdef CONFIG_HOTPLUG into core.c, when all other
> functions called do not need such a thing.

Yeah, this is much nicer and smaller, thanks.  I'll throw away my patch
and use this one instead.

Can someone verify that it works properly for them please?

thanks,

greg k-h
