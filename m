Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbXGKAvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbXGKAvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 20:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbXGKAu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 20:50:57 -0400
Received: from ozlabs.org ([203.10.76.45]:38962 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326AbXGKAu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 20:50:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18068.10601.792839.787025@cargo.ozlabs.ibm.com>
Date: Wed, 11 Jul 2007 10:50:49 +1000
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Amit Arora <aarora@in.ibm.com>,
       Andi Kleen <ak@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arnd Bergmann <arnd@arndb.de>, "Luck, Tony" <tony.luck@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mark Fasheh <mark.fasheh@oracle.com>, linux-arch@vger.kernel.org
Subject: Re: fallocate-implementation-on-i86-x86_64-and-powerpc.patch
In-Reply-To: <20070710171650.642881db.akpm@linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<20070710115251.GG2343@thunk.org>
	<20070710101558.cea7aab1.akpm@linux-foundation.org>
	<4693C580.2000506@garzik.org>
	<18068.5612.100418.782729@cargo.ozlabs.ibm.com>
	<20070710171650.642881db.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> On Wed, 11 Jul 2007 09:27:40 +1000
> Paul Mackerras <paulus@samba.org> wrote:
> 
> > We did come up with an order that worked for everybody, but that
> > discussion seemed to get totally ignored by the ext4 developers.
> 
> It was a long discussion.
> 
> Can someone please remind us what the signature of the syscall
> (and the compat handler) should be?

long sys_fallocate(loff_t offset, loff_t len, int fd, int mode)

should work for everybody.  The compat handler would be

long compat_sys_fallocate(u32 offset_hi, u32 offset_lo, u32 len_hi, u32 len_lo,
			  int fd, int mode)

for big-endian, or swap hi/lo for little-endian.  (Actually it would
be good to have an arch-dependent "stitch two args together" macro and
call them offset_0, offset_1 etc.)

Paul.
