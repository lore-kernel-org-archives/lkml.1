Return-Path: <linux-kernel-owner+w=401wt.eu-S933103AbZDHPL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103AbZDHPL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763997AbZDHPKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:10:54 -0400
Received: from [212.69.161.110] ([212.69.161.110]:60921 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932543AbZDHPKx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:10:53 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Nikanth K <nikanth@gmail.com>
Subject: Re: [PATCH 01/12] DRBD: lru_cache
Date: Wed, 8 Apr 2009 17:09:54 +0200
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Nikanth Karthikesan <knikanth@suse.de>
References: <1237823287-12734-1-git-send-email-philipp.reisner@linbit.com> <1237823287-12734-2-git-send-email-philipp.reisner@linbit.com> <807b3a220904080315r7277dd68t1abd08b6c5a830dd@mail.gmail.com>
In-Reply-To: <807b3a220904080315r7277dd68t1abd08b6c5a830dd@mail.gmail.com>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904081709.55481.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 April 2009 12:15:13 Nikanth K wrote:
> On Mon, Mar 23, 2009 at 9:17 PM, Philipp Reisner
>
> <philipp.reisner@linbit.com> wrote:
> > +/* this is developers aid only! */
> > +#define PARANOIA_ENTRY() BUG_ON(test_and_set_bit(__LC_PARANOIA,
> > &lc->flags)) +#define PARANOIA_LEAVE() do { clear_bit(__LC_PARANOIA,
> > &lc->flags); smp_mb__after_clear_bit(); } while (0) +#define RETURN(x...)
> >     do { PARANOIA_LEAVE(); return x ; } while (0) +
>
> The PARANOIA_LEAVE is used for void functions, so RETURN can be
> changed to take a simple non-variadic argument. Or empty RETURN()
> could be used everywhere instead of mixing PARANOIA_LEAVE() and
> RETURN(). Just to make it consistent.

Ok, using the RETURN() now everywhere.

> Also this could be made as nop based on some config debug option?
>

It is a very cheap debugging code, setting and clearing a single bit, just
to make sure the function calls of the lru-cache API are used in the right
order.

Since it is that cheap I decided to have it permanently in, but if 
I get that hint twice, I will change it into a config debug option.

-Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

