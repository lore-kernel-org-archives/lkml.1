Return-Path: <linux-kernel-owner+w=401wt.eu-S932217AbXLMRy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbXLMRy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932075AbXLMRyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:54:41 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37933 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762997AbXLMRyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:54:39 -0500
Date: Thu, 13 Dec 2007 18:54:42 +0100
From: Adrian Bunk <bunk@kernel.org>
To: bbpetkov@yahoo.de, Benjamin Thery <benjamin.thery@bull.net>,
       Pierre Peiffer <pierre.peiffer@bull.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 2.6.24-rc5-mm1
Message-ID: <20071213175442.GA21616@stusta.de>
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org> <47613F18.6080601@bull.net> <4761494E.1050704@bull.net> <20071213160744.GA4509@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071213160744.GA4509@gollum.tnic>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 05:07:44PM +0100, Borislav Petkov wrote:
> On Thu, Dec 13, 2007 at 04:01:34PM +0100, Benjamin Thery wrote:
> > The problem comes from the new macro UDPX_INC_STATS_BH introduced
> > by Herbert, which was a nice addition to increment the correct 
> > UDP MIB depending on the socket family, but unfortunately 
> > the use of this macro from kernel code (I mean code not compiled 
> > as module) requires that IPv6 is also compiled in kernel 
> > (CONFIG_IPv6=y) in order to have udp_stats_in6 defined at link 
> > time.
> > 
> > Benjamin
> > 
> > Pierre Peiffer wrote:
> > > Hi,
> > > 
> > > 	My config does not link any more:
> > > 
> > > ...
> > >   CHK     include/linux/compile.h
> > >   UPD     include/linux/compile.h
> > >   CC      init/version.o
> > >   LD      init/built-in.o
> > >   LD      .tmp_vmlinux1
> > > net/built-in.o: In function `xs_udp_data_ready':
> > > /home/peifferp/containers/kernel/linux-2.6.24-rc5-mm1/net/sunrpc/xprtsock.c:842:
> > > undefined reference to `udp_stats_in6'
> > > /home/peifferp/containers/kernel/linux-2.6.24-rc5-mm1/net/sunrpc/xprtsock.c:846:
> > > undefined reference to `udp_stats_in6'
> > > make[1]: *** [.tmp_vmlinux1] Error 1
> > > make: *** [sub-make] Error 2
> > > 
> > > After a first look, udp_stats_in6 seems to be defined in ipv6 (file
> > > net/ipv6/udp.c) but I have
> > > 
> > > CONFIG_IPV6=m
> > > and
> > > CONFIG_SUNRPC=y
> > > 
> > > So, SUNRPC uses something defined in a module in my case ?
> > > 
> > > ... looking more, this dependency seems to have been introduced by the patch
> > > [UDP]: Restore missing inDatagrams increments
> > > ( http://thread.gmane.org/gmane.linux.network/79716/focus=79831 )
> > > 
> > > (I cc netdev)
> > > 
> > > I don't know what is the right way to fix this ... ?
> 
> you might do "select IPV6" in the SUNRPC section of fs/Kconfig, however select is
> evil...

select itself isn't evil.

Nonsensical selects like the one you suggest (sunrpc does not require 
IPV6) are evil.

> Regards/Gruß,
>     Boris.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

