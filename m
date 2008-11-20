Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbYKTG51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbYKTG51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 01:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbYKTG5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 01:57:19 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:47395 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751248AbYKTG5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 01:57:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mj+Cn3XAUV3Cxrrbovww6p5t15fg+pxBiLqxacRIpNIDPHrivJCFa/V42wohkYvg2Rv+0XWsT66HCeVTps8pwssdzoEH/91CM5iXp8oWK9uRgYztfmImYRRdzHeR2jUHQABxPWFVvM0o3ZmB0XajWIdZ45OQXYoMqrV4wmkf8HI=  ;
X-YMail-OSG: 9d3ibH4VM1k3dBAd4QJnOg4sf5Cj.NLylLld8pvundEfnl8Oy39eOwttQX7zSNzjPd5L.bK5LxGdxEBVUwJBZbHn3klXU7Ty_a3IwGmFQWQFOX448KY8K8rZ0BaXPWCY4Gt5ZVoR8_o0Xm_Z92pg9QZ31t2GtCwY5n_PlZlL
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/1] cpumask: smp_call_function_many()
Date: Thu, 20 Nov 2008 17:57:07 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, npiggin@suse.de, axboe@kernel.dk
References: <20081119144710.59CA1DDDDB@ozlabs.org> <200811201421.50518.nickpiggin@yahoo.com.au> <200811201514.09511.rusty@rustcorp.com.au>
In-Reply-To: <200811201514.09511.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811201757.07726.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 November 2008 15:44, Rusty Russell wrote:
> On Thursday 20 November 2008 13:51:49 Nick Piggin wrote:
> > I don't like changing of this whole smp_call_function_many scheme
> > with no justification or even hint of it in the changelog.
>
> Hi Nick,
>
> Hmm, it said "if allocation fails we fallback to smp_call_function_single
> rather than using the baroque quiescing code."
>
> More words would have been far less polite :)

Hmm, OK I missed that.


> > Of course it is obvious that smp_call_function_mask can be implemented
> > with multiple call singles. But some architectures that can do
> > broadcast IPIs (or otherwise a little extra work eg. in programming
> > the interrupt controller) will lose here.
> >
> > Also the locking and cacheline behaviour is probably actually worse.
>
> Dude, we've failed kmalloc.  To paraphrase Monty Python, the parrot is
> fucked. By this stage the disks are churning, the keyboard isn't responding
> and the OOM killer is killing the mission-critical database and other vital
> apps. Everything else is failing on random syscalls like unlink().  Admins
> wondering how long it'll take to fsck if they just hit the big red switch
> now.

Oh no it happens. It's a GFP_ATOMIC allocation isn't it? But yeah it's not
performance critical.


> OK, maybe it's not that bad, but worrying about cacheline behaviour?  I'd
> worry about how recently that failure path has been tested.
>
> I can prepare a separate patch which just changes this over, rather than
> doing it as part of the smp_call_function_many() conversion, but I couldn't
> stomach touching that quiescing code :(

What's wrong with it? It's well commented and I would have thought pretty
simple. A bit ugly, but straightforward. I still don't really see why it
needs changing.
