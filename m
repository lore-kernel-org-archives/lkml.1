Return-Path: <linux-kernel-owner+w=401wt.eu-S1764331AbZAULh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764331AbZAULh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 06:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbZAULhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 06:37:13 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:33899 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604AbZAULhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 06:37:12 -0500
Date: Wed, 21 Jan 2009 12:38:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Helge Deller <deller@gmx.de>, David Miller <davem@davemloft.net>,
       jaswinder@kernel.org, mingo@elte.hu, x86@kernel.org,
       linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: Confusion in usr/include/asm-generic/fcntl.h
Message-ID: <20090121113853.GB1579@uranus.ravnborg.org>
References: <1232496257.3123.19.camel@localhost.localdomain> <20090120.163203.199590606.davem@davemloft.net> <4976D937.5040704@gmx.de> <200901210924.23484.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901210924.23484.arnd@arndb.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 09:24:22AM +0100, Arnd Bergmann wrote:
> On Wednesday 21 January 2009, Helge Deller wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > >> On parisc, there is a major confusion in this area, at some point, all
> > >> checks for __LP64__ got replaced with CONFIG_64BIT there. While I have
> > >> not understood what the problem with __LP64__ was, the check for
> > >> CONFIG_64BIT on parisc user space looks very wrong.
> > 
> > I think the parisc mess is my fault. I once replaced the __LP64__ by 
> > CONFIG_64BIT and forgot that some files are exported to userspace.
> > I'll clean that up and send patches.
> 
> I have a patch set that introduces a lot more asm-generic headers where
> I also need a generic way to check for this. The approach I chose
> here was to check "#if __BITS_PER_LONG == 64" for anything that is
> exported to user space. Maybe you can #define this in asm/types.h
> and use this check in the parisc headers as well.

Could we add a new symbol for this?
We know we are going to use this in several places so a simpler variant
would be more readable.

Something like:

#ifdef __64BIT
...
#endif


When we define __64BIT we would use the  __BITS_PER_LONG == 64 check.

	Sam
