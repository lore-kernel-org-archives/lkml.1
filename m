Return-Path: <linux-kernel-owner+w=401wt.eu-S934797AbXHZA2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934797AbXHZA2x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 20:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932540AbXHZA2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 20:28:44 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:19362 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765238AbXHZA2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 20:28:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tBVDdc9mZBU2AYRkbpuZrDb1k4ss/wvAesygO/BQhEueN46KhPa7dMC2IkpA9PFsc+XYZy5MwvUv6tlAqaI9SKngzy4eNdrGJFnpXIdGXrxNVEJQ8KSsNUcH6Ej25h3Jx+T2Q/Wcv5RLANjTcKpjq1/ubAgUO5SYS+2f39gk1u0=
Message-ID: <9a8748490708251728h51d51092r11a3562ceb63b2f9@mail.gmail.com>
Date: Sun, 26 Aug 2007 02:28:42 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH 09/30] mtd: Don't cast kmalloc() return value in drivers/mtd/maps/pmcmsp-flash.c
Cc: "Denys Vlasenko" <vda.linux@googlemail.com>,
       "David Woodhouse" <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0708251956380.29507@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
	 <5ebfb93eca0dd43cf17876e643079cbcfeb3111c.1187912217.git.jesper.juhl@gmail.com>
	 <200708241141.06358.vda.linux@googlemail.com>
	 <Pine.LNX.4.64.0708240642500.18301@localhost.localdomain>
	 <9a8748490708251527n26cc2065n5b8716bd7f65e252@mail.gmail.com>
	 <Pine.LNX.4.64.0708251956380.29507@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/08/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> On Sun, 26 Aug 2007, Jesper Juhl wrote:
>
> > On 24/08/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
>
> > > actually, i would think kcalloc would be more appropriate here, no?
> > >
> >
> > Why?
> >
> > msp_parts[i] = kzalloc(pcnt * sizeof(struct mtd_partition), GFP_KERNEL);
> >
> > seems better to me than
> >
> > msp_parts[i] = kcalloc(1, pcnt * sizeof(struct mtd_partition), GFP_KERNEL);
>
> i was thinking more along the lines of
>
> msp_parts[i] = kcalloc(pcnt, sizeof(struct mtd_partition), GFP_KERNEL);
>
> which was kind of the obvious implication, no?

I guess

> unless there's a
> reason kcalloc() wouldn't work here, this is pretty much what
> kcalloc() was designed for.
>
When Denys brought up the zeroing thing and mentioned kzalloc() I did
consider kcalloc() instead, but kzalloc() makes this allocation nicely
look like the preceding ones visually and I couldn't convince myself
that kcalloc() would give us any real benefit here.

What exactely would using kcalloc() over kzalloc() here buy us?

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
