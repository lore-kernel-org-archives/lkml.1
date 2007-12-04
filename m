Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbXLDIAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbXLDIAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 03:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbXLDIAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 03:00:36 -0500
Received: from hs-out-0708.google.com ([64.233.178.250]:61661 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751739AbXLDIAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 03:00:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QF5PrSA/dS3kQQ5G4QURMFvxr/2sGjB3yAIXk1dZAUrd4gQT4+OBo9JhU3KzIB49CEEOvBit4sRfpCztEP13NKhsFycj17PFkwqnq7gP6Btr+pDHn3kt/p0im2TQegkwQYN97zZwXMUr+PM8zEvXjYhVfzMLcfXXPQcThno4zLI=
Message-ID: <a8e1da0712040000n7f94c5bbk3e6526ed395d62d@mail.gmail.com>
Date: Tue, 4 Dec 2007 16:00:33 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] pktcdvd : add kobject_put when kobject register fails
Cc: petero2@telia.com, linux-kernel@vger.kernel.org
In-Reply-To: <84144f020712032345r6fc1f44cg5f35b23bdb8191be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071204013144.GA2850@darkstar.lan>
	 <84144f020712032345r6fc1f44cg5f35b23bdb8191be@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 4, 2007 3:45 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Hi Dave,
>
> On Dec 4, 2007 3:31 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
> > Kobject_put should be called when kobject register functioin fails, so the
> > the kobj ref count touch zero and then the proper cleanup routines will be
> > called.
>
> [snip]
>
> > diff -upr linux/drivers/block/pktcdvd.c linux.new/drivers/block/pktcdvd.c
> > --- linux/drivers/block/pktcdvd.c       2007-11-30 13:13:44.000000000 +0800
> > +++ linux.new/drivers/block/pktcdvd.c   2007-11-30 13:24:08.000000000 +0800
> > @@ -117,8 +117,10 @@ static struct pktcdvd_kobj* pkt_kobj_cre
> >         p->kobj.parent = parent;
> >         p->kobj.ktype = ktype;
> >         p->pd = pd;
> > -       if (kobject_register(&p->kobj) != 0)
> > +       if (kobject_register(&p->kobj) != 0) {
> > +               kobject_put(&p->kobj);
> >                 return NULL;
>
> This looks wrong to me. AFAICT the only thing that can fail
> kobject_register() is kobject_add() and it cleans up after itself. Am
> I missing something here?

Hi,
the kobject reference is get in kobject_init, and then kobject_add, if
kobject_add fail, it will only cleanup the reference got by itsself.

This topic is discussed in:
http://lkml.org/lkml/2007/11/30/9

Regards
dave
>
>                            Pekka
>
