Return-Path: <linux-kernel-owner+w=401wt.eu-S1755745AbYG2HcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbYG2HcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 03:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYG2Hbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 03:31:51 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:34206 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbYG2Hbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 03:31:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Gw1D8q8WdZgBiQssMpPEdK7JeF/oTCQuIp3cBqvCKPNcsQ+y7Q6vFU0LbxgN8dU98L
         BC54TMZvH4UTdR4XOJ1ntjsHImWCHM1D1wYcZ51xaJX7REnzGPCRDh74kllb3WB7/4+K
         X5S13GySv7eQ571fnInepDs2acJ1BG99iXdO4=
Date: Tue, 29 Jul 2008 03:31:46 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, robfitz@273k.net, akpm@osdl.org,
       jikos@jikos.cz, vojtech@suse.cz, dmonakhov@openvz.org
Subject: Re: [PATCH] bcm5974-0.58: name changes, open/close and
	suspend/resume serialized
Message-ID: <20080729073146.GA5776@anvil.corenet.prv>
References: <4888311E.9010005@euromail.se> <20080725154250.GA1861@anvil.corenet.prv> <488A1A99.2070609@euromail.se> <20080725143015.ZZRA012@mailhub.coreip.homeip.net> <488AD712.1020102@euromail.se> <20080729054132.GA5345@anvil.corenet.prv> <1217313973.15381.9.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217313973.15381.9.camel@johannes.berg>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 08:46:13AM +0200, Johannes Berg wrote:
> On Tue, 2008-07-29 at 01:41 -0400, Dmitry Torokhov wrote:
> 
> > > one thing about the drivers/input/mouse/Kconfig patch:
> > > 
> > > The original version contained "select USB", which was later changed
> > > to "depends on USB" by Andrew Morton. I saw it reappear as "select USB"
> > > in your latest patch, and simply considered it a change back, but
> > > maybe it was an oversight?
> > > 
> > 
> > I am of the opinion that it is OK to "select" high-level subsystems that
> > don't have additional dependencies, especially if they are "past" the
> > original driver in menuconfig. I don't really like the idea of forcing
> > users revisiting earlier sub-menus after they selected a new subsystem
> > to see if there are any new options. Plus, if user wants driver for his
> > touchpad he does not really care whether it is PS/2 or USB, [s]he just
> > wants it to work.
> 
> USB tends to have implicit dependencies like the ehci/ohci/uhci
> controller though, so it's not going to work like that anyway starting
> from a minimal config, and all defconfigs probably have USB anyway.
> 
> Therefore, I personally would keep it as "depends on" rather than
> "select". YMMV.
> 

It should work fine I think. The full dependancy of most USB input
devices is:

        depends on USB_ARCH_HAS_HCD
        select USB

You do need to select the host controller, that is correct, but you
don't need to go to USB menu, select HCD, then go back to input menu
(which you already visited) and select your USB input device.

-- 
Dmitry
