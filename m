Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbZDPNgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbZDPNgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 09:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbZDPNgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 09:36:12 -0400
Received: from [212.69.161.110] ([212.69.161.110]:59980 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbZDPNgL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 09:36:11 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 07/14] DRBD: internal_data_structures
Date: Thu, 16 Apr 2009 15:35:13 +0200
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andi Kleen <andi@firstfloor.org>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
References: <1239365545-10356-1-git-send-email-philipp.reisner@linbit.com> <1239365545-10356-8-git-send-email-philipp.reisner@linbit.com> <e2e108260904120944t1d0fec44yccbc50b6246988d0@mail.gmail.com>
In-Reply-To: <e2e108260904120944t1d0fec44yccbc50b6246988d0@mail.gmail.com>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904161535.14501.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 April 2009 18:44:53 Bart Van Assche wrote:
> On Fri, Apr 10, 2009 at 2:12 PM, Philipp Reisner
>
> <philipp.reisner@linbit.com> wrote:
> > diff -uNrp linux-2.6.30-rc1/drivers/block/drbd/drbd_int.h
> > linux-2.6.30-rc1-drbd/drivers/block/drbd/drbd_int.h
>
> ...
>
> > +#define PRINTK(level, fmt, args...) \
> > +       printk(level "drbd%d: " fmt, \
> > +               mdev->minor , ##args)
>
> The above looks similar to dev_printk() from <linux/device.h>. It
> would be great if some of the DRBD-specific macro's could be replaced
> by existing Linux macro's. This would improve the readability of the
> DRBD source code.
>

Ok. I have done that. Although the dev_err() family of function produce
log that precedes each line with the word "block". Rather useless, but
okay. No more DRBD specific INFO() ERR() macros.

http://git.drbd.org/?p=linux-2.6-drbd.git;a=commit;h=54d19bcccce597742c8883c2b372f0d799dd3c67

> ...
>
> > +#define D_ASSERT(exp)  if (!(exp)) \
> > +        ERR("ASSERT( " #exp " ) in %s:%d\n", __FILE__, __LINE__)
> > +
> > +#define ERR_IF(exp) if (({                             \
> > +       int _b = (exp) != 0;                            \
> > +       if (_b) ERR("%s: (%s) in %s:%d\n",              \
> > +               __func__, #exp, __FILE__, __LINE__);    \
> > +        _b;                                            \
> > +       }))
>
> How about replacing invocations of D_ASSERT() and/or ERR_IF() by WARN_ON()
> ?

I would rather prefer to keep the ASSERT() semantic, since that is a 
widely used concept. -- The existing kernel code already has quite a
few definition of subsystem's incarnation of ASSERTS variants. ;)

Removing ERR_IF() goes onto the TODO list.

-phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

