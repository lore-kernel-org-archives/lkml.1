Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445Ab0ARPCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab0ARPCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 10:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729Ab0ARPCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 10:02:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336Ab0ARPCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 10:02:41 -0500
Date: Mon, 18 Jan 2010 17:01:59 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mm@kvack.org, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       akpm@linux-foundation.org, andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
Message-ID: <20100118150159.GB14345@redhat.com>
References: <20100118133755.GG30698@redhat.com>
 <84144f021001180609r4d7fbbd0p972d5bc0e227d09a@mail.gmail.com>
 <20100118141938.GI30698@redhat.com>
 <20100118143232.0a0c4b4d@lxorguk.ukuu.org.uk>
 <1263826198.4283.600.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263826198.4283.600.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 03:49:58PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-18 at 14:32 +0000, Alan Cox wrote:
> > > this kind of control. As of use of mlockall(MCL_FUTURE) how can I make
> > > sure that all memory allocated behind my application's back (by dynamic
> > > linker, libraries, stack) will be locked otherwise?
> > 
> > If you add this flag you can't do that anyway - some library will
> > helpfully start up using it and then you are completely stuffed or will
> > be back in two or three years adding MLOCKALL_ALWAYS.
> 
> Agreed, mlockall() is a very bad interface and should not be used for a
> plethora of reasons, this being one of them.
> 
There are valid uses for mlockall() and even if the interface is bad there
is no alternative right now, so why not fix one of it problems?

> The thing is, if you cant trust your library to do sane things, then
> don't use it.
> 
Agreed, the are things that sane library should never do: exit() or output
debug info to stdio or meddle with memory mlock/munlock behind application's
back.

--
			Gleb.
