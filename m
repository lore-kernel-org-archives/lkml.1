Return-Path: <linux-kernel-owner+w=401wt.eu-S1761190AbXHXP4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761190AbXHXP4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 11:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbXHXP4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 11:56:15 -0400
Received: from waste.org ([66.93.16.53]:44976 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029AbXHXP4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 11:56:15 -0400
Date: Fri, 24 Aug 2007 10:57:13 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Ingo Oeser <ioe-lkml@rameria.de>, lode leroy <lode_leroy@hotmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memchr (trivial) optimization
Message-ID: <20070824155713.GL21720@waste.org>
References: <BAY105-F323FF3DC8E6C544A2BBE98FFD50@phx.gbl> <200708230213.21332.ioe-lkml@rameria.de> <20070824001351.GA20266@waste.org> <Pine.LNX.4.64.0708241447560.28540@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708241447560.28540@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 02:54:48PM +0200, Jan Engelhardt wrote:
> 
> On Aug 23 2007 19:13, Matt Mackall wrote:
> >
> >And you can do even better with this:
> >
> >void *memchr(const void *s, int c, size_t n)
> >{
> >       const unsigned char *p = s, *e = s + n;
> >       const unsigned char *e = p + n;
> 
> Uhm, you have two "e"s in there.

Yep, that's what I get for editing in email.

> Or do it glibc-style
> 
> void *memchr(const void *s, unsigned char c, size_t n)
> {
> 	...
> 	for (; p + 3 < e; p += 4) {
> 		if (c == p[0])
> 			return (void *)&p[0];
> 		if (c == p[1])
> 			return (void *)&p[1];
> 		if (c == p[2])
> 			return (void *)&p[2];
> 		if (c == p[3])
> 			return (void *)&p[3];
> 	}
> 	... /* check the rest */
> }

Yes, very funny.

-- 
Mathematics is the supreme nostalgia of our time.
