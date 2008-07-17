Return-Path: <linux-kernel-owner+w=401wt.eu-S1755079AbYGQEPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbYGQEPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 00:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbYGQEO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 00:14:59 -0400
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:47715 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbYGQEO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 00:14:57 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jul 2008 00:14:57 EDT
From: Vadim Lobanov <vlobanov@speakeasy.net>
To: Soumyadip Das Mahapatra <soumya.linux@yahoo.com>
Subject: Re: [PATCH] : A better approach to compute int_sqrt in lib/int_sqrt.c
Date: Wed, 16 Jul 2008 21:08:14 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <848307.13278.qm@web59505.mail.ac4.yahoo.com>
In-Reply-To: <848307.13278.qm@web59505.mail.ac4.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807162108.14349.vlobanov@speakeasy.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 July 2008 02:35:56 pm Soumyadip Das Mahapatra wrote:
> > >   */
> > >  unsigned long int_sqrt(unsigned long x)
> > >  {
> > > -    unsigned long op, res, one;
> > > -
> > > -    op = x;
> > > -    res = 0;
> > > -
> > > -    one = 1UL << (BITS_PER_LONG - 2);
> > > -    while (one > op)
> > > -        one >>= 2;
> > > -
> > > -    while (one != 0) {
> > > -        if (op >= res + one) {
> > > -            op = op - (res + one);
> > > -            res = res +  2 * one;
> > > -        }
> > > -        res /= 2;
> > > -        one /= 4;
> > > -    }
> > > -    return res;
> > > +    unsigned long ub, lb, m;
> > > +    lb = 1;                /* lower bound */
> > > +    ub = (x >> 5) + 8;        /* upper bound */
> > > +    do {
> > > +        m = (ub + lb) >>  1;    /* middle value */
> > > +        if((m * m) > x)
> > > +            ub = m - 1;
> > > +        else
> > > +            lb = m + 1;
> > > +    } while(ub >= lb);
> > > +
> > > +    return lb - 1;
> > >  }
> > >  EXPORT_SYMBOL(int_sqrt);
>
> 0 It is better because
>          o contains no division operator (older version has two)
>             which are surely comparatively slow task in computer

Actually, the old version has zero division operators; those are simply 
right-shifts.

-- Vadim Lobanov
