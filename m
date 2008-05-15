Return-Path: <linux-kernel-owner+w=401wt.eu-S1757169AbYEONiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169AbYEONiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 09:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbYEONiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 09:38:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36520 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbYEONiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 09:38:09 -0400
Date: Thu, 15 May 2008 09:38:07 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: David Miller <davem@davemloft.net>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org, pq@iki.fi, proski@gnu.org,
       sandmann@redhat.com, a.p.zijlstra@chello.nl, linuxppc-dev@ozlabs.org,
       paulus@samba.org, benh@kernel.crashing.org, srostedt@redhat.com
Subject: Re: [PATCH 2/2] ftrace: support for PowerPC
In-Reply-To: <20080514.222857.246967279.davem@davemloft.net>
Message-ID: <Pine.LNX.4.58.0805150935400.16421@gandalf.stny.rr.com>
References: <20080515034942.109223655@goodmis.org> <20080515035918.896765954@goodmis.org>
 <20080514.222857.246967279.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 14 May 2008, David Miller wrote:

> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Wed, 14 May 2008 23:49:44 -0400
>
> > +#ifdef CONFIG_FTRACE
> > +#ifdef CONFIG_DYNAMIC_FTRACE
> > +_GLOBAL(mcount)
> > +_GLOBAL(_mcount)
> > +	stwu	r1,-48(r1)
> > +	stw	r3, 12(r1)
> > +	stw	r4, 16(r1)
> > +	stw	r5, 20(r1)
> > +	stw	r6, 24(r1)
> > +	mflr	r3
> > +	stw	r7, 28(r1)
> > +	mfcr	r5
> > +	stw	r8, 32(r1)
> > +	stw	r9, 36(r1)
> > +	stw	r10,40(r1)
> > +	stw	r3, 44(r1)
> > +	stw	r5, 8(r1)
>
> Yikes, that's really expensive.

Well, at least with dynamic ftrace, it's only expensive when tracing is
enabled.

>
> Can't you do a tail call and let the function you end
> up calling do all the callee-saved register pops onto
> the stack?

Not sure PPC has such a thing. I'm only a hobby PPC hacker (did it full
time in another life). If there is such a way, I'll be happy to Ack any
patches.

>
> That's what I did on sparc.
>

So that was your secret! ;-)

-- Steve

