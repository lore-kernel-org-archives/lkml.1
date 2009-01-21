Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbZAUR1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbZAUR1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 12:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbZAUR0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 12:26:54 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:36186 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbZAUR0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 12:26:53 -0500
Date: Wed, 21 Jan 2009 18:28:37 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Helge Deller <deller@gmx.de>, David Miller <davem@davemloft.net>,
       jaswinder@kernel.org, mingo@elte.hu, x86@kernel.org,
       linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: Confusion in usr/include/asm-generic/fcntl.h
Message-ID: <20090121172837.GA4386@uranus.ravnborg.org>
References: <1232496257.3123.19.camel@localhost.localdomain> <200901210924.23484.arnd@arndb.de> <20090121113853.GB1579@uranus.ravnborg.org> <200901211313.17394.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901211313.17394.arnd@arndb.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 01:13:16PM +0100, Arnd Bergmann wrote:
> On Wednesday 21 January 2009, Sam Ravnborg wrote:
> > Could we add a new symbol for this?
> > We know we are going to use this in several places so a simpler variant
> > would be more readable.
> > 
> > Something like:
> > 
> > #ifdef __64BIT
> > ...
> > #endif
> > 
> > When we define __64BIT we would use the  __BITS_PER_LONG == 64 check.
> 
> I would prefer using the __BITS_PER_LONG == 64 check directly, because
> it gives you a warning when __BITS_PER_LONG is undefined, whereas the
> #ifdef check gets easily fooled by include order problems. Note that
> this is not a problem in the kernel for CONFIG_* symbols which are
> always defined before the first #include.

It gives the warning only if you add -Wundef which IIRC is not default
with -Wall. And using the "__BITS_PER_LONG == 64" the risk of gitting
the expression wrong is much higher than the simpler variant where
you only write:

    __64BIT

But I have no strong feelings for it.

	Sam
