Return-Path: <linux-kernel-owner+w=401wt.eu-S1759023AbZE3Inz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759023AbZE3Inz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 04:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZE3Ins
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 04:43:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751531AbZE3Ins (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 04:43:48 -0400
Date: Sat, 30 May 2009 01:43:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vvscore@gmail.com
Subject: Re: [PATCH] 8250: Fix oops from setserial
Message-Id: <20090530014311.93577673.akpm@linux-foundation.org>
In-Reply-To: <20090530092557.57578dd5@lxorguk.ukuu.org.uk>
References: <20090528130132.19582.65165.stgit@t61.ukuu.org.uk>
	<20090529205429.c9c73b19.akpm@linux-foundation.org>
	<20090530092557.57578dd5@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 May 2009 09:25:57 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > 
> > >  static void set_io_from_upio(struct uart_port *p)
> > >  {
> > > +	struct uart_8250_port *up = (struct uart_8250_port *)p;
> > 
> > container_of() is nicer, IMO.  It's clearer, and doesn't require that
> > the uart_port be the fist member.
> 
> See the rest of the driver - it was written that way years ago and this
> is just following the existing design.

Sure, huge numbers of drivers use the cast.

But I've never seen past sinnings as being a reason to continue sinning. 
Doing new code the right way doesn't result in worse code, and reduces
the chances of someone copying and pasting the wrong way.
