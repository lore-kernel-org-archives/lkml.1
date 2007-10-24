Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbXJXPSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbXJXPSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbXJXPSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:18:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51444 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752843AbXJXPSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:18:42 -0400
Date: Wed, 24 Oct 2007 08:16:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
In-Reply-To: <20071024091242.GK14671@kernel.dk>
Message-ID: <alpine.LFD.0.999.0710240814340.30120@woody.linux-foundation.org>
References: <20071022224343.4abf3c96@the-village.bc.nu>
 <alpine.LFD.0.999.0710221444220.30120@woody.linux-foundation.org>
 <471DBEF4.4030303@panasas.com> <20071023094142.GD5059@kernel.dk>
 <471DC3D9.2070809@panasas.com> <20071023095507.GE5059@kernel.dk>
 <471DCBB2.9020706@panasas.com> <alpine.LFD.0.999.0710230808260.30120@woody.linux-foundation.org>
 <20071024080549.GZ14671@kernel.dk> <Pine.LNX.4.64.0710241103000.5840@anakin>
 <20071024091242.GK14671@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Oct 2007, Jens Axboe wrote:
> > 
> > As it no longer sets the page only, perhaps it's a good idea to rename
> > sg_set_page() to sg_set()?
> 
> sg_set_buf() also sets length and offset, sg_set_page() is just a mirror
> of that. So I'd prefer to keep the naming.

I agree. And it's not like you can get it wrong, since if you only give 
the "page" argument, the preprocessor will complain loudly.

I think "sg_set_x()" is now rather logical - we fill in the SG entry 
(entirely), and the only question is _how_ we do it (which is what "x" 
says - using a page, or a kernel buffer).

		Linus
