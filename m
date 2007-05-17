Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbXEQJtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbXEQJtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 05:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbXEQJtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 05:49:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37021 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbXEQJtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 05:49:41 -0400
Date: Thu, 17 May 2007 10:49:30 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/10] [HEADS UP] fbdev: Move arch-specific bits to their respective subdirectories
Message-ID: <20070517094930.GA27627@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"Antonino A. Daplas" <adaplas@gmail.com>,
	Andrew Morton <akpm@osdl.org>,
	Linux Fbdev development list <linux-fbdev-devel@lists.sourceforge.net>,
	Linux Kernel Development <linux-kernel@vger.kernel.org>
References: <464B78BC.4080900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464B78BC.4080900@gmail.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 05:33:48AM +0800, Antonino A. Daplas wrote:
> -#if defined(__sparc__) && !defined(__sparc_v9__)
> -	/* Should never get here, all fb drivers should have their own
> -	   mmap routines */
> -	return -EINVAL;
> -#else
> -	/* !sparc32... */
> +	if (fb_mmap_required())
> +		return -EINVAL;
> +

I don't like this bit.  It's just that all sparc frame buffers happen
to have a mmap method but there's nothing fundamentally arch specific
here.  You should be able to plug a pci video card into any linux
supported machine provided the fb driver does the full setup (which
only very few do in practice, but..)

So I'd just require drivers to have a fb_mmap method and make fb_mmap
the default one.  The page protection cleanup is still nice of course,
but it might make sense to give it a more generic name as it's not
really fb specific.

