Return-Path: <linux-kernel-owner+w=401wt.eu-S1759387AbXHQPNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387AbXHQPNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 11:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbXHQPNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 11:13:41 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3951 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbXHQPNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 11:13:41 -0400
Subject: Re: RFHelp:  Splitting MAINTAINERS into maintainers/*
	and	Makefile/Kconfig support
From: Joe Perches <joe@perches.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070817144827.GB20963@uranus.ravnborg.org>
References: <1187297496.5906.113.camel@localhost>
	 <46C53F3F.5060108@redhat.com> <1187353841.822.60.camel@localhost>
	 <20070817144827.GB20963@uranus.ravnborg.org>
Content-Type: text/plain; charset=utf-8
Date: Fri, 17 Aug 2007 08:13:27 -0700
Message-Id: <1187363607.822.88.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-17 at 16:48 +0200, Sam Ravnborg wrote:
> Adding a specific target på top-level Makefile is easy to
> do so I assume you are looking for something more advanced?

No, I'm looking for something simple.
Perhaps something like:

Makefile contents:

all: [0-9a-z]*

install:
	sh cat [0-9a-z]* > ../MAINTAINERS

clean:
	rm -f ../MAINTAINERS

I don't hardly understand the linux make machinery
for files that aren't .o, so I don't know if that's
reasonable or valid.

> And that part "more advanced" I do not know what is.
> Doing so using the normal kbuild machinery is not soo
> good since it will be parallel and we want something serail
> here.
> 
> If you define how the Maintainer info is stored we can work
> out something.

My preference is for a single directory with 
maintainers stored as separate files because
it's very simple, but it's still up in the air.

Basically breaking up the current monolithic
MAINTAINERS file into separate little files.

For instance this chunk of MAINTAINERS
[...]
3C359 NETWORK DRIVER
P:	Mike Phillips
M:	mikep@linuxtr.net
L:	netdev@vger.kernel.org
W:	http://www.linuxtr.net
S:	Maintained
F:	drivers/net/tokenring/3c359*

3C505 NETWORK DRIVER
P:	Philip Blundell
M:	philb@gnu.org
L:	netdev@vger.kernel.org
S:	Maintained
F:	drivers/net/3c505*
[...]

would become

File "maintainers/3c359_network_driver" with content:
3C359 NETWORK DRIVER
P:	Mike Phillips
M:	mikep@linuxtr.net
L:	netdev@vger.kernel.org
W:	http://www.linuxtr.net
S:	Maintained
F:	drivers/net/tokenring/3c359*

and

File "maintainers/3c505_network_driver" with content:
3C505 NETWORK DRIVER
P:	Philip Blundell
M:	philb@gnu.org
L:	netdev@vger.kernel.org
S:	Maintained
F:	drivers/net/3c505*

thanks,  Joe

