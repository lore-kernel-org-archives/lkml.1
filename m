Return-Path: <linux-kernel-owner+w=401wt.eu-S1762098AbXEQUai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762098AbXEQUai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761212AbXEQUaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:30:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56689
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758651AbXEQUaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:30:06 -0400
Date: Thu, 17 May 2007 13:30:03 -0700 (PDT)
Message-Id: <20070517.133003.63739733.davem@davemloft.net>
To: adaplas@gmail.com
Cc: hch@infradead.org, akpm@osdl.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] [HEADS UP] fbdev: Move arch-specific bits to
 their respective subdirectories
From: David Miller <davem@davemloft.net>
In-Reply-To: <1179399082.4586.10.camel@daplas>
References: <464B78BC.4080900@gmail.com>
	<20070517094930.GA27627@infradead.org>
	<1179399082.4586.10.camel@daplas>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Antonino A. Daplas" <adaplas@gmail.com>
Date: Thu, 17 May 2007 18:51:22 +0800

> On Thu, 2007-05-17 at 10:49 +0100, Christoph Hellwig wrote:
> > On Thu, May 17, 2007 at 05:33:48AM +0800, Antonino A. Daplas wrote:
> > > -#if defined(__sparc__) && !defined(__sparc_v9__)
> > > -	/* Should never get here, all fb drivers should have their own
> > > -	   mmap routines */
> > > -	return -EINVAL;
> > > -#else
> > > -	/* !sparc32... */
> > > +	if (fb_mmap_required())
> > > +		return -EINVAL;
> > > +
> > 
> > I don't like this bit.
> 
> Me too, actually. I did it this way because I don't want to deviate from
> the old code too much. Since all sparc32 drivers are either linked to
> sbuslib.c or has their own fb_mmap method, the above test is redundant. 
> I'll leave the decision to remove the above test to David Miller.

Feel free to remove it.
