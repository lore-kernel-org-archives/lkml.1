Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbZCJS4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbZCJS4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 14:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbZCJS4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 14:56:37 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:50708 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbZCJS4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 14:56:36 -0400
Message-ID: <49B6B821.5050302@oracle.com>
Date: Tue, 10 Mar 2009 11:57:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       herbert@gondor.apana.org.au, David Miller <davem@davemloft.net>,
       linux-crypto@vger.kernel.org
Subject: Re: linux-next: Tree for March 10 (crypto & NLATTR)
References: <20090310195534.8f8f3c7a.sfr@canb.auug.org.au>
In-Reply-To: <20090310195534.8f8f3c7a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.49B6B7B1.015E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090306:
> 
> 
> The driver-core tree gained a build failure due to a conflict with the
> crypto tree.  I have applied a patch to the crypto tree for today.

I had several (4 of 50) randconfig builds fail with:

lib/built-in.o: In function `__nla_reserve_nohdr':
(.text+0xd08d): undefined reference to `skb_put'
lib/built-in.o: In function `__nla_reserve':
(.text+0xd121): undefined reference to `skb_put'
lib/built-in.o: In function `nla_append':
(.text+0xd493): undefined reference to `skb_put'

which happens with CONFIG_NET=n, CONFIG_CRYPTO=y, CONFIG_CRYPTO_ZLIB=[my].

CRYPTO_ZLIB selects NLATTR, but obviously the build of nlattr.c fails
when CONFIG_NET=n.  Should CRYPTO_ZLIB depend on NET?
Please don't say that CRYPTO_ZLIB should select NET.


-- 
~Randy
