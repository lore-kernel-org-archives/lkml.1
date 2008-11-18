Return-Path: <linux-kernel-owner+w=401wt.eu-S1752415AbYKRJob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbYKRJob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 04:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYKRJoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 04:44:20 -0500
Received: from smtp117.mail.mud.yahoo.com ([209.191.84.166]:46253 "HELO
	smtp117.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750869AbYKRJoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 04:44:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=a1oAcn47BDdO3YYSsoK8WRbjFw+oTrYtDFGKYQRLPo+LtxXa0NLx+M/dXIjuaxBnJ+FO1Q8HcsK+0UprtVX6ZkbLYr6ynbK9F7jDkXD3QoFFICpMJXfmLJpPGVsLKuY5RuZTVm2vp/rPIHO3+dnaCLt31DN/vcMtrpUfEOuMqZA=  ;
X-YMail-OSG: qL30LsAVM1mFEhdLP6qgZNnX5q4DR4spD0eXMtcGg1pRXBEOj7Wsr3xV_uCls2couhprzi0XRbMz7bx383zV5bV_Jn769jnbj4Bp8zs8p.zwjFKbMUYBkzy7gAbc6m7LJrnqA3Z2i6FRlsvS_kR9xezNhyviY5.qvRXgzqN5AtLGI3oGtoZJIFuVspuE
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Miller <davem@davemloft.net>
Subject: Re: [Bug #11308] tbench regression on each kernel release from 2.6.22 -&gt; 2.6.28
Date: Tue, 18 Nov 2008 20:44:10 +1100
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, mingo@elte.hu, dada1@cosmosbay.com,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl, shemminger@vyatta.com
References: <alpine.LFD.2.00.0811171149100.18283@nehalem.linux-foundation.org> <alpine.LFD.2.00.0811171218470.18283@nehalem.linux-foundation.org> <20081117.125826.193693115.davem@davemloft.net>
In-Reply-To: <20081117.125826.193693115.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811182044.11055.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 November 2008 07:58, David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Mon, 17 Nov 2008 12:30:00 -0800 (PST)
>
> > On Mon, 17 Nov 2008, David Miller wrote:
> > > It's on my workstation which is a much simpler 2 processor
> > > UltraSPARC-IIIi (1.5Ghz) system.
> >
> > Ok. It could easily be something like a cache footprint issue. And while
> > I don't know my sparc cpu's very well, I think the Ultrasparc-IIIi is
> > super- scalar but does no out-of-order and speculation, no?
>
> I does only very simple speculation, but you're description is accurate.

Surely it would do branch prediction, but maybe not indirect branch?
I did wonder why those indirect function calls were added everywhere
in the scheduler...

They didn't show up in the newest generation of x86 CPUs, but simpler
implementations won't handle them as well.

I wouldn't expect that to cause such a big regression on its own, but
it would still be interesting to test changing them to direct calls.

