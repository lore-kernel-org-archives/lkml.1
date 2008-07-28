Return-Path: <linux-kernel-owner+w=401wt.eu-S1762958AbYG1VWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762958AbYG1VWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761858AbYG1VUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:20:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:43479 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762104AbYG1VUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:20:13 -0400
Subject: Re: warning in scheduler
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stephen@blacksapphire.com, benm@symmetric.co.nz, jkosina@suse.cz
In-Reply-To: <20080728183911.GC16059@parisc-linux.org>
References: <1217214947.11188.156.camel@pasglop>
	 <1217238791.6331.15.camel@twins> <1217239403.11188.189.camel@pasglop>
	 <20080728100752.GA4717@elte.hu> <1217241622.11188.191.camel@pasglop>
	 <20080728183911.GC16059@parisc-linux.org>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 07:19:16 +1000
Message-Id: <1217279956.11188.221.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 12:39 -0600, Matthew Wilcox wrote:
> On Mon, Jul 28, 2008 at 08:40:22PM +1000, Benjamin Herrenschmidt wrote:
> > I tend to agree. I might look into doing it for powerpc around rc3 or
> > so, when things have settled a bit.
> 
> It'd be nice if allmodconfig even compiled:
> 
> drivers/char/pcmcia/ipwireless/hardware.c:571: error: invalid use of undefined type 'struct ipw_network'
> 
> Not to mention the qla_attr patch:
> 
> +#include <linux/delay.h>
> 
> There's probably others, I just haven't got far enough in the
> compilation process yet.

Yup, it's been a pretty bad merge window (at least it's my impression as
my first one as maintainer), mostly fixing compile bugs all the time.

> But I am seeing lots of warnings _without_ the patch applied:
> 
> fs/omfs/inode.c: In function 'omfs_fill_super':
> fs/omfs/inode.c:495: warning: format '%llx' expects type 'long long
> unsigned int', but argument 2 has type 'u64'
> fs/proc/base.c: In function 'do_io_accounting':
> fs/proc/base.c:2429: warning: format '%llu' expects type 'long long
> unsigned int', but argument 3 has type 'u64'
> fs/ubifs/dir.c: In function 'ubifs_readdir':
> fs/ubifs/dir.c:437: warning: format '%llu' expects type 'long long
> unsigned int', but argument 5 has type '__le64'
> 
> (other warnings snipped for brevity).

I have a handful on powerpc too.

BTW. I'm looking at adding a %pR to print a struct resource (or maybe
a %pr for a resource_size_t and %pR for the whole resource). That would
help with the whole business of the thing being either 32 or 64 bits.

Ben.


