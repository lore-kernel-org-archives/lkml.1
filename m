Return-Path: <linux-kernel-owner+w=401wt.eu-S934670AbYBNA6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934670AbYBNA6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763817AbYBNA5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:57:50 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:52469 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761575AbYBNA5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:57:48 -0500
From: Roman Zippel <zippel@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: distributed module configuration [Was: Announce: Linux-next (Or Andrew's dream :-))]
Date: Thu, 14 Feb 2008 01:56:13 +0100
User-Agent: KMail/1.9.7
Cc: David Miller <davem@davemloft.net>, greg@kroah.com,
       torvalds@linux-foundation.org, jeff@garzik.org, arjan@infradead.org,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, linux-kbuild <linux-kbuild@vger.kernel.org>
References: <20080212174824.GA1919@kroah.com> <20080212.164149.209357519.davem@davemloft.net> <20080213084541.GA8091@uranus.ravnborg.org>
In-Reply-To: <20080213084541.GA8091@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802140156.15325.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 13. February 2008, Sam Ravnborg wrote:

> config foo
> 	tristate "do you want foo?"
> 	depends on USB && BAR
> 	module
> 	  obj-$(CONFIG_FOO) += foo.o
> 	  foo-y := file1.o file2.o
> 	help
> 	  foo will allow you to explode your PC

I'm more thinking about something like this:

module foo [FOO]
	tristate "do you want foo?"
	depends on USB && BAR
	source file1.c
	source file2.c if BAZ

Avoiding direct Makefile fragments would give us far more flexibility in the 
final Makefile output.

> And we could introduce support for
>
> source "drivers/net/Kconfig.*"
>
> But then we would have to make the kconfig step mandatory
> for each build as we would otherwise not know if there
> were added any Kconfig files.

That's a real problem and it would be a step back of what we have right now, 
so I'm not exactly comfortable with it.

bye, Roman
