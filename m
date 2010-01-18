Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030Ab0ARPk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab0ARPk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 10:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873Ab0ARPk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 10:40:28 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33574 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753475Ab0ARPk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 10:40:27 -0500
Date: Mon, 18 Jan 2010 15:41:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org, akpm@linux-foundation.org,
       andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
Message-ID: <20100118154149.38fa61d4@lxorguk.ukuu.org.uk>
In-Reply-To: <1263828247.4283.612.camel@laptop>
References: <20100118133755.GG30698@redhat.com>
	<84144f021001180609r4d7fbbd0p972d5bc0e227d09a@mail.gmail.com>
	<20100118141938.GI30698@redhat.com>
	<20100118143232.0a0c4b4d@lxorguk.ukuu.org.uk>
	<1263826198.4283.600.camel@laptop>
	<20100118150159.GB14345@redhat.com>
	<1263827194.4283.609.camel@laptop>
	<4B547A31.4090106@redhat.com>
	<1263827683.4283.610.camel@laptop>
	<4B547C09.8010906@redhat.com>
	<1263828247.4283.612.camel@laptop>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010 16:24:07 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2010-01-18 at 17:19 +0200, Avi Kivity wrote:
> > > I would not advice that, just mlock() the text and data you need for the
> > > real-time thread. mlockall() is a really blunt instrument.
> > >    
> > 
> > May not be feasible due to libraries. 
> 
> Esp for the real-time case I could advise not to use those libraries
> then, since they're clearly not designed for that use case.

In "hard" real time cases an awful lot of libraries have things like
memory allocations in them and don't care about stack growth which can
cause faults and sleeps. The memory allocator if you are running threaded
was not real time priority aware either last time I checked so the
standard libraries are not going to give the behaviour you want unless
you have a proper RT environment, and even then it may be a bit iffy here
and there.

