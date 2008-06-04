Return-Path: <linux-kernel-owner+w=401wt.eu-S1761734AbYFDSdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761734AbYFDSdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 14:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759051AbYFDSct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 14:32:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757568AbYFDScs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 14:32:48 -0400
Date: Wed, 4 Jun 2008 11:32:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Alexey Dobriyan <adobriyan@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       torvalds@linuxfoundation.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc4: RIP __call_for_each_cic+0x20/0x50
In-Reply-To: <20080604033118.GA10171@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.1.10.0806041129570.3473@woody.linux-foundation.org>
References: <20080504190811.GP12774@kernel.dk> <20080504201542.GA1040@martell.zuzino.mipt.ru> <20080510103719.GA4967@martell.zuzino.mipt.ru> <20080527052740.GB28301@martell.zuzino.mipt.ru> <20080527133510.GV7712@kernel.dk> <20080527151809.GA14296@linux.vnet.ibm.com>
 <20080528100721.GQ25504@kernel.dk> <20080528103026.GE8255@linux.vnet.ibm.com> <20080528124423.GV25504@kernel.dk> <20080530183428.GA24449@martell.zuzino.mipt.ru> <20080604033118.GA10171@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Jun 2008, Paul E. McKenney wrote:
> 
> The fact that put_io_context() was called from exit_io_context() means
> that this is the last thread of a process exiting.  The fact that
> cfq_free_io_context() was called (via cfq_dtor()) from put_io_context()
> means that this was the last reference to the io_context.  Yet when
> we traverse the cic_list, part of it is corrupted -- ascii "k"s through
> RAX and RBX.

The "ascii 'k's" are just the slab POISON_FREE byte (0x6b).

IOW, something simply kfree'd the memory too early, causing the list 
traversal to then break.

		Linus
