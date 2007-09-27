Return-Path: <linux-kernel-owner+w=401wt.eu-S1758247AbXI0RZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbXI0RZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 13:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757098AbXI0RZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 13:25:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45896 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753753AbXI0RZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 13:25:04 -0400
Date: Thu, 27 Sep 2007 10:23:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Correct SuS compliance for open of large file
 without options
Message-Id: <20070927102343.1a113ccc.akpm@linux-foundation.org>
In-Reply-To: <20070927155902.GA6450@thunk.org>
References: <20070927142919.10b62f9b@the-village.bc.nu>
	<20070927070118.2bd4792e@laptopd505.fenrus.org>
	<20070927151921.29b19abb@the-village.bc.nu>
	<20070927143548.GT5243@kernel.dk>
	<20070927154432.302ec5a7@the-village.bc.nu>
	<20070927150853.GA10154@kernel.dk>
	<20070927161912.2f08aff6@the-village.bc.nu>
	<20070927155902.GA6450@thunk.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 11:59:02 -0400 Theodore Tso <tytso@mit.edu> wrote:

> On Thu, Sep 27, 2007 at 04:19:12PM +0100, Alan Cox wrote:
> > > Well it's not my call, just seems like a really bad idea to change the
> > > error value. You can't claim full coverage for such testing anyway, it's
> > > one of those things that people will complain about two releases later
> > > saying it broke app foo.
> > 
> > Strange since we've spent years changing error values and getting them
> > right in the past. 
> 
> I doubt there any apps which are going to specifically check for EFBIG
> and do soemthing different if they get EOVERFLOW instead.  If it was
> something like EAGAIN or EPERM, I'd be more concerned, but EFBIG
> vs. EOVERFLOW?  C'mon!

Yeah.  There's no correct answer here (apart from "get it right the first
time").  There are risks either way, and it _is_ a bug.  Bummer.

> > There are real things to worry about - sysfs, sysfs, sysfs, ... and all
> > the other crap which is continually breaking stuff, not spec compliance
> > corrections that don't break things but move us into compliance with the
> > standard
> 
> I've got to agree with Alan, the sysfs/udev breakages that we've done
> are far more significant, and the fact that we continue to expose
> internal data structures via sysfs is a gaping open pit is far more
> likely to cause any kind of problems than changing an error return.

Funny you should mention that.  I was staring in astonishment at the
pending sysfs patch pile last night.  Forty syfs patches and twenty-odd
patches against driver core and the kobject layer.

That's a huge amount of churn for a core piece of kernel infrastructure
which has been there for four or five years.  Not a good sign.  I mean,
it's not as if, say, the CPU scheduler guys keep on rewriting all their
junk.

oh, wait..
