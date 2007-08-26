Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbXHZWKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbXHZWKa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 18:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932090AbXHZWKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 18:10:20 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:13273 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbXHZWKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 18:10:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ejPJBNZWWTfr0UYCJh5Wx77qjtH52e6IhMg5u3sB18dSw5XvurSWtjF1LkBiH5LNF8F94Y+mTWlXF6+oajzplgS1ByCsWLlbBo5MFjP1DrtxBxLso8baV1NDcbDRQ+g1Zz/L5btRFB2D5T/Bo1lOen6YXzXL/xzGeNwbLv80aps=
Message-ID: <9a8748490708261510u6f373d2s760bef86e81bbe02@mail.gmail.com>
Date: Mon, 27 Aug 2007 00:10:17 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [PATCH 09/30] mtd: Don't cast kmalloc() return value in drivers/mtd/maps/pmcmsp-flash.c
Cc: "Denys Vlasenko" <vda.linux@googlemail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       linux-mtd@lists.infradead.org, "David Woodhouse" <dwmw2@infradead.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0708261635080.15614@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
	 <9a8748490708251728h51d51092r11a3562ceb63b2f9@mail.gmail.com>
	 <Pine.LNX.4.64.0708252021070.8721@localhost.localdomain>
	 <200708261528.56250.vda.linux@googlemail.com>
	 <Pine.LNX.4.64.0708261635080.15614@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/08/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Aug 26 2007 15:28, Denys Vlasenko wrote:
> >> >
> >> > What exactely would using kcalloc() over kzalloc() here buy us?
> >>
> >> technically, nothing.
> >
> >The idea of calloc is that it can check for underflow in parameter.
>
> Actually, overflow.
>
> calloc(0xFFFF0000,  0x1000) => will return NULL
> malloc(0xFFFF0000 * 0x1000) => silent 32 bit multiplication/truncation,
> will allocate less than requested.
>
> >calloc(-1, 10000000) => easy to detect
> >malloc(-1 * 10000000) => malloc(-10000000) => not so trivial
>
Ok, that makes a bit of sense. Thank you.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
