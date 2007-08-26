Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbXHZO3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbXHZO3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 10:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbXHZO3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 10:29:09 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:20566 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbXHZO3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 10:29:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=dI8xtK0x7TlXWeMY69sj5NLs+wRPzFIFQXrhPe7UR7X3kO7o2LfJdmbEc8i7yB093/bXRIU34TD3QhrqlFVoiuDl14QJx+Z3bLt2AlxlaCpNc/QNuj82HPVOw0PNUvRo5Y6xlKLrKBT5NB47tI43BisDCNpxJh3l3poLpTPGqoc=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH 09/30] mtd: Don't cast kmalloc() return value in drivers/mtd/maps/pmcmsp-flash.c
Date: Sun, 26 Aug 2007 15:28:56 +0100
User-Agent: KMail/1.9.1
Cc: Jesper Juhl <jesper.juhl@gmail.com>, linux-mtd@lists.infradead.org,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com> <9a8748490708251728h51d51092r11a3562ceb63b2f9@mail.gmail.com> <Pine.LNX.4.64.0708252021070.8721@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0708252021070.8721@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708261528.56250.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 August 2007 01:23, Robert P. J. Day wrote:
> On Sun, 26 Aug 2007, Jesper Juhl wrote:
> > On 26/08/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> > > i was thinking more along the lines of
> > >
> > > msp_parts[i] = kcalloc(pcnt, sizeof(struct mtd_partition), GFP_KERNEL);
> > >
> > > which was kind of the obvious implication, no?
> >
> > I guess
> >
> > > unless there's a reason kcalloc() wouldn't work here, this is
> > > pretty much what kcalloc() was designed for.
> >
> > When Denys brought up the zeroing thing and mentioned kzalloc() I
> > did consider kcalloc() instead, but kzalloc() makes this allocation
> > nicely look like the preceding ones visually and I couldn't convince
> > myself that kcalloc() would give us any real benefit here.
> >
> > What exactely would using kcalloc() over kzalloc() here buy us?
>
> technically, nothing.

The idea of calloc is that it can check for underflow in parameter.

calloc(-1, 10000000) => easy to detect
malloc(-1 * 10000000) => malloc(-10000000) => not so trivial
--
vda
