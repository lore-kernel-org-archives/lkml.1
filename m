Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbZL3RRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbZL3RRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 12:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbZL3RQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 12:16:37 -0500
Received: from mail1.radix.net ([207.192.128.31]:46838 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbZL3RQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 12:16:35 -0500
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
From: Andy Walls <awalls@radix.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stefani Seibold <stefani@seibold.net>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>
In-Reply-To: <64D5262E-28CF-41E8-9425-F8C5DD0A2265@gmail.com>
References: <200912271003.631128760@firstfloor.org>
	 <1261949800.25298.18.camel@wall-e> <20091227233816.GC2399@basil.fritz.box>
	 <1261986136.808.2.camel@wall-e> <20091228145749.GD4994@basil.fritz.box>
	 <1262016510.12656.25.camel@wall-e> <20091228172651.GE4994@basil.fritz.box>
	 <1262030653.15368.37.camel@wall-e>  <20091228204003.GH4994@basil.fritz.box>
	 <1262076056.23095.21.camel@wall-e>
	 <64D5262E-28CF-41E8-9425-F8C5DD0A2265@gmail.com>
Content-Type: text/plain
Date: Wed, 30 Dec 2009 12:15:42 -0500
Message-Id: <1262193342.5645.2.camel@palomino.walls.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-29 at 14:27 -0800, Dmitry Torokhov wrote:
> On Dec 29, 2009, at 12:40 AM, Stefani Seibold <stefani@seibold.net>  
> wrote:
> 
> > Am Montag, den 28.12.2009, 21:40 +0100 schrieb Andi Kleen:
> >
> >
> >> OK i checked and they all use power-of-two currently so by sheer
> >> luck (I doubt it is by design) they work. Still I think that
> >> open deathtrap should be fixed.
> >>
> >
> > It is fixed, and i hope it will be included in 2.6.34.
> >
> >> I also don't understand how that patch "breaks your future work"
> >> Please elaborate on that.
> >>
> >
> > Very difficult to explain in a email, but i will try it:
> >
> > The new macro based kfifo API handles everything as elements of a  
> > given
> > type. So you can have the old "unsigned char"-fifo, but also fifo of
> > every other type like int's, struct's and so on. The kfifo_in() and
> > kfifo_out() len parameter is than in the meaning of elements not  
> > bytes.
> > So you are able to process more than one value at a time and the  
> > macros
> > will return the number of processed elements (not bytes).
> 
> Does anyone want this kind of functionality though? Why can't we keep  
> the old interface as is (and maybe deprecate it) and use the new  
> record API you mentioned below for record-oriented kfifos.

Yes.  I will eventually convert my use of kfifo to use records of size
'u32' as opposed to reading and writing in multiples of 4 bytes.  (I
have some ugly checks right now to make sure whenever I read from a
kfifo I get back a multiple of 4 bytes.)

I'm just waiting for the churn to settle.

Regards,
Andy

> Thanks.


