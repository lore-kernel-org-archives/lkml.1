Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbZFFLJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbZFFLJF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 07:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZFFLIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 07:08:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:7317 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZFFLIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 07:08:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DC+7yibSljVNw5k9yb4mKf8Cxr+xX4JZw7arIQGMelzj80U5hm+iUalV441ytGoDya
         RGqc8VeAEG1DjOqHDXZ31CTGU4RMK6DbIfFIOglGp02HZT26gdIAgNS2fyeXYE5NHMJ5
         rYHdGR2JoUZsFjs/QPMh0GggIOLVYEeD9KtKI=
Subject: Re: [PATCH] no need for checking it
From: "Figo.zhang" <figo1802@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Ian Abbott <abbotti@mev.co.uk>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       David Schleef <ds@schleef.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <84144f020906060356v20cb0f8bk83e702de751f9f5e@mail.gmail.com>
References: <1244285472.3185.36.camel@myhost>
	 <84144f020906060356v20cb0f8bk83e702de751f9f5e@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 19:08:19 +0800
Message-Id: <1244286499.3185.39.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-06 at 13:56 +0300, Pekka Enberg wrote:
> On Sat, Jun 6, 2009 at 1:51 PM, Figo.zhang <figo1802@gmail.com> wrote:
> > vfree() does it's own NULL checking,so no need for check before
> > calling it.
> >
> > Signed-off-by: Figo.zhang <figo1802@gmail.com>
> > ---
> >  drivers/staging/comedi/drivers.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/staging/comedi/drivers.c
> > b/drivers/staging/comedi/drivers.c
> > index 6e13e45..ce50e85 100644
> > --- a/drivers/staging/comedi/drivers.c
> > +++ b/drivers/staging/comedi/drivers.c
> > @@ -495,9 +495,9 @@ int comedi_buf_alloc(struct comedi_device *dev,
> > struct comedi_subdevice *s,
> >                                vmap(pages, n_pages, VM_MAP,
> >                                PAGE_KERNEL_NOCACHE);
> >                }
> > -               if (pages) {
> > -                       vfree(pages);
> > -               }
> > +               vfree(pages);
> > +               pages = NULL;
> 
> Why the assignment to NULL? It looks redundant to me.
> 
> > +
> >                if (async->prealloc_buf == NULL) {
> >                        /* Some allocation failed above. */
> >                        if (async->buf_page_list) {
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >

yes, 'pages' is local variable argment,it is no need assignment to NULL.

Best Regards,

Figo.zhang

