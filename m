Return-Path: <linux-kernel-owner+w=401wt.eu-S1161225AbXBGLnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161225AbXBGLnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 06:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161226AbXBGLnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 06:43:31 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:49169 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161225AbXBGLna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 06:43:30 -0500
Subject: Re: [patch 1/1] PM: Adds remount fs ro at suspend
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Andrew Morton <akpm@linux-foundation.org>, akuster@mvista.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20070207112539.GD8148@khazad-dum.debian.net>
References: <20070202235132.EDBDF1C448@hermes.mvista.com>
	 <20070202161611.cf8b4328.akpm@linux-foundation.org>
	 <20070203003536.GA619@khazad-dum.debian.net>
	 <1170710913.6105.39.camel@nigel.suspend2.net>
	 <20070206143231.GD18392@khazad-dum.debian.net>
	 <1170797924.14398.19.camel@nigel.suspend2.net>
	 <20070207112539.GD8148@khazad-dum.debian.net>
Content-Type: text/plain
Date: Wed, 07 Feb 2007 22:43:13 +1100
Message-Id: <1170848593.9827.24.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, 2007-02-07 at 09:25 -0200, Henrique de Moraes Holschuh wrote:
> On Wed, 07 Feb 2007, Nigel Cunningham wrote:
> > Ok, as far as usage scenario goes, that's fair enough. But as to the
> > solution, I wonder though whether it's making life more complicated than
> > it needs to be. After all, we should also be able to cope okay with
> > having the power suddenly go out. If we can cope with that, cleaning
> > filesystems prior to suspending should be a non-issue.
> 
> We don't cope okay with the power going out, at all.  And as an user case, a
> need for fsck if you do something that is a reasonable use case (unplugging
> devices while suspended) is not okay, either.

Maybe it depends on the filesystem you use. I've used ext3 for 6 or so
years of development on Suspend2, and it's never given me a single
problem, despite the fact that I've sometimes done the equivalent of
pulling the plug without a sync or unmount. I did try XFS at one stage.
It's performance was better, but it did give problems. Nevertheless, I'm
more than happy to make the above claim about ext3.

> > Likewise with changes in hardware. Once hotplugging support is mature,
> > suspending, switching around hardware and resuming should just result in
> > hot[un]plug events.
> 
> Well, if we add *move* events for when someone unplugs a usb stick in one
> port and replugs it in another while the system is in lala-land... maybe :-)
> It would be normal to do it, when dealing with docks.

Isn't that part of the point to having those uuid thingys? I hate them
at the moment (from the point of view of suspend code), but hopefully
they'll end up being nicer to deal with.

