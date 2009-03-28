Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbZC1Nyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbZC1Nyh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 09:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbZC1Ny2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 09:54:28 -0400
Received: from ozlabs.org ([203.10.76.45]:41035 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbZC1Ny2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 09:54:28 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: lguest@ozlabs.org
Subject: Re: [Lguest] [PULL] lguest and virtio patches
Date: Sun, 29 Mar 2009 00:24:22 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Roel Kluin <roel.kluin@gmail.com>,
       Matias Zabaljauregui <zabaljauregui@gmail.com>,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
References: <200903282341.54810.rusty@rustcorp.com.au>
In-Reply-To: <200903282341.54810.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903290024.23218.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 March 2009 23:41:54 Rusty Russell wrote:
> The following changes since commit 5d80f8e5a9dc9c9a94d4aeaa567e219a808b8a4a:             
...
>       lguest: avoid accidental recycling of pgdir pages

Actually, I've repushed without this change: Jeremy convinced me it's not
necessary.

If you pulled in between, it's no big deal.

Rusty.

New stats:

Matias Zabaljauregui (2):
      lguest: use KVM hypercalls
      lguest: use bool instead of int

Roel Kluin (1):
      virtio: fix BAD_RING, START_US and END_USE macros

Rusty Russell (4):
      virtio: more neatening of virtio_ring macros.
      lguest: fix spurious BUG_ON() on invalid guest stack.
      lguest: wire up pte_update/pte_update_defer
      lguest: barrier me harder

 Documentation/lguest/lguest.c         |    7 +++
 arch/x86/include/asm/lguest_hcall.h   |   24 ++--------
 arch/x86/lguest/boot.c                |   86 ++++++++++++++++++++++-----------
 arch/x86/lguest/i386_head.S           |    4 +-
 drivers/lguest/core.c                 |    4 +-
 drivers/lguest/interrupts_and_traps.c |   28 ++++++-----
 drivers/lguest/lg.h                   |    8 ++--
 drivers/lguest/lguest_device.c        |    4 +-
 drivers/lguest/page_tables.c          |   22 +++++----
 drivers/lguest/segments.c             |    2 +-
 drivers/lguest/x86/core.c             |   62 +++++++++++++++++++++++-
 drivers/virtio/virtio_ring.c          |   22 +++++---
 12 files changed, 181 insertions(+), 92 deletions(-)

