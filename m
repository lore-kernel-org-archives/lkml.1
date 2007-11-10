Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbXKJTpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbXKJTpY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 14:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbXKJTpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 14:45:10 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:55343 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbXKJTpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 14:45:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=E6iTzMkxvxQTw5arex3efVHmFIFi1MMqcHRUO8k12gDKPtdrDIo0XuCwBGvUqvpWrFn4eQ7bPGko2UVNBt3maV5qtuv0X2JlNwRB+JgzudGvPJQ6QIl5auP0WFo8e8v+ULG3T61XZ9DAYSmN9+x+jpWqqeSCUsm/9pFU+zUcr8o=
Message-ID: <1865922a0711101145g768fe96p74b400e31f4120a1@mail.gmail.com>
Date: Sat, 10 Nov 2007 21:45:06 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: "Jakob Oestergaard" <jakob@unthought.net>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser(2)
Cc: "Casey Schaufler" <casey@schaufler-ca.com>, akpm@osdl.org,
       torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Al Viro" <viro@ftp.linux.org.uk>
In-Reply-To: <20071110170557.GA21977@unthought.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu>
	 <20071105005625.GA18030@ubuntu> <20071110170557.GA21977@unthought.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 10, 2007 7:05 PM, Jakob Oestergaard <jakob@unthought.net> wrote:
> ...
> > I've double-checked the code for any possible off-by-one/overflow
> > errors.
> ...
>
> Two things caught my eye.
>
> ...
> > +             case bol:
> > +             case subject:
> > +                     if (*label_len >= SMK_MAXLEN)
> > +                             goto out;
> > +                     subjectstr[(*label_len)++] = data[i];
>
> Why is the '>' necessary?  Could it happen that you had incremented past the
> point of equality?
>
> If that could not happen, then in my oppinion '>=' is very misleading when '=='
> is really what is needed.
>

Indeed, you're absolutely right.

> ...
> > +             case object:
> > +                     if (*prevstate == blank) {
> > +                             subjectstr[*label_len] = '\0';
> > +                             *label_len = 0;
> > +                     }
>
> I wonder why it is valid to uncritically use the already incremented label_len
> here, without checking its value (like is done above).
>
> It seems strangely asymmetrical. I'm not saying it's wrong, because there may
> be a subtle reason as to why it's not, but if that's the case then I think that
> subtle reason should be documented with a comment.
>

Maximum value label_len could reach is "SMK_MAXLEN". The subjectstr
and objectstr arrays are of "SMK_MAXLEN + 1" length. So I think no
danger is here.

Yes, this deserved a comment.

> ...
> > +             case access:
> > +                     if (*prevstate == blank) {
> > +                             objectstr[*label_len] = '\0';
> > +                             *label_len = 0;
> > +                     }
>
> Same applies here.
>
>  / jakob
>

Good spots, thanks a lot for the review.

Regards,

-- 
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
