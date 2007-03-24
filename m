Return-Path: <linux-kernel-owner+w=401wt.eu-S933055AbXCXUUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055AbXCXUUj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 16:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933078AbXCXUUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 16:20:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:58240 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933055AbXCXUUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 16:20:38 -0400
Subject: Re: I/O memory barriers vs SMP memory barriers
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Howells <dhowells@redhat.com>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, paulmck@us.ibm.com
In-Reply-To: <16051.1174657433@redhat.com>
References: <20070323111350.GD3980@xi.wantstofly.org>
	 <e9c3a7c20703021312y5f7aa228i5d1c84a8e9ea5676@mail.gmail.com>
	 <20070303111427.GB16944@xi.wantstofly.org>
	 <20070303113305.GB10515@flint.arm.linux.org.uk>
	 <20070321221134.GA22497@xi.wantstofly.org> <tnxlkhpgslz.fsf@arm.com>
	 <16051.1174657433@redhat.com>
Content-Type: text/plain
Date: Sun, 25 Mar 2007 06:16:27 +1000
Message-Id: <1174767387.10836.107.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-23 at 13:43 +0000, David Howells wrote:
> [Resend - this time with a comma in the addresses, not a dot]
> 
> Lennert Buytenhek <buytenh@wantstofly.org> wrote:
> 
> > [ background: On ARM, SMP synchronisation does need barriers but device
> >   synchronisation does not.  The question is that given this, whether
> >   mb() and friends can be NOPs on ARM or not (i.e. whether mb() is
> >   supposed to sync against other CPUs or not, or whether only smp_mb()
> >   can be used for this.)  ]
> 
> Hmmmm...
> 
> I see your problem.  I think the right way to deal with this is to get rid of
> mb(), rmb(), wmb() and read_barrier_depends() and replace them with io_mb(),
> io_rmb(), ...

Hrm... I'm not sure I like the io_* name, I think it's even more
confusing, people will never know when to use what ...

Maybe we should dig out again my attempt at properly defining semantics
of IO accessors and related barriers and extend it to include CPU vs.
DMA barriers.

Ben.


