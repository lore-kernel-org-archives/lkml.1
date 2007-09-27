Return-Path: <linux-kernel-owner+w=401wt.eu-S1758546AbXI0P7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbXI0P7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944AbXI0P71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:59:27 -0400
Received: from THUNK.ORG ([69.25.196.29]:50656 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbXI0P70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:59:26 -0400
Date: Thu, 27 Sep 2007 11:59:02 -0400
From: Theodore Tso <tytso@mit.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>, Arjan van de Ven <arjan@infradead.org>,
       akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Correct SuS compliance for open of large file without options
Message-ID: <20070927155902.GA6450@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jens Axboe <jens.axboe@oracle.com>,
	Arjan van de Ven <arjan@infradead.org>, akpm@osdl.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070927142919.10b62f9b@the-village.bc.nu> <20070927070118.2bd4792e@laptopd505.fenrus.org> <20070927151921.29b19abb@the-village.bc.nu> <20070927143548.GT5243@kernel.dk> <20070927154432.302ec5a7@the-village.bc.nu> <20070927150853.GA10154@kernel.dk> <20070927161912.2f08aff6@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927161912.2f08aff6@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 04:19:12PM +0100, Alan Cox wrote:
> > Well it's not my call, just seems like a really bad idea to change the
> > error value. You can't claim full coverage for such testing anyway, it's
> > one of those things that people will complain about two releases later
> > saying it broke app foo.
> 
> Strange since we've spent years changing error values and getting them
> right in the past. 

I doubt there any apps which are going to specifically check for EFBIG
and do soemthing different if they get EOVERFLOW instead.  If it was
something like EAGAIN or EPERM, I'd be more concerned, but EFBIG
vs. EOVERFLOW?  C'mon!

> There are real things to worry about - sysfs, sysfs, sysfs, ... and all
> the other crap which is continually breaking stuff, not spec compliance
> corrections that don't break things but move us into compliance with the
> standard

I've got to agree with Alan, the sysfs/udev breakages that we've done
are far more significant, and the fact that we continue to expose
internal data structures via sysfs is a gaping open pit is far more
likely to cause any kind of problems than changing an error return.

       	  	    	    	     	  - Ted
