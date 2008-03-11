Return-Path: <linux-kernel-owner+w=401wt.eu-S1756474AbYCKEvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbYCKEvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 00:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbYCKEvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 00:51:33 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:19249 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbYCKEvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 00:51:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lRpOgGF5b+2kifZSBMVLWDpKuedVgT9XPmVpveg+zD2qVwfs6p4kwmyDnVZYSw7HQrOLdMG0SWnAP00bJMkzY2f5an8P7U9NsGomfzQW2ETeZnuaR2M0SlhVDMyYeRG63Tnq9sVUD3fs80ibF/n4/9l6Gp8D3ElGbyQu5tgPLqY=
Message-ID: <a8e1da0803102151y125f497x4d7fd57374c59b29@mail.gmail.com>
Date: Tue, 11 Mar 2008 12:51:29 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v3] Add time_is_after_jiffies and others which compare with jiffies
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hannes@saeurebad.de, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20080311121553.6214.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080310012202.GA2958@darkstar.te-china.tietoenator.com>
	 <20080311121553.6214.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 11:17 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi
>
>  Why don't you make jiffies_64 stuff?

Actually, I greped the kernel source, and found none of time_*64 usage.

After grep again, I found a missed one in:
arch/x86/kernel/cpu/mcheck/therm_throt.c

        if (time_before64(tmp_jiffs, __get_cpu_var(next_check)))
                return 0;

Does it really need time_before64 here?

If it does need then I wonder whether the other 64 macros may be
removed, or just to add a time_is_before64_jiffies

>
>
>
>
>
>  > Most of time_after like macros usages just compare jiffies and
>  > another number, so here add some time_is_* macros for convenience.
>  >
>  > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>  >
>  > ---
>  > include/linux/jiffies.h |   16 ++++++++++++++++
>  > 1 file changed, 16 insertions(+)
>  >
>  > diff -upr linux/include/linux/jiffies.h linux.new/include/linux/jiffies.h
>  > --- linux/include/linux/jiffies.h     2008-03-07 10:40:04.000000000 +0800
>  > +++ linux.new/include/linux/jiffies.h 2008-03-10 09:11:36.000000000 +0800
>  > @@ -135,6 +135,22 @@ static inline u64 get_jiffies_64(void)
>  >  #define time_before_eq64(a,b)        time_after_eq64(b,a)
>  >
>  >  /*
>  > + * These four macros compare jiffies and 'a' for convenience.
>  > + */
>  > +
>  > +/* time_is_before_jiffies(a) return true if a is before jiffies */
>  > +#define time_is_before_jiffies(a) time_after(jiffies, a)
>  > +
>  > +/* time_is_after_jiffies(a) return true if a is after jiffies */
>  > +#define time_is_after_jiffies(a) time_before(jiffies, a)
>  > +
>  > +/* time_is_before_eq_jiffies(a) return true if a is before or equal to jiffies*/
>  > +#define time_is_before_eq_jiffies(a) time_after_eq(jiffies, a)
>  > +
>  > +/* time_is_after_eq_jiffies(a) return true if a is after or equal to jiffies*/
>  > +#define time_is_after_eq_jiffies(a) time_before_eq(jiffies, a)
>  > +
>  > +/*
>  >   * Have the 32 bit jiffies value wrap 5 minutes after boot
>  >   * so jiffies wrap bugs show up earlier.
>  >   */
>  > --
>  > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  > the body of a message to majordomo@vger.kernel.org
>  > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  > Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
