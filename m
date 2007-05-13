Return-Path: <linux-kernel-owner+w=401wt.eu-S1761539AbXEMNr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761539AbXEMNr4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 09:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761370AbXEMNrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 09:47:36 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:59981 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761367AbXEMNrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 09:47:33 -0400
Date: Sun, 13 May 2007 15:47:22 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: Flush mmc workqueue late in the boot sequence
Message-ID: <20070513154722.6399074c@dhcp-252-105.norway.atmel.com>
In-Reply-To: <464713FB.2060801@drzeus.cx>
References: <117879333788-git-send-email-hskinnemoen@atmel.com>
	<46430A49.9090803@drzeus.cx>
	<20070510143737.54969394@dhcp-252-105.norway.atmel.com>
	<46432212.9070008@drzeus.cx>
	<20070510163348.0a117d92@dhcp-252-105.norway.atmel.com>
	<46434123.8040801@drzeus.cx>
	<20070510182749.219351cb@dhcp-252-105.norway.atmel.com>
	<46437562.9050501@drzeus.cx>
	<20070511103905.08530507@dhcp-252-105.norway.atmel.com>
	<464713FB.2060801@drzeus.cx>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007 15:34:51 +0200
Pierre Ossman <drzeus@drzeus.cx> wrote:

> > I'm not sure how many embedded people actually know how to build an
> > initrd for a custom board.
> >   
> 
> All the ones I have on my desk right now use initrd. ;)

Ok, I guess we'll just have to look into that, then.

> I had a chat with David Woodhouse and Segher Boessenkool and I think we have
> another approach. Basically, we move the waiting which would normally go into
> the initrd and move it into the kernel. So you get something like:
> 
> "Waiting for root device /dev/mmcblk0p1..."
> 
> The only problem here is if the device never shows up, but if that was the case
> you would previously get a panic, so it should not be any worse.

Indeed, it will even be pretty obvious what happened, and the user can
probably just insert a card at that point to get a working system.

> Does that sound like something that would work for you? From my point of view
> it's a much cleaner solution that has the benefit of not being tied into a
> certain subsystem (i.e. this would "fix" usb aswell).

Yes, that would definitely work.

Haavard
