Return-Path: <linux-kernel-owner+w=401wt.eu-S1761268AbXKODLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761268AbXKODLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 22:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756456AbXKODLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 22:11:13 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:31814 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813AbXKODLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 22:11:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Sz9nJxIV8oysId88FuJCFOOI+GvEXHeO6w5sHBlN92aQCV8ewwGtiFcYd4OVVAU8wYO0J+bx7Q83vFRkCL+FD9FNqtYjmL3yKab3zcbh2CSR8Zeqy7JBcCgoVv5svpY3wOHJdzg03w4Mmd3ey1vliWRuJ5AQSkoQx77rMPHnCi0=
Message-ID: <a8e1da0711141911h52b4e91bo86c07073d5dd2c6d@mail.gmail.com>
Date: Thu, 15 Nov 2007 11:11:10 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: 2.6.24-rc2-mm1
Cc: "Jiri Kosina" <jikos@jikos.cz>, "Greg KH" <greg@kroah.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1195094293.2731.14.camel@lov.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	 <a8e1da0711132247jd440f8dgc9ac0442e90f2c34@mail.gmail.com>
	 <20071114004129.783fb98b.akpm@linux-foundation.org>
	 <a8e1da0711140136i1e441371j306e7b2888de104e@mail.gmail.com>
	 <20071114165906.GB13889@kroah.com> <1195065493.2168.31.camel@lov.site>
	 <Pine.LNX.4.64.0711142018390.15844@twin.jikos.cz>
	 <1195075663.2609.2.camel@lov.site>
	 <a8e1da0711141701xc66109dv93ad2c3d2b76ebec@mail.gmail.com>
	 <1195094293.2731.14.camel@lov.site>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 15, 2007 10:38 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
>
> On Thu, 2007-11-15 at 09:01 +0800, Dave Young wrote:
> > On Nov 15, 2007 5:27 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> > > On Wed, 2007-11-14 at 20:19 +0100, Jiri Kosina wrote:
> > > > On Wed, 14 Nov 2007, Kay Sievers wrote:
> > > >
> > > > > Could it be an init-order problem, where something tries to use the
> > > > > block subsystem? Before it is initialized with:
> > > > >   block/genhd.c :: subsys_initcall(genhd_device_init);
> > > > > If that's the case, we have an old bug that nobody noticed with static
> > > > > structures, which are zeroed that time, but definitely not properly
> > > > > initialized. I'll try to build loop non-modular now, and see if that
> > > > > makes the bug appear here.
> > >
> > > > my .config with which I reproduc this on 2.6.24-rc2-mm1 reliably can be
> > > > obtained from http://www.jikos.cz/jikos/junk/.config
> > >
> > > Hmm, that config doesn't do anything here, and if I make it boot, it
> > > does not show the bug.
> > >
> > > Could you possibly enable kobject debugging and see if that exposes
> > > something, maybe something goes wrong with the kset refcount and it gets
> > > released while in use.
> > >
> > Hi,
> > I would do that.
>
> That would be great.
>
> > BTW, The bug report as EIP  at __list_add with CONFIG_DEBUG_LIST=y
>
> Yeah, that hints that the kset, which contains the list, is not
> allocated at the time it is used, or it is already released (kfree)
> again by some buggy logic.
>
> All this could not happen before, as the kset was statically in memory.
> It may be an old bug, that just never crashed anything. We already fixed
> a bunch of similar things, that showed up while doing this patch set.
>
Now with the DEBUG_KOBJECT set , nothing more info.
But this time the EIP is at the strnlen (called by printk -- line 239
of kobject.c)

EIP is at strnlen +0x9/0x20
EAX 6b6b6b6b EBX c05487c14 ecx 6b6b6b6b EDX fffffffe
---cut---

If you need more infomation, I will copy more (no camera in hand)

Regards
dave
