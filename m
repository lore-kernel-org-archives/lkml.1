Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbXJXJNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbXJXJNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 05:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbXJXJMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 05:12:47 -0400
Received: from brick.kernel.dk ([87.55.233.238]:3122 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbXJXJMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:12:45 -0400
Date: Wed, 24 Oct 2007 11:12:42 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
Message-ID: <20071024091242.GK14671@kernel.dk>
References: <20071022224343.4abf3c96@the-village.bc.nu> <alpine.LFD.0.999.0710221444220.30120@woody.linux-foundation.org> <471DBEF4.4030303@panasas.com> <20071023094142.GD5059@kernel.dk> <471DC3D9.2070809@panasas.com> <20071023095507.GE5059@kernel.dk> <471DCBB2.9020706@panasas.com> <alpine.LFD.0.999.0710230808260.30120@woody.linux-foundation.org> <20071024080549.GZ14671@kernel.dk> <Pine.LNX.4.64.0710241103000.5840@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710241103000.5840@anakin>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24 2007, Geert Uytterhoeven wrote:
> On Wed, 24 Oct 2007, Jens Axboe wrote:
> > On Tue, Oct 23 2007, Linus Torvalds wrote:
> > > My biggest complaint right now is that a lot of users of the sg *filling* 
> > > functions were mindlessly converted, so we have code like
> > > 
> > > 	cryptoloop.c:             sg_set_page(&sg_in, in_page);
> > > 	cryptoloop.c:             sg_in.offset = in_offs;
> > > 	cryptoloop.c:             sg_in.length = sz;
> > > 
> > > which is just really stupid, and we should have a function for that. But 
> > > worse is code like this:
> > > 
> > > 	ub.c:     sg_set_page(sg, virt_to_page(sc->top_sense));
> > > 	ub.c:     sg->offset = (unsigned long)sc->top_sense & (PAGE_SIZE-1);
> > > 	ub.c:     sg->length = UB_SENSE_SIZE;
> > > 
> > > which again was converted "line by line" and we actually *do* have a 
> > > function to do the above three lines as
> > > 
> > > 	sg_set_buf(sg, sc->top_sense, UB_SENSE_SIZE);
> > > 
> > > where that *single* line is just tons shorter but more importantly, more 
> > > readable, than the mess that is a brute-force conversion.
> > 
> > I modified sg_set_page() to take a length and offset argument, and
> 
> As it no longer sets the page only, perhaps it's a good idea to rename
> sg_set_page() to sg_set()?

sg_set_buf() also sets length and offset, sg_set_page() is just a mirror
of that. So I'd prefer to keep the naming.

-- 
Jens Axboe

