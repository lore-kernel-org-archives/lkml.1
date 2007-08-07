Return-Path: <linux-kernel-owner+w=401wt.eu-S967056AbXHGVvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967056AbXHGVvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966241AbXHGV3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:29:02 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:15054 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966231AbXHGV3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:29:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YXfewfKbFzkqNLGUfjaEoV9tHdvsF7vfuzqJ7FlWS8m6R8UG0XZexY3xsgEI/5JG/r1FKOwj0xygkN2CWX/dcJ/QnrvoSyUwswQlFVePEKQP4tbaNoqoLlipehrQ5Az/48K94O5RlwYM5nrfFEq5hZfHqYVwaadZlewKKFdq4F8=
Message-ID: <9a8748490708071428i7aa2289bi90045a8b07fbf816@mail.gmail.com>
Date: Tue, 7 Aug 2007 23:28:58 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH][RESEND] Semi-pointless NULL test in uli526x driver
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Valerie Henson" <val@nmt.edu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       tulip-users@lists.sourceforge.net, "Kyle McMartin" <kyle@mcmartin.ca>,
       david@lang.hm, "Grant Grundler" <grundler@parisc-linux.org>
In-Reply-To: <46B8E2BE.1050408@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708042032.12317.jesper.juhl@gmail.com>
	 <46B8E2BE.1050408@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/07, Jeff Garzik <jeff@garzik.org> wrote:
> Jesper Juhl wrote:
> > (resending previously submitted patch from 16/7-2007 22:40)
> >
> >
> > Hi,
> >
> > In drivers/net/tulip/uli526x.c::uli526x_interrupt() there's a test
> > of the function argument 'void *dev_id' against NULL. But that
> > test is pretty pointless, since if ever 'dev_id' is NULL we'll
> > already have crashed inside "netdev_priv(dev)".
> >
> > I don't think dev_id can ever actually be NULL, so the whole block
> > inside "if (!dev) {" could probably just go away. But I guess
> > there's a good reason someone put that ULI526X_DBUG() in there - and
> > if 'dev_id' /can/ actually be NULL then it's nice to have and in
> > that case this patch actually fixes a possible crash (hence the
> > version number update).
> > So I guess that in this case we should just move the
> > "db = netdev_priv(dev)" assignment past that NULL test. That's what
> > this patch does.
> >
> > Found by the Coverity checker.
> > Compile tested.
> >
> >
> > PS. Please keep me on Cc when replying.
> >
> >
> > Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
>
> Just remove the dev==NULL test...
>

Hmm, it would seem there's some disagreement about that :

On 04/08/07, Kyle McMartin <kyle@mcmartin.ca> wrote:
...
>
> It *can* be null, in the case of another handler being registered on the
> same irq number, passing NULL for the cookie.
>
> Ack. Will apply.
>
> Regards,
>         Kyle
>

I'll let you and Kyle fight it out :-)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
