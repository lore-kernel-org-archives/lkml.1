Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbYH0STV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbYH0STV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 14:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYH0STL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 14:19:11 -0400
Received: from tesla.selinc.com ([12.110.71.2]:44362 "EHLO tesla.selinc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbYH0STK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 14:19:10 -0400
In-Reply-To: <1219815617.18027.132.camel@sauron>
To: dedekind@infradead.org
Cc: Bruce Leonard <brucle@earthlink.net>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, linux-mtd-bounces@lists.infradead.org
Subject: Re: [PATCH 2/2] Add support for > 2GiB MTD devices
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.3 September 26, 2007
Message-ID: <OF5BDBDD21.E5375C78-ON882574B2.0061B127-882574B2.00648B63@selinc.com>
From: Bruce_Leonard@selinc.com
Date: Wed, 27 Aug 2008 11:18:23 -0700
X-MIMETrack: Serialize by Router on Edison2/SEL(Release 7.0.3|September 26, 2007) at 08/27/2008
 11:18:26 AM,
	Serialize complete at 08/27/2008 11:18:26 AM
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem,

> > +/*
> > + * Inline function for determining the size of the MTD device, 
independant
> > + * of old or new way of doing things.
> > + *
> > + */
> > +static inline u_int64_t device_size(struct mtd_info *a)
> > +{
> > +   return a->num_eraseblocks == 0 ? a->size : a->num_eraseblocks * 
a->erasesize;
> > +}
> 
> I do not think it is a good idea to do multiplication every time we need
> MTD device size. It is unnecessarily large overhead in terms of speed
> and code size.
> 

I'm still reluctant to change size to a 64-bit value.  There's a vague 
recolection of early conversations on the list that there would be little 
acceptance for that.  And that probably has to do with the ongoing 
conversation about ABI changes.  What I could do to eliminate the 
multiplication is introduce the same concept that the NAND layer uses, 
shift values.  After all, erasesize should always be a power of 2, making 
that a power of 2 multiplication which can be done via shifts.  By 
changing erasesize to erasesize_shift, I'd get something like this:

return a->num_eraseblocks == 0 ? a->size : a->num_eraseblocks << 
a->erasesize_shift

How would that suit you?

Bruce

