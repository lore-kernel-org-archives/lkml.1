Return-Path: <linux-kernel-owner+w=401wt.eu-S1764162AbYBMIpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764162AbYBMIpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbYBMIpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:45:36 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:40106 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbYBMIpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:45:34 -0500
Date: Wed, 13 Feb 2008 09:45:41 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: greg@kroah.com, torvalds@linux-foundation.org, jeff@garzik.org,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: distributed module configuration [Was: Announce: Linux-next (Or Andrew's dream :-))]
Message-ID: <20080213084541.GA8091@uranus.ravnborg.org>
References: <20080212174824.GA1919@kroah.com> <alpine.LFD.1.00.0802121011280.2920@woody.linux-foundation.org> <20080212191552.GA20883@kroah.com> <20080212.164149.209357519.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212.164149.209357519.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> 2) Let's move away from some/dir/{Kconfig,Makefile} schemes and
>    instead have each "thing" have it's own Kconfig.foo or
>    Makefile.foo that gets automatically sucked into the main
>    directory Makefile or Kconfig using file globs or similar.

So we could do:

config foo
	tristate "do you want foo?"
	depends on USB && BAR
	module
	  obj-$(CONFIG_FOO) += foo.o
	  foo-y := file1.o file2.o
	help
	  foo will allow you to explode your PC

The [module] part would go unedited into a kbuild file
located in same dir as the Kconfig file and included by kbuild.
That would solve the Makefile issue.


And we could introduce support for

source "drivers/net/Kconfig.*"

But then we would have to make the kconfig step mandatory
for each build as we would otherwise not know if there
were added any Kconfig files.

Does this fit what you had in mind?

	Sam
