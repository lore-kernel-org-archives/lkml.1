Return-Path: <linux-kernel-owner+w=401wt.eu-S1030527AbXBAIG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030527AbXBAIG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 03:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030540AbXBAIG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 03:06:58 -0500
Received: from mail.enyo.de ([212.9.189.167]:3704 "EHLO mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030527AbXBAIG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 03:06:57 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Samium Gromoff <_deepfire@feelingofgreen.ru>, Pavel Machek <pavel@ucw.cz>,
       Valdis.Kletnieks@vt.edu, David Wagner <daw@cs.berkeley.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Undo some of the pseudo-security madness
References: <87r6toufpp.wl@betelheise.deep.net>
	<200701221520.l0MFKLdK032645@turing-police.cc.vt.edu>
	<871wlnq7ue.wl@betelheise.deep.net> <20070123084805.GB5560@ucw.cz>
	<87mz4996wg.wl@betelheise.deep.net>
	<1170237588.2865.2.camel@laptopd505.fenrus.org>
Date: Thu, 01 Feb 2007 09:05:53 +0100
In-Reply-To: <1170237588.2865.2.camel@laptopd505.fenrus.org> (Arjan van de
	Ven's message of "Wed, 31 Jan 2007 17:59:48 +0800")
Message-ID: <8764amb8v2.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven:

>> No amount of carefulness will prevent vendors stick arbitrarily
>> damaging values of stack and mmap base randomisation, severely reducing
>> the usefullness of MAP_FIXED.
>
> MAP_FIXED is useful still. The only safe way is to use addresses you got
> from mmap(), eg you overmap something.
> Anything else is madness, with or without randomization. The C library
> for example is free, and does, allocate memory and stacks etc etc.

This reminds me of a different matter: What is the recommended way to
reserve address space (so that libc etc. won't use it) *without*
increasing the VM committed memory counter?  In other words, without
allocating backing store for it?

IIRC, mmap(PROT_NONE) followed by mprotect(PROT_READ | PROT_WRITE)
seems to work, but I wonder if this is just an accident, or if this is
part of the API.

This is an interesting topic because such functionality is required to
make many virtual machines work with address space randomization and
(especially) vm.overcommit_memory=2.  They don't need the backing
store from the beginning, but they really like (if not need, even)
huge regions of continuous address space.
