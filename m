Return-Path: <linux-kernel-owner+w=401wt.eu-S1752819AbXFOKm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbXFOKm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 06:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbXFOKmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 06:42:50 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:42479 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbXFOKmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 06:42:50 -0400
Subject: Re: [PATCH] diskquota: 32bit quota tools on 64bit architectures
From: Vasily Tarasov <vtaras@openvz.org>
Reply-To: vtaras@openvz.org
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: akpm@linux-foundation.org, dev@sw.ru, devel@openvz.org, jack@suse.cz,
       linux-kernel@vger.kernel.org, nataliep@google.com, vvs@sw.ru
In-Reply-To: <200706151003.l5FA3vd6008194@harpo.it.uu.se>
References: <200706151003.l5FA3vd6008194@harpo.it.uu.se>
Content-Type: text/plain
Organization: OpenVZ community
Date: Fri, 15 Jun 2007 14:41:49 +0400
Message-Id: <1181904109.3241.35.camel@dhcp0-149.sw.ru>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.0.1.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

You can find a half-year back discussions of this patch:

First attempt: http://lkml.org/lkml/2006/10/19/123
Second attempt: http://lkml.org/lkml/2006/10/25/57

I think they will answer your questions.

Thank you,
Vasily


On Fri, 2007-06-15 at 12:03 +0200, Mikael Pettersson wrote:
> On Fri, 15 Jun 2007 13:01:48 +0400, Vasily Tarasov wrote:
> > OpenVZ Linux kernel team has discovered the problem 
> > with 32bit quota tools working on 64bit architectures.
> > In 2.6.10 kernel sys32_quotactl() function was replaced by sys_quotactl() with
> > the comment "sys_quotactl seems to be 32/64bit clean, enable it for 32bit"
> > However this isn't right. Look at if_dqblk structure:
> 
> Your patch only converts ia32 on x86-64 or ia64.
> What about ppc32-on-ppc64 and sparc32-on-sparc64?
> And, I guess, mips32-on-mips64?
> 
> > --- linux-2.6.22-rc4-fixed/fs/quota.c.orig	2007-06-14 15:55:26.000000000 +0400
> > +++ linux-2.6.22-rc4-fixed/fs/quota.c	2007-06-14 19:50:13.000000000 +0400
> ...
> > +#if defined(CONFIG_X86_64) || defined(CONFIG_IA64)
> > +/*
> > + * This code works only for 32 bit quota tools over 64 bit OS (x86_64, ia64)
> > + * and is necessary due to alignment problems.
> > + */
> 
> The #ifdef looks way too arch-specific. And isn't there a shared
> compat.c module somewhere that this should go into?
> 
> /Mikael

