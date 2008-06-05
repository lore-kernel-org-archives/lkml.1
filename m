Return-Path: <linux-kernel-owner+w=401wt.eu-S1752630AbYFEEYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbYFEEYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 00:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbYFEEYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 00:24:14 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:53686 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbYFEEYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 00:24:14 -0400
Date: Wed, 4 Jun 2008 21:23:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       torvalds@linuxfoundation.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc4: RIP __call_for_each_cic+0x20/0x50
Message-ID: <20080605042356.GA9102@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080510103719.GA4967@martell.zuzino.mipt.ru> <20080527052740.GB28301@martell.zuzino.mipt.ru> <20080527133510.GV7712@kernel.dk> <20080527151809.GA14296@linux.vnet.ibm.com> <20080528100721.GQ25504@kernel.dk> <20080528103026.GE8255@linux.vnet.ibm.com> <20080528124423.GV25504@kernel.dk> <20080530183428.GA24449@martell.zuzino.mipt.ru> <20080604033118.GA10171@linux.vnet.ibm.com> <alpine.LFD.1.10.0806041129570.3473@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806041129570.3473@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 11:32:03AM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 3 Jun 2008, Paul E. McKenney wrote:
> > 
> > The fact that put_io_context() was called from exit_io_context() means
> > that this is the last thread of a process exiting.  The fact that
> > cfq_free_io_context() was called (via cfq_dtor()) from put_io_context()
> > means that this was the last reference to the io_context.  Yet when
> > we traverse the cic_list, part of it is corrupted -- ascii "k"s through
> > RAX and RBX.
> 
> The "ascii 'k's" are just the slab POISON_FREE byte (0x6b).
> 
> IOW, something simply kfree'd the memory too early, causing the list 
> traversal to then break.

Hence the CFQ code perhaps just an innocent bystander in the wrong place
at the wrong time.  Fair enough!

							Thanx, Paul
