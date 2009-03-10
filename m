Return-Path: <linux-kernel-owner+w=401wt.eu-S1757799AbZCJUIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799AbZCJUIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 16:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757682AbZCJUHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 16:07:35 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:25648 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614AbZCJUHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 16:07:34 -0400
Message-ID: <49B6C8BF.8010105@oracle.com>
Date: Tue, 10 Mar 2009 13:08:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, herbert@gondor.apana.org.au,
       David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
Subject: Re: linux-next: Tree for March 10 (crypto & NLATTR)
References: <20090310195534.8f8f3c7a.sfr@canb.auug.org.au>	 <49B6B821.5050302@oracle.com> <10f740e80903101256v2cfe08a8g410c297e019d8693@mail.gmail.com>
In-Reply-To: <10f740e80903101256v2cfe08a8g410c297e019d8693@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.49B6C850.01E3:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Tue, Mar 10, 2009 at 19:57, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> Stephen Rothwell wrote:
>>> Changes since 20090306:
>>>
>>>
>>> The driver-core tree gained a build failure due to a conflict with the
>>> crypto tree.  I have applied a patch to the crypto tree for today.
>> I had several (4 of 50) randconfig builds fail with:
>>
>> lib/built-in.o: In function `__nla_reserve_nohdr':
>> (.text+0xd08d): undefined reference to `skb_put'
>> lib/built-in.o: In function `__nla_reserve':
>> (.text+0xd121): undefined reference to `skb_put'
>> lib/built-in.o: In function `nla_append':
>> (.text+0xd493): undefined reference to `skb_put'
>>
>> which happens with CONFIG_NET=n, CONFIG_CRYPTO=y, CONFIG_CRYPTO_ZLIB=[my].
>>
>> CRYPTO_ZLIB selects NLATTR, but obviously the build of nlattr.c fails
>> when CONFIG_NET=n.  Should CRYPTO_ZLIB depend on NET?
>> Please don't say that CRYPTO_ZLIB should select NET.
> 
> Bummer, my fault (commit e9cc8bddaea3944fabfebb968bc88d603239beed,
> netlink: Move netlink attribute parsing support to lib).
> 
> Obviously I was only worried about crypto/zlib.c needing nlattr.c
> without pulling in the whole networking code, not about nlattr.c
> itself needing networking functionality. But still, how could I have
> missed this compile failure?
> 
> Does it sound sane to protect the routines that do call skb_put() by
> #ifdef CONFIG_NET?

I'll have to let David or Herbert answer that.  From my quick look
at the code, I don't see much use for nlattr.c when CONFIG_NET
is not enabled.

-- 
~Randy
