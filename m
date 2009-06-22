Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbZFVG43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbZFVG43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 02:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZFVG4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 02:56:22 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38054 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZFVG4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 02:56:21 -0400
Subject: Re: Why half of slabs are not shown in /proc/slabinfo?
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>,
       hugh.dickins@tiscali.co.uk
In-Reply-To: <200906211530.13463.arvidjaar@mail.ru>
References: <200906211152.25100.arvidjaar@mail.ru>
	 <84144f020906210426h6a41ad3csf6d9731663e30834@mail.gmail.com>
	 <200906211530.13463.arvidjaar@mail.ru>
Date: Mon, 22 Jun 2009 09:56:22 +0300
Message-Id: <1245653782.18751.12.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-21 at 15:30 +0400, Andrey Borzenkov wrote:
> On Sunday 21 of June 2009 15:26:15 Pekka Enberg wrote:
> > On Sun, Jun 21, 2009 at 10:52 AM, Andrey Borzenkov<arvidjaar@mail.ru> 
> wrote:
> > > Mandriva kernel 2.6.30 using SLUB:
> > >
> > > {pts/1}% grep SLUB /boot/config
> > > CONFIG_SLUB_DEBUG=y
> > > CONFIG_SLUB=y
> > > # CONFIG_SLUB_DEBUG_ON is not set
> > > # CONFIG_SLUB_STATS is not set
> > >
> > > Some of slabs (e.g. filp) are not shown in /proc/slabinfo;
> > > comparing number of entries under /sys and slabinfo results in
> > >
> > > {pts/0}% =ls -1 /sys/kernel/slab | grep -v : | wc -l
> > > 131
> > > {pts/0}% wc -l /proc/slabinfo
> > > 68 /proc/slabinfo
> > > {pts/0}%
> > >
> > > so almost half of the all entries are missing. Is it expected or
> > > there is something wrong here?
> >
> > Can you post the actual file listing of /sys/kernel/slab and the
> > contents of /proc/slabinfo?
> 
> Sure.
> 
> {pts/1}% ls -l /sys/kernel/slab 

If you exclude all the symbolic links, the number of caches matches. As
Hugh already explained, SLUB merges caches which shows up like this in
the sysfs directory.

			Pekka

