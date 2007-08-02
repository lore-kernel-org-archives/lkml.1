Return-Path: <linux-kernel-owner+w=401wt.eu-S1760289AbXHBUDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289AbXHBUDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 16:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbXHBUDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 16:03:06 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:59572 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537AbXHBUDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 16:03:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pFDe7V2GPszLdTz2FJmM25LmboqmYao+yBjvyv4Be7ozGM4hY/mEzqMrmKQJ6gucyg/s1jbYfbmfhDvxz7fL0BYUYuxTzHcq2BmDofgG91c4u5MsF2kqkzu898H6+KKcfLdYRrNsc8L3F0dM23Ez6plgxsM/A8a4yTyP+h/KAK4=
Message-ID: <9a8748490708021303h683a8be7if194a9314483c218@mail.gmail.com>
Date: Thu, 2 Aug 2007 22:03:03 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: gcc fixed size char array initialization bug - known?
Cc: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708022157310.9319@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
	 <Pine.LNX.4.64.0708022157310.9319@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Aug 2 2007 21:55, Guennadi Liakhovetski wrote:
> >Hi
> >
> >I've run across the following gcc "feature":
> >
> >       char c[4] = "01234";
> >
> >gcc emits a nice warning
> >
> >warning: initializer-string for array of chars is too long
> >
> >But do a
> >
> >       char c[4] = "0123";
> >
> >and - a wonder - no warning. No warning with gcc 3.3.2, 3.3.5, 3.4.5,
> >4.1.2. I was told 4.2.x does produce a warning. Now do a
> >
> >       struct {
> >               char c[4];
> >               int i;
> >       } t;
> >       t.i = 0x12345678;
> >       strcpy(t.c, c);
> >
> >and t.i is silently corrupted. Just wanted to ask if this is known,
> >really...
>
> What does this have to do with the kernel? The string "0123" is
> generally _five_ characters long, so c[4] is not enough.
> Or use strncpy.
>
I believe Guennadi's point is that gcc does not warn about it in the
case of  c[4] = "0123"; but only in the case of c[4] = "01234" - so if
we do have such initializations in the kernel we may have some bugs
hiding there that gcc doesn't warn us about.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
