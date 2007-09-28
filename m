Return-Path: <linux-kernel-owner+w=401wt.eu-S1760755AbXI1GlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760755AbXI1GlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 02:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbXI1GlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 02:41:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38438 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753694AbXI1GlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 02:41:18 -0400
Date: Thu, 27 Sep 2007 23:39:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Nadia.Derbey@bull.net, adobriyan@sw.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm1 1/2] fixing idr_find() locking
Message-Id: <20070927233944.347aaecd.akpm@linux-foundation.org>
In-Reply-To: <20070928063144.GB1767@ff.dom.local>
References: <20070927143354.663489000@bull.net>
	<20070927143458.674281000@bull.net>
	<20070928063144.GB1767@ff.dom.local>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 08:31:44 +0200 Jarek Poplawski <jarkao2@o2.pl> wrote:

> On Thu, Sep 27, 2007 at 04:33:55PM +0200, Nadia.Derbey@bull.net wrote:
> > [PATCH 01/02]
> > 
> > 
> > This is a patch that fixes the way idr_find() used to be called in ipc_lock():
> > in all the paths that don't imply an update of the ipcs idr, it was called
> > without the idr tree being locked.
> > 
> > The changes are:
> >   . in ipc_ids, the mutex has been changed into a reader/writer semaphore.
> >   . ipc_lock() now takes the mutex as a reader during the idr_find().
> >   . a new routine ipc_lock_down() has been defined: it doesn't take the
> >     mutex, assuming that it is being held by the caller. This is the routine
> >     that is now called in all the update paths.
> > 
> > 
> > Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
> 
> Acked-by: Jarek Poplawski <jarkao2@o2.pl>

thanks.

> PS: there is one big mistake around To/Cc ordering, so I doubt Andrew
> will ever sign this...

Noe, I received and applied it earlier today.
