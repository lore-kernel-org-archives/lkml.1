Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbZGMReO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbZGMReO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 13:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756528AbZGMReO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 13:34:14 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:32042 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbZGMReN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 13:34:13 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [perfmon2] I.1 - System calls - ioctl
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: perfmon2-devel@lists.sourceforge.net,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, eranian@gmail.com,
       Philip Mucci <mucci@eecs.utk.edu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <200907131930.23840.arnd@arndb.de>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	 <20090622125837.GA9429@infradead.org> <1247482393.7529.74.camel@twins>
	 <200907131930.23840.arnd@arndb.de>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 19:34:00 +0200
Message-Id: <1247506440.7500.43.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-13 at 19:30 +0200, Arnd Bergmann wrote:
> On Monday 13 July 2009, Peter Zijlstra wrote:
> > On Mon, 2009-06-22 at 08:58 -0400, Christoph Hellwig wrote:
> > > But talking about syscalls the sys_perf_counter_open prototype is
> > > really ugly - it uses either the pid or cpu argument which is a pretty
> > > clear indicator it should actually be two sys calls.
> > 
> > Would something like the below be any better?
> > 
> > It would allow us to later add something like PERF_TARGET_SOCKET and
> > things like that.
> 
> I don't think it helps on the ugliness side. You basically make the
> two arguments a union, but instead of adding another flag and directly
> passing a union, you also add interface complexity.
> 
> A strong indication for the complexity is that you got it wrong ;-) :
> 
> > +struct perf_counter_target {
> > +	__u32			id;
> > +	__u64			val;
> > +};
> 
> This structure is not compatible between 32 and 64 bit user space on x86,
> because everything except i386 adds implicit padding between id and val.

Humm, __u64 doesn't have natural alignment? That would break more than
just this I think -- it sure surprises me.

> Other than that, making it extensible sounds reasonable. How about just
> using a '__u64 *target' and a bit in the 'flags' argument?

Would there still be a point in having it a pointer in that case?, but
yeah, that might work too?

