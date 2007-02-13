Return-Path: <linux-kernel-owner+w=401wt.eu-S1161003AbXBMEXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161003AbXBMEXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 23:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030653AbXBMEXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 23:23:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35023
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030602AbXBMEX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 23:23:29 -0500
Date: Mon, 12 Feb 2007 20:23:28 -0800 (PST)
Message-Id: <20070212.202328.21596861.davem@davemloft.net>
To: neilb@suse.de
Cc: clem@clem.clem-digital.net, yoshfuji@linux-ipv6.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, chuck.lever@oracle.com
Subject: Re: 2.6.20-git8 fails compile -- net/built-in.o __ipv6_addr_type
From: David Miller <davem@davemloft.net>
In-Reply-To: <17873.10218.683015.201907@notabene.brown>
References: <20070213.111345.78160400.yoshfuji@linux-ipv6.org>
	<200702130236.l1D2a0u7014457@clem.clem-digital.net>
	<17873.10218.683015.201907@notabene.brown>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Brown <neilb@suse.de>
Date: Tue, 13 Feb 2007 13:52:26 +1100

> On Monday February 12, clem@clem.clem-digital.net wrote:
> > Quoting YOSHIFUJIHideaki/=?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?=
> >   > In article <20070212181216.c55ca788.akpm@linux-foundation.org> (at Mon, 12 Feb 2007 18:12:16 -0800), Andrew Morton <akpm@linux-foundation.org> says:
> >   > 
> >   > > > On Mon, 12 Feb 2007 20:10:13 -0500 (EST) Pete Clements <clem@clem.clem-digital.net> wrote:
> >   > > > 2.6.20-git8 fails compile:
> >   > > > 
> >   > > >   CHK     include/linux/compile.h
> >   > > >   UPD     include/linux/compile.h
> >   > > >   CC      init/version.o
> >   > > >   LD      init/built-in.o
> >   > > >   LD      .tmp_vmlinux1
> >   > > > net/built-in.o: In function `svc_udp_recvfrom':
> >   > > > svcsock.c:(.text+0x61be4): undefined reference to `__ipv6_addr_type'
> >   > > > make: *** [.tmp_vmlinux1] Error 1
> >   > > > 
> 
> Hmmm.  
> 
> > CONFIG_IPV6=m
> combined with
> > CONFIG_SUNRPC=y
> 
> is a combination that isn't going to work at the moment....
> 
> Options?
> 
>  - Move __ipv6_addr_type to lib/ ??
>         Might not work for modules.
>  - Disallow that combination in the .config.
>         .. a bit harsh.
>  - Only include IPv6 support in SUNRPC is a module or IPV6 is built-in
>         A bit of a kludge..
> 
> Chuck?  Any ideas?

Make the proper dependencies, so that SUNRPC is only possibly built
modular is IPV6 is modular, that's the correct way to do this.
