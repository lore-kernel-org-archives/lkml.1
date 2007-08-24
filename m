Return-Path: <linux-kernel-owner+w=401wt.eu-S933457AbXHXM4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933457AbXHXM4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765781AbXHXMyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:54:50 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44161 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765126AbXHXMys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:54:48 -0400
Date: Fri, 24 Aug 2007 14:54:48 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Matt Mackall <mpm@selenic.com>
cc: Ingo Oeser <ioe-lkml@rameria.de>, lode leroy <lode_leroy@hotmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memchr (trivial) optimization
In-Reply-To: <20070824001351.GA20266@waste.org>
Message-ID: <Pine.LNX.4.64.0708241447560.28540@fbirervta.pbzchgretzou.qr>
References: <BAY105-F323FF3DC8E6C544A2BBE98FFD50@phx.gbl>
 <200708230213.21332.ioe-lkml@rameria.de> <20070824001351.GA20266@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 23 2007 19:13, Matt Mackall wrote:
>
>And you can do even better with this:
>
>void *memchr(const void *s, int c, size_t n)
>{
>       const unsigned char *p = s, *e = s + n;
>       const unsigned char *e = p + n;

Uhm, you have two "e"s in there.

>       for (; p < e ; p++)
>                if ((unsigned char)c == *p)
>                        return (void *)p;
>
>       return NULL;
>}

Or do it glibc-style

void *memchr(const void *s, unsigned char c, size_t n)
{
	...
	for (; p + 3 < e; p += 4) {
		if (c == p[0])
			return (void *)&p[0];
		if (c == p[1])
			return (void *)&p[1];
		if (c == p[2])
			return (void *)&p[2];
		if (c == p[3])
			return (void *)&p[3];
	}
	... /* check the rest */
}


	Jan
-- 
