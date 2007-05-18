Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbXERUtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbXERUtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 16:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbXERUtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 16:49:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbXERUtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 16:49:43 -0400
Message-ID: <464E110A.30701@redhat.com>
Date: Fri, 18 May 2007 16:48:10 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-mm1 and now 2.6.21-git: SLUB Crashes on boot - crypto?
References: <d1af83620705100410n482f4f9h428b7cab5501d963@mail.gmail.com> <20070514173823.GA7137@dreamland.darkstar.lan> <20070515014344.GA8850@gondor.apana.org.au> <20070515185212.GA18783@dreamland.darkstar.lan> <20070518031931.GA13048@gondor.apana.org.au> <68676e00705180509s64b737e2k37c5b2e713c96932@mail.gmail.com> <20070518131455.GA20918@gondor.apana.org.au> <20070518191645.GA10815@dreamland.darkstar.lan>
In-Reply-To: <20070518191645.GA10815@dreamland.darkstar.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luca Tettamanti wrote:
> Il Fri, May 18, 2007 at 11:14:55PM +1000, Herbert Xu ha scritto: 
>> On Fri, May 18, 2007 at 02:09:54PM +0200, Luca wrote:
>>> Well, pretty sure. The OOPS says 2.6.22-rc1-libata-g705962cc-dirty,
>>> git agrees and I've done a full rebuild. The .config is generated
>>> using 'make oldconfig' using the 2.6.21 as baseline, maybe ALGAPI is
>>> coming from there?
>> Sorry, my mistake.  That bug only happens if you have padlock turned on.
>>
>> Anyway, if possible could you post the complete dmesg when it crashes?
>> I'd like to see what has happened up to the point where it crashes.
> 
> Output from serial console is enlightening (sort of...):
> 
> Loading IPsec SA/SP database from /etc/ipsec-tools.conf: BUG: unable to
> handle kernel paging request at virtual address 6b6b6ceb printing eip:
> b0141aef
> [oops]
> 

module_put() is trying to decrease the refcount of a module that's
already been freed, AFAICT.

