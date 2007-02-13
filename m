Return-Path: <linux-kernel-owner+w=401wt.eu-S1030621AbXBMCx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030621AbXBMCx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 21:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030620AbXBMCx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 21:53:29 -0500
Received: from ns2.suse.de ([195.135.220.15]:35745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030619AbXBMCx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 21:53:28 -0500
From: Neil Brown <neilb@suse.de>
To: Pete Clements <clem@clem.clem-digital.net>
Date: Tue, 13 Feb 2007 13:52:26 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17873.10218.683015.201907@notabene.brown>
Cc: yoshfuji@linux-ipv6.org (YOSHIFUJIHideaki/=?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?=),
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "Chuck Lever" <chuck.lever@oracle.com>
Subject: Re: 2.6.20-git8 fails compile -- net/built-in.o __ipv6_addr_type
In-Reply-To: message from Pete Clements on Monday February 12
References: <20070213.111345.78160400.yoshfuji@linux-ipv6.org>
	<200702130236.l1D2a0u7014457@clem.clem-digital.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday February 12, clem@clem.clem-digital.net wrote:
> Quoting YOSHIFUJIHideaki/=?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?=
>   > In article <20070212181216.c55ca788.akpm@linux-foundation.org> (at Mon, 12 Feb 2007 18:12:16 -0800), Andrew Morton <akpm@linux-foundation.org> says:
>   > 
>   > > > On Mon, 12 Feb 2007 20:10:13 -0500 (EST) Pete Clements <clem@clem.clem-digital.net> wrote:
>   > > > 2.6.20-git8 fails compile:
>   > > > 
>   > > >   CHK     include/linux/compile.h
>   > > >   UPD     include/linux/compile.h
>   > > >   CC      init/version.o
>   > > >   LD      init/built-in.o
>   > > >   LD      .tmp_vmlinux1
>   > > > net/built-in.o: In function `svc_udp_recvfrom':
>   > > > svcsock.c:(.text+0x61be4): undefined reference to `__ipv6_addr_type'
>   > > > make: *** [.tmp_vmlinux1] Error 1
>   > > > 

Hmmm.  

> CONFIG_IPV6=m
combined with
> CONFIG_SUNRPC=y

is a combination that isn't going to work at the moment....

Options?

 - Move __ipv6_addr_type to lib/ ??
        Might not work for modules.
 - Disallow that combination in the .config.
        .. a bit harsh.
 - Only include IPv6 support in SUNRPC is a module or IPV6 is built-in
        A bit of a kludge..

Chuck?  Any ideas?

NeilBrown

