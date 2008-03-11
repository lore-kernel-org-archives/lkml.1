Return-Path: <linux-kernel-owner+w=401wt.eu-S1757085AbYCKMR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085AbYCKMR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 08:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbYCKMRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 08:17:21 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:40331 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbYCKMRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 08:17:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ByaJRLKszC0S83GJyuT5NPJppqI6nbAClbeTFZTt6qlkIDcIVdyOaumvdpNUmx6WcgSmWbJgJ+yadJbWNiN5GlvusgfHZxD9xiLRrsPiQEeUze+3PH2bF+mCiV7QOOyejfvMdN7ED1JX0Gh0geYIzySjz3o0rjloiI0APrdxEyw=
Message-ID: <961aa3350803110517o6abc7fc4rf4a0f241f5351b9c@mail.gmail.com>
Date: Tue, 11 Mar 2008 21:17:05 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Joe Perches" <joe@perches.com>
Subject: Re: [PATCH 1/5] lib: introduce call_once()
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <1205162940.656.152.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080310145704.GA6396@APFDCB5C>
	 <1205162940.656.152.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/3/11, Joe Perches <joe@perches.com>:
> On Mon, 2008-03-10 at 23:57 +0900, Akinobu Mita wrote:
>  > +++ 2.6-rc/include/linux/once.h
>
> > +struct once_control {
>  > +     struct mutex lock;
>  > +     int done;
>
>
> bool?

Yes, this definetly should be bool.

>  > +};
>  > +
>  > +#define __ONCE_INITIALIZER(name) {                                   \
>  > +             .lock           = __MUTEX_INITIALIZER(name.lock),       \
>  > +             .done           = 0,                                    \
>  > +     }
>  > +
>  > +#define DEFINE_ONCE(name) struct once_control name = __ONCE_INITIALIZER(name)
>
>
> static?

no, static keyword should not be implicitly added in this macro.
DEFINE_ONCE is intended to be anologous to DEFINE_LOCK, DEFINE_WAIT,
and all other similar interfaces in kernel.

>  > +
>  > +extern int call_once_slow(struct once_control *once_control,
>  > +                       int (*init_rouine)(void));
>
>
> return bool?

call_once() returns error-code when init_routine fails.

>  spelling: s/rouine/routine/g

Oops, thanks.
