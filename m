Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbXC0KFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbXC0KFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 06:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbXC0KFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 06:05:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbXC0KFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 06:05:47 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <8bd0f97a0703261321h356a849am1ab617f0e732fa67@mail.gmail.com> 
References: <8bd0f97a0703261321h356a849am1ab617f0e732fa67@mail.gmail.com>  <Pine.LNX.4.64.0703261447190.13229@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0703261427490.12793@sbz-30.cs.Helsinki.FI> <20070326024143.a226c9b2.akpm@linux-foundation.org> <1174904637.32691.86.camel@roc-desktop> <6017.1174908318@redhat.com> <6791.1174909459@redhat.com> <11045.1174911764@redhat.com> <Pine.LNX.4.64.0703261525370.14158@sbz-30.cs.Helsinki.FI> <22674.1174915478@redhat.com> 
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "Pekka J Enberg" <penberg@cs.helsinki.fi>,
       "Andrew Morton" <akpm@linux-foundation.org>, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org, "Hugh Dickins" <hugh@veritas.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm] Revoke core code: fix nommu arch compiling error bug 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 27 Mar 2007 11:05:13 +0100
Message-ID: <27782.1174989913@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier.adi@gmail.com> wrote:

> > [*] The FRV, for example, does have some limited protection capability - but
> > it is really limited and not really useful in this case.
> 
> how so ?

There are a limited set of protection registers (At least 8 insn and 8 data)
that can permit tiles of protection that are a power-of-2 megabytes in size.
However, these also have to be used to grant the kernel access to h/w
(including RAM).

Note that it's not possible to shift windows around in response to faults
because fault reporting is asynchronous - the entire remaining instruction
queue will be executed *before* the exception is actually raised to the
kernel.

> the Blackfin processor lacks a MMU but it does have a MPU (memory protection
> unit) which allows granularity down to 1k page sizes ... so for future
> releases, we plan on integrating optional support for this so that you could
> have processes protected from each other and the kernel protected from all
> the processes ... so in our case, we might actually be able to support
> revoking of maps because we would have that region of memory ear marked as
> unaccessible ...

That sounds reasonable.  However, I suspect that most NOMMU CPUs won't be able
to do that.  In effect you're creating a third option, I think (MMU, NOMMU,
MPU).

> note that the Blackfin processor manuals confusingly call this aspect
> of the chip an "MMU" ... dont be fooled !

Same for FRV.  It is memory management - it just doesn't include virtual
memory mapping.

David
