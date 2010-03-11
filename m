Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab0CKHVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 02:21:43 -0500
Received: from mail.perches.com ([173.55.12.10]:1640 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab0CKHVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 02:21:42 -0500
Subject: Re: [PATCH 4/5] fs: fat: use hex_asc_lo/hex_asc_hi instead of
 custom one
From: Joe Perches <joe@perches.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <87aaufvk7w.fsf@devron.myhome.or.jp>
References: <1268261495-686-1-git-send-email-andy.shevchenko@gmail.com>
	 <1268261495-686-2-git-send-email-andy.shevchenko@gmail.com>
	 <1268261495-686-3-git-send-email-andy.shevchenko@gmail.com>
	 <1268261495-686-4-git-send-email-andy.shevchenko@gmail.com>
	 <1268261495-686-5-git-send-email-andy.shevchenko@gmail.com>
	 <87aaufvk7w.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Mar 2010 23:21:40 -0800
Message-ID: <1268292100.11761.1.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 08:18 +0900, OGAWA Hirofumi wrote:
> Andy Shevchenko <andy.shevchenko@gmail.com> writes:
> 
> >  			if (uni_xlate == 1) {
> > -				*op = ':';
> > -				for (k = 4; k > 0; k--) {
> > -					nc = ec & 0xF;
> > -					op[k] = nc > 9	? nc + ('a' - 10)
> > -							: nc + '0';
> > -					ec >>= 4;
> > -				}
> > -				op += 5;
> > +				*op++ = ':';
> > +				*op++ = hex_asc_hi(ec >> 8);
> > +				*op++ = hex_asc_lo(ec >> 8);
> > +				*op++ = hex_asc_hi(ec);
> > +				*op++ = hex_asc_lo(ec);
> >  				len -= 5;
> 
> Why doesn't this use pack_hex_byte()?

or snprintf


