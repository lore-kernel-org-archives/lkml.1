Return-Path: <linux-kernel-owner+w=401wt.eu-S1030648AbXBMEU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030648AbXBMEU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 23:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030649AbXBMEU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 23:20:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35011
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030648AbXBMEUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 23:20:55 -0500
Date: Mon, 12 Feb 2007 20:20:54 -0800 (PST)
Message-Id: <20070212.202054.104031463.davem@davemloft.net>
To: clem@clem.clem-digital.net
Cc: linux-kernel@vger.kernel.org, chuck.lever@oracle.com, neilb@suse.de
Subject: Re: 2.6.20-git8 fails compile -- net/built-in.o __ipv6_addr_type
From: David Miller <davem@davemloft.net>
In-Reply-To: <200702130110.l1D1ADai012897@clem.clem-digital.net>
References: <200702130110.l1D1ADai012897@clem.clem-digital.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pete Clements <clem@clem.clem-digital.net>
Date: Mon, 12 Feb 2007 20:10:13 -0500 (EST)

> 2.6.20-git8 fails compile:
> 
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> net/built-in.o: In function `svc_udp_recvfrom':
> svcsock.c:(.text+0x61be4): undefined reference to `__ipv6_addr_type'
> make: *** [.tmp_vmlinux1] Error 1

Chuck, you will need to somehow make CONFIG_SUNRPC "depend" upon IPV6
so that if IPV6 is modular SUNRPC can only be built modular.

Otherwise the symbols won't resolve correctly.

Everybody hits this problem when they add ipv6 support to
something. :-)

