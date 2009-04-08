Return-Path: <linux-kernel-owner+w=401wt.eu-S933611AbZDHPLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933611AbZDHPLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933071AbZDHPKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:10:55 -0400
Received: from [212.69.161.110] ([212.69.161.110]:60923 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932926AbZDHPKx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:10:53 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Nikanth K <nikanth@gmail.com>
Subject: Re: [PATCH 03/12] DRBD: bitmap
Date: Wed, 8 Apr 2009 17:09:56 +0200
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Nikanth Karthikesan <knikanth@suse.de>
References: <1237823287-12734-1-git-send-email-philipp.reisner@linbit.com> <1237823287-12734-4-git-send-email-philipp.reisner@linbit.com> <807b3a220904080316s587ce988qdb47f231c8e90fbc@mail.gmail.com>
In-Reply-To: <807b3a220904080316s587ce988qdb47f231c8e90fbc@mail.gmail.com>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904081709.57289.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 April 2009 12:16:11 Nikanth K wrote:
> On Mon, Mar 23, 2009 at 9:17 PM, Philipp Reisner
>
> <philipp.reisner@linbit.com> wrote:
> > +/* definition of bits in bm_flags */
> > +#define BM_LOCKED 0
> > +#define BM_MD_IO_ERROR (BITS_PER_LONG-1) /* 31? 63? */
>
> Wonder whether this should be made same for 32-bit as well as 64-bit?
> Especially for x86_64 as the machine can become 32-bit to 64-bit or
> vice-versa after reboot.
>

This is only a bitnumber for an in memory flag word (bm_flags). 
I changed that to 

#define BM_LOCKED       0
#define BM_MD_IO_ERROR  1

What was before was just unnecessary complex.

>
> <snip>
>
> > +#if 0
> > +#define catch_oob_access_start() do {  \
> > +       do {                            \
> > +               if ((bm-p_addr) >= PAGE_SIZE/sizeof(long)) { \
> > +                       printk(KERN_ALERT "drbd_bitmap.c:%u %s: p_addr:%p
> > bm:%p %d\n", \ +                                       __LINE__ ,
> > __func__ , p_addr, bm, (bm-p_addr)); \ +                       break;    
> >      \
> > +               }
> > +#define catch_oob_access_end() \
> > +       } while (0); } while (0)
> > +#else
> > +#define catch_oob_access_start() do {
> > +#define catch_oob_access_end() } while (0)
> > +#endif
> > +
>
> Probably should be changed to be based on a config debug option?

I removed the macro definitions as well as these macro invocations.
They where used to find bugs years ago. Unnecessary nowadays.

> <snip>
>
> > +/*
> > + * since (b->bm_bits % BITS_PER_LONG) != 0,
> > + * this masks out the remaining bits.
> > + * Rerturns the number of bits cleared.
> > + */
> > +STATIC int bm_clear_surplus(struct drbd_bitmap *b)
> > +{
> > +       const unsigned long mask = (1UL << (b->bm_bits &
> > (BITS_PER_LONG-1))) - 1;
>
> Should BM_MD_IO_ERROR be used instead of  (BITS_PER_LONG-1)?
> Or at least this deserves a macro as it is used in many places.
>

Well, BITS_PER_LONG is now used in two functions only (after I
removed that from the definition of BM_MD_IO_ERROR). I will leave
it open coded, as it is now.

Thanks for these comments!

-Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

