Return-Path: <linux-kernel-owner+w=401wt.eu-S1755154AbZHOQVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbZHOQVL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 12:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755045AbZHOQVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 12:21:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60859 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbZHOQVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 12:21:09 -0400
Date: Fri, 14 Aug 2009 18:32:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Kconfig Q: expressing a modularity dependency
Message-ID: <20090814163250.GD1626@ucw.cz>
References: <49E5E8D0.1090505@imap.cc> <4A8448B7.6030007@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8448B7.6030007@imap.cc>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> /me wrote, four months ago:
> > My current attempts to port the Gigaset driver from isdn4linux
> > to CAPI require the following Kconfig dependency:
> > 
> > - If isdn4linux or kernelcapi or both are built as a module
> >   (CONFIG_ISDN_I4L=m || CONFIG_ISDN_CAPI=m)
> >   then gigaset can only be built as a module
> >   (CONFIG_ISDN_DRV_GIGASET depends on m).
> > 
> > - If neither isdn4linux nor kernelcapi ar built as a module
> >   (CONFIG_ISDN_I4L!=m && CONFIG_ISDN_CAPI!=m),
> >   including the case that neither is being built at all
> >   (CONFIG_ISDN_I4L=n && CONFIG_ISDN_CAPI=n),
> >   then gigaset may be built statically or as a module
> >   (all three tristate settings for CONFIG_ISDN_DRV_GIGASET are
> >   legal).
> > 
> > How is that best expressed in Kconfig?
> 
> Judging from the complete silence following that question, the
> answer is, apparently: not at all.
> 
> So I'll just put a notice in the help text then, warning people
> not to set CONFIG_ISDN_DRV_GIGASET=y if their ISDN subsystem
> is built as a module. If anybody has a better idea I'll be
> glad to hear it.

That will break randconfig testing, AFAICT.

AFAIK Kconfig supports if statement just fine, so can you just

if something
	bool GIGASET
else
	tristate GIGASET

?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
