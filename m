Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbZBOWTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbZBOWTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 17:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZBOWTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 17:19:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:42609 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbZBOWTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 17:19:31 -0500
Date: Sun, 15 Feb 2009 14:19:31 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 1/7] async: Asynchronous function calls to speed up
 kernel boot
Message-ID: <20090215141931.32d512ce@infradead.org>
In-Reply-To: <20090215111636.5b6cc507@infradead.org>
References: <20090107151151.458333c1@infradead.org>
	<20090107151226.58264d07@infradead.org>
	<20090213162200.8fea7e0c.akpm@linux-foundation.org>
	<20090213205949.1ebb441d@infradead.org>
	<20090213232926.924d8740.akpm@linux-foundation.org>
	<20090215111636.5b6cc507@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Feb 2009 11:16:36 -0800
Arjan van de Ven <arjan@infradead.org> wrote:

> On Fri, 13 Feb 2009 23:29:26 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Fri, 13 Feb 2009 20:59:49 -0800 Arjan van de Ven
> > <arjan@infradead.org> wrote:
> > 
> > > On Fri, 13 Feb 2009 16:22:00 -0800
> > > Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > It means that sometimes, very rarely, the callback function will
> > > > be called within the caller's context.
> > > 
> > > for the cases that use it right now it is ok.
> > 
> > That doesn't mean it's any good!  There are only two callsites.
> 
> .. in mainline.
> There's a few more in various maintainer trees.
> 
> > 
> > Plus there's the issue which I mentioned: if someone _does_ call
> > this from atomic context they'll only find out about their bug when
> > the GFP_ATOMIC allocation fails.  This is bad!
> 
> as far as I know all current and pending callsites can deal with
> GFP_KERNEL, so I would just switch it to that for those; solves the
> entire issue. (I do need to check the suspend/resume speed
> improvements, S/R tends to be tricky with interrupts-off)
> 


btw if you have a poster child in the kernel that you would like to see
use the new stuff let me know; very often having one or two good use
cases makes the discussion and design a ton easier.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
