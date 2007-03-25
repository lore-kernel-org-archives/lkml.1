Return-Path: <linux-kernel-owner+w=401wt.eu-S932806AbXCYVir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806AbXCYVir (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 17:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932810AbXCYVir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 17:38:47 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:50322 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932806AbXCYViq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 17:38:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=oapr1V15Dr8FquG7O8CHDwYlO5FXTC3R5EI6OJkmnJHbAkRZy1yaesxE5lbuv
	msXL9fgrIkffmP2/627/VZR3A==
Date: Sun, 25 Mar 2007 23:38:43 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: I/O memory barriers vs SMP memory barriers
Message-ID: <20070325213843.GE22126@xi.wantstofly.org>
References: <20070323111350.GD3980@xi.wantstofly.org> <e9c3a7c20703021312y5f7aa228i5d1c84a8e9ea5676@mail.gmail.com> <20070303111427.GB16944@xi.wantstofly.org> <20070303113305.GB10515@flint.arm.linux.org.uk> <20070321221134.GA22497@xi.wantstofly.org> <tnxlkhpgslz.fsf@arm.com> <16051.1174657433@redhat.com> <20070325211542.GD3593@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070325211542.GD3593@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 02:15:42PM -0700, Paul E. McKenney wrote:

> > > [ background: On ARM, SMP synchronisation does need barriers but device
> > >   synchronisation does not.  The question is that given this, whether
> > >   mb() and friends can be NOPs on ARM or not (i.e. whether mb() is
> > >   supposed to sync against other CPUs or not, or whether only smp_mb()
> > >   can be used for this.)  ]
> > 
> > Hmmmm...
> > 
> > [snip]
> 
> 3.	Orders memory accesses and device accesses, but not necessarily
> 	the union of the two -- mb(), rmb(), wmb().

If mb/rmb/wmb are required to order normal memory accesses, that means
that the change made in commit 9623b3732d11b0a18d9af3419f680d27ea24b014
to always define mb/rmb/wmb as barrier() on ARM systems was wrong.

Does everybody agree on these semantics, though?  At least David seems
to think that mb/rmb/wmb aren't required to order normal memory accesses
against each other..


> 4.	Orders only device accesses, which is what seems to be looked
> 	for here.

Yes.  (As above, on ARM, SMP synchronisation does need barriers but
device synchronisation does not.  If mb/rmb/wmb were only required to
synchronise device accesses, they could have been regular compiler
barriers on ARM, but if they are also required to synchronise normal
memory accesses against each other, they have to map to hardware
barriers.)
