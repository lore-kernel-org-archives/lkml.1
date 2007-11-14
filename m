Return-Path: <linux-kernel-owner+w=401wt.eu-S1764266AbXKNV1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764266AbXKNV1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 16:27:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbXKNV04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 16:26:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51325 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbXKNV0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:26:55 -0500
Subject: Re: 2.6.24-rc2-mm1
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Greg KH <greg@kroah.com>, Dave Young <hidave.darkstar@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0711142018390.15844@twin.jikos.cz>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	 <a8e1da0711132218h9d944d0p3c22ac313ee667a9@mail.gmail.com>
	 <20071113223802.2ace1a61.akpm@linux-foundation.org>
	 <a8e1da0711132247jd440f8dgc9ac0442e90f2c34@mail.gmail.com>
	 <20071114004129.783fb98b.akpm@linux-foundation.org>
	 <a8e1da0711140136i1e441371j306e7b2888de104e@mail.gmail.com>
	 <20071114165906.GB13889@kroah.com> <1195065493.2168.31.camel@lov.site>
	 <Pine.LNX.4.64.0711142018390.15844@twin.jikos.cz>
Content-Type: text/plain
Date: Wed, 14 Nov 2007 22:27:43 +0100
Message-Id: <1195075663.2609.2.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+SqS9GQhZFPY3VILZra/jxe5qrK/CNIxpKjtE
 O8SFextPhvuBJCD287xabb+l7bZXLZvicUylmCGxK+nK46bzWL
 Om3Wfh7TSH2LiFb//snseROyq58QC5N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-14 at 20:19 +0100, Jiri Kosina wrote:
> On Wed, 14 Nov 2007, Kay Sievers wrote:
> 
> > Could it be an init-order problem, where something tries to use the
> > block subsystem? Before it is initialized with:
> >   block/genhd.c :: subsys_initcall(genhd_device_init);
> > If that's the case, we have an old bug that nobody noticed with static 
> > structures, which are zeroed that time, but definitely not properly 
> > initialized. I'll try to build loop non-modular now, and see if that 
> > makes the bug appear here.

> my .config with which I reproduc this on 2.6.24-rc2-mm1 reliably can be 
> obtained from http://www.jikos.cz/jikos/junk/.config

Hmm, that config doesn't do anything here, and if I make it boot, it
does not show the bug.

Could you possibly enable kobject debugging and see if that exposes
something, maybe something goes wrong with the kset refcount and it gets
released while in use.

Kay

