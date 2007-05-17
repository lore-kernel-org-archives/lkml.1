Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbXEQKvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbXEQKvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 06:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbXEQKvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 06:51:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:41888 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbXEQKvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 06:51:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WwbqAScp0wD2WxS7ejadY/vKwwE2e0jDcWYFLfFpUBIpIQUxbN0GuEaChHhFV51sCa6tbAeGw2FJoXs3MLtQZCC3YrkaiZFx1RLekE2a++24ijEdxXCZky/CjRt+a901C+xZTJaxdpD7Y2OWWi/9dlvhVaAY6EOcvoMhMoiRs4E=
Subject: Re: [PATCH 10/10] [HEADS UP] fbdev: Move arch-specific bits to
	their respective subdirectories
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20070517094930.GA27627@infradead.org>
References: <464B78BC.4080900@gmail.com>
	 <20070517094930.GA27627@infradead.org>
Content-Type: text/plain
Date: Thu, 17 May 2007 18:51:22 +0800
Message-Id: <1179399082.4586.10.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 10:49 +0100, Christoph Hellwig wrote:
> On Thu, May 17, 2007 at 05:33:48AM +0800, Antonino A. Daplas wrote:
> > -#if defined(__sparc__) && !defined(__sparc_v9__)
> > -	/* Should never get here, all fb drivers should have their own
> > -	   mmap routines */
> > -	return -EINVAL;
> > -#else
> > -	/* !sparc32... */
> > +	if (fb_mmap_required())
> > +		return -EINVAL;
> > +
> 
> I don't like this bit.

Me too, actually. I did it this way because I don't want to deviate from
the old code too much. Since all sparc32 drivers are either linked to
sbuslib.c or has their own fb_mmap method, the above test is redundant. 
I'll leave the decision to remove the above test to David Miller.

>   It's just that all sparc frame buffers happen
> to have a mmap method but there's nothing fundamentally arch specific
> here.  You should be able to plug a pci video card into any linux
> supported machine provided the fb driver does the full setup (which
> only very few do in practice, but..)
> 
> So I'd just require drivers to have a fb_mmap method and make fb_mmap
> the default one.

This one is a tad bit more complicated, so I'll leave the present setup
for now. Once the arch-specific parts are properly separated, maybe I'll
take that step.
  
>   The page protection cleanup is still nice of course,
> but it might make sense to give it a more generic name as it's not
> really fb specific.

Any suggestion for a name? io_pgprotect() perhaps?

Tony


