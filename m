Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbYF3FD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbYF3FD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 01:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbYF3FDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 01:03:17 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:34128 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750878AbYF3FDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 01:03:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qUjudB9HEM1ITk1JxZF33wh+thb/FZi8etwrD0/ur/mBlPlLiKbWVIv4OX38RtA/52wLYyaZG4jAemkwJJdSFaMO5U8tvX2jdo0LjeDLti7JdZZnT8e9qwWClhrTKA/eYh2GgpGftOa7xDfOFNzSdqnWqaqX337IOyhW7XZ0jd4=  ;
X-YMail-OSG: H05KR7IVM1noKMMberqbY1x0.8msd23syVCVZURjlWoN77wzxtmlgh0F0nMQa1d3l26NAkNptYreaUfe9.P6cFr4_xp_1d1m7pIfBK7KqF5aJuhnH086P8dxAng5ga.nYQM-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Kyungmin Park" <kmpark@infradead.org>
Subject: Re: [patch 2.6.26-rc8+] mtd: dataflash OTP support
Date: Sun, 29 Jun 2008 22:03:14 -0700
User-Agent: KMail/1.9.9
Cc: "Bryan Wu" <cooloney@kernel.org>,
       "Michael Hennerich" <michael.hennerich@analog.com>,
       linux-mtd@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
References: <200806292019.53376.david-b@pacbell.net> <9c9fda240806292114m43d4e940h3346c03d92d65b32@mail.gmail.com>
In-Reply-To: <9c9fda240806292114m43d4e940h3346c03d92d65b32@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806292203.15123.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 June 2008, Kyungmin Park wrote:
> > +#ifdef CONFIG_MTD_OTP
> > +#define HAVE_OTP
> > +#endif
> > +
> > +#ifdef CONFIG_MTD_ONENAND_OTP
> > +#define HAVE_OTP
> > +#endif
> > +
> > +#ifdef CONFIG_MTD_DATAFLASH_OTP
> > +#define HAVE_OTP
> > +#endif
> > +
> 
> How about to add these at Kconfig like this,
> 
> config MTD_HAVE_OTP
>          bool
>          default n
> 
> and NOR, OneNAND, and DATAFLASH select MTD_HAVE_OTP if OTP support.

Shouldn't it be HAVE_MTD_OTP?

That'd be prettier, yes.  MTD_OTP would have been the obvious
choice for the generic symbol, but that's specific to CFI.
(And for that matter, CFI command set 1 ... I have set 2 chips
that can't yet expose their OTP data!)

I'd rather see that as a separate patch though -- either before
or after this one, I don't much care.

- Dave

