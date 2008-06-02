Return-Path: <linux-kernel-owner+w=401wt.eu-S1759946AbYFBLx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946AbYFBLx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756355AbYFBLxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:53:15 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43262 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbYFBLxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:53:13 -0400
Date: Mon, 2 Jun 2008 14:53:09 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: johnpol@2ka.mipt.ru, ray-lk@madrabbit.org, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>, rjw@sisk.pl,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
In-Reply-To: <E1K33OH-0005QX-00@gondolin.me.apana.org.au>
Message-ID: <Pine.LNX.4.64.0806021442450.16829@wrl-59.cs.helsinki.fi>
References: <E1K33OH-0005QX-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008, Herbert Xu wrote:

> Ilpo J??rvinen <ilpo.jarvinen@helsinki.fi> wrote:
> >
> > Before:
> > tcp    65436      0 lo:5000          lo:59980         ESTABLISHED -
> 
> This is what happens before accept(2) is called.  Ingo, please
> strace the process that owns the listening socket to make sure
> that it is actually calling accept(2).  If it ever stops calling
> accept(2) then this is expected behaviour.

Shouldn't that be already visible in the ingo's sysrq-t dump, no? There:

  http://marc.info/?l=linux-kernel&m=121182099131520&w=2

There are many sys_accepts at least (if I understand that dump at all). 
There were some ip_local_outs there as well, which made me wonder if the 
totally innocent looking commit 1ac06e0306d0192a7a4d9ea1c9e06d355ce7e7d3 
(ipsec: Use the correct ip_local_out function) has something to do with 
this (I definately don't understand that part at all).

-- 
 i.
