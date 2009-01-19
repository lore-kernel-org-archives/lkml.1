Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbZASFQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbZASFQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 00:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZASFQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 00:16:46 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:4459 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbZASFQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 00:16:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZLmb2ogKp5Jk0t/RkqS5CJhix9OQNZjWeqZIpd/U+bTaCQH51zSluWrMxAlmQV2NdV
         1XGetRxtesuVEDLgC/Wj29umntFnFEKhExcg/rtaQz8LKwsqIM0jITQrjHf6I9EjV+h9
         AphK+t89IgGXB0KAKpE7OpwmE0HN3qL9LC78A=
MIME-Version: 1.0
In-Reply-To: <20090119144811.d1da89a4.sfr@canb.auug.org.au>
References: <1232273454.23100.9.camel@localhost.localdomain>
	 <20090119105324.fd4e9084.sfr@canb.auug.org.au>
	 <1232332274.3129.9.camel@localhost.localdomain>
	 <20090119144811.d1da89a4.sfr@canb.auug.org.au>
Date: Mon, 19 Jan 2009 10:46:43 +0530
Message-ID: <3f9a31f40901182116r7381dfaeg64530f02e0c0ae31@mail.gmail.com>
Subject: Re: [GIT PULL -tip] fix 41 'make headers_check' warnings
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,

On Mon, Jan 19, 2009 at 9:18 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> > >
>> > > diff --git a/include/linux/pktcdvd.h b/include/linux/pktcdvd.h
>> > > index 04b4d73..277de8c 100644
>> > > --- a/include/linux/pktcdvd.h
>> > > +++ b/include/linux/pktcdvd.h
>> > > @@ -33,11 +33,15 @@
>> > >   * able to sucessfully recover with this option (drive will return good
>> > >   * status as soon as the cdb is validated).
>> > >   */
>> > > +#ifdef __KERNEL__
>> > >  #if defined(CONFIG_CDROM_PKTCDVD_WCACHE)
>> > >  #define USE_WCACHING             1
>> > >  #else
>> > >  #define USE_WCACHING             0
>> > >  #endif
>> > > +#else /* __KERNEL__ */
>> > > +#define USE_WCACHING             0
>> > > +#endif /* __KERNEL__ */
>> >
>> > This also only has one user (drivers/block/pktcdvd.c) so maybe it should
>> > be moved there.
>> >
>>
>> Already fixed in v3 as pointed by Ingo.
>
> I was actually suggesting that you move the whole
>
> #if defined(CONFIG_CDROM_PKTCDVD_WCACHE)
> #define USE_WCACHING            1
> #else
> #define USE_WCACHING            0
> #endif
>
> into drivers/block/pktcdvd.c as that is the only place USE_WCACHING is
> used.
>

hmm, this is the out of scope of this patch and should be send in
different patch.

I think maintainers can handle this issue.

If they need my help, they can ping me ;-)

Thanks,

JSR
