Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664Ab0ASXPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab0ASXPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 18:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175Ab0ASXPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 18:15:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:43397 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab0ASXPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 18:15:37 -0500
Subject: Re: sys_recvmmsg: wire up or not?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: David Miller <davem@davemloft.net>, arnd@arndb.de, geert@linux-m68k.org,
       acme@redhat.com, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
In-Reply-To: <20100119072114.GB16013@linux-sh.org>
References: <10f740e80912260239n17bbbd08w6c3065c12bde9c95@mail.gmail.com>
	 <200912261212.14264.arnd@arndb.de> <1263442833.724.325.camel@pasglop>
	 <20100113.202807.233259060.davem@davemloft.net>
	 <1263452379.724.348.camel@pasglop>  <20100119072114.GB16013@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 10:14:44 +1100
Message-ID: <1263942884.724.537.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 16:21 +0900, Paul Mundt wrote:
> 
> > IE. I'd rather have them all duplicated into real syscalls than some of
> > them only in socketcall and some on both since that will make any kind
> > of userspace transition even more hellish.
> > 
> Presumably you're going to have to support both given that binaries with
> both ABIs are going to be left around for the forseeable future. We
> started out with socketcall on sh64 with the initial ABI and then
> transitioned over to broken out direct system calls. While having both is
> a bit inconsistent, it's not really something that can be avoided until
> all of the old binaries go away. There are certainly enough architectures
> today that provide both that you shouldn't really run in to any nasty
> surprises at least.

I agree, my point was more like I'd rather not add the syscall for
recvmmsg only right now, and others later, and instead of an
all-or-nothing approach, ie, add all the syscalls at once (while keeping
the socketcall around of course). That would make glibc work easier not
having to track syscall availability on a per-syscall basis etc...

Cheers,
Ben.

> 32-bit SH only uses socketcall at the moment, but I'm also inclined to
> add in the broken out versions and start migrating glibc over.
> 
> Unfortunately there are not a lot of good options for the syscall checker
> with things like this however, given that some platforms will want one or
> the other or both ;-)
> 
> 

