Return-Path: <linux-kernel-owner+w=401wt.eu-S1760845AbXGJU61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760845AbXGJU61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbXGJU6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:58:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34042 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbXGJU6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:58:19 -0400
Date: Tue, 10 Jul 2007 21:58:18 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Adel Gadllah <adel.gadllah@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix sparse problems with ARRAY_SIZE
Message-ID: <20070710205817.GR21668@ftp.linux.org.uk>
References: <4693AE32.7030403@gmail.com> <4693AF4C.8010005@gmail.com> <20070710194033.GB5751@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710194033.GB5751@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 11:40:33PM +0400, Alexey Dobriyan wrote:
> On Tue, Jul 10, 2007 at 06:09:48PM +0200, Adel Gadllah wrote:
> > --- linux-2.6.orig/include/linux/kernel.h
> > +++ linux-2.6/include/linux/kernel.h
> > @@ -35,7 +35,11 @@ extern const char linux_proc_banner[];
> >  #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
> >  #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
> >  
> > +#ifdef __CHECKER_
> > +#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
> > +#else
> >  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
> > +#endif
> 
> Al Viro recently gave a hint that he have patches for sparse to not give
> spurious ARRAY_SIZE warnings.

I do.  Right now it's either 2 or 4 patches away from mainline sparse,
depending on reordering...  I'm splitting the last patch in series,
hopefully will reorder and send tonight.

Basically, it's a matter of getting __builtin_compatible_types_p()
implementation (really - evaluate.c:type_difference()) somewhere sane.
