Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbYDOSeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbYDOSeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 14:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbYDOSeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 14:34:04 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:64042 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbYDOSeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 14:34:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ezwKE8hTbmqLwAXNrpZXC1BHWxfqbfszynW2sVx45RZvY2bDZUwRzoCzGdoXQaz5yNoBI9402jaDva1PJYduii0gWSOYh7SMlQHr1Bev8Ipg0B5cH3uF03oQ2K0oLzD157lc5lB2axhn+21zRjJO6Mt4HdG9SnIEJjgXlKiPauo=
Message-ID: <b6c5339f0804151133j42f5b676t6093def2c006be2@mail.gmail.com>
Date: Tue, 15 Apr 2008 14:33:35 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [PATCH 2/7] omfs: add inode routines
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <E1JlpVW-0000Qy-JJ@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1208041121-26787-3-git-send-email-me@bobcopeland.com>
	 <E1JlpVW-0000Qy-JJ@pomaz-ex.szeredi.hu>
X-Google-Sender-Auth: 137f60b507327ad9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 2:03 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Hmm, looks like error handling needs a makeover if this is really to
>  become example code.  See comments inline.

Thanks for the review Miklos.

>  > +     mark_buffer_dirty(bh);
>  > +     if (wait) {
>  > +             sync_dirty_buffer(bh);
>  > +             if (buffer_req(bh) && !buffer_uptodate(bh))
>  > +                     ret = -EIO;
>
>  Hmm, here it sets ret, but doesn't exit.  Deliberate?

It was - if sync fails, it should still try writing the mirrors.  Plus
bh and bh2 get released subsequently.

>  > +             iget_failed(inode);
>  > +             return ERR_PTR(-EIO);
>
>  Should be:
>
>         if (!bh)
>                 goto iget_failed;

Nod.

>  > +out:
>  > +     ret = -EINVAL;
>  > +

>  > +     if (bh)
>  > +             brelse(bh);
>
>  This is weird.  This should be done by jumping to the proper label
>  between the brleses.

Hrm, brelse(NULL) is allowed so the check is suspect anyway.  I did
this in a couple of other places, so I'll fix those up too.

Thanks!

-- 
Bob Copeland %% www.bobcopeland.com
