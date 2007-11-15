Return-Path: <linux-kernel-owner+w=401wt.eu-S1763791AbXKOBBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763791AbXKOBBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 20:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbXKOBB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 20:01:29 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:32320 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbXKOBB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 20:01:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JVr9nwkz2xREd0Kddv7BygriWhHJZaDB4x6KZq/bR/oRGL1i0gCEMZK96ckQoApaGOvic0fobGHFZVI0Zew8xghta6kPkz341GZRNqxsJZr2ylLPVJ2Q/g5e7LLo+C6Hvgi2h1dU96bKdA3SpMhpVfrz4pOBf4izgNH2iuGaPIM=
Message-ID: <a8e1da0711141701xc66109dv93ad2c3d2b76ebec@mail.gmail.com>
Date: Thu, 15 Nov 2007 09:01:27 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: 2.6.24-rc2-mm1
Cc: "Jiri Kosina" <jikos@jikos.cz>, "Greg KH" <greg@kroah.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1195075663.2609.2.camel@lov.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	 <a8e1da0711132218h9d944d0p3c22ac313ee667a9@mail.gmail.com>
	 <20071113223802.2ace1a61.akpm@linux-foundation.org>
	 <a8e1da0711132247jd440f8dgc9ac0442e90f2c34@mail.gmail.com>
	 <20071114004129.783fb98b.akpm@linux-foundation.org>
	 <a8e1da0711140136i1e441371j306e7b2888de104e@mail.gmail.com>
	 <20071114165906.GB13889@kroah.com> <1195065493.2168.31.camel@lov.site>
	 <Pine.LNX.4.64.0711142018390.15844@twin.jikos.cz>
	 <1195075663.2609.2.camel@lov.site>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 15, 2007 5:27 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Wed, 2007-11-14 at 20:19 +0100, Jiri Kosina wrote:
> > On Wed, 14 Nov 2007, Kay Sievers wrote:
> >
> > > Could it be an init-order problem, where something tries to use the
> > > block subsystem? Before it is initialized with:
> > >   block/genhd.c :: subsys_initcall(genhd_device_init);
> > > If that's the case, we have an old bug that nobody noticed with static
> > > structures, which are zeroed that time, but definitely not properly
> > > initialized. I'll try to build loop non-modular now, and see if that
> > > makes the bug appear here.
>
> > my .config with which I reproduc this on 2.6.24-rc2-mm1 reliably can be
> > obtained from http://www.jikos.cz/jikos/junk/.config
>
> Hmm, that config doesn't do anything here, and if I make it boot, it
> does not show the bug.
>
> Could you possibly enable kobject debugging and see if that exposes
> something, maybe something goes wrong with the kset refcount and it gets
> released while in use.
>
Hi,
I would do that.
BTW, The bug report as EIP  at __list_add with CONFIG_DEBUG_LIST=y

Regards
dave
