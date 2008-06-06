Return-Path: <linux-kernel-owner+w=401wt.eu-S1764835AbYFFIr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764835AbYFFIr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 04:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbYFFIrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 04:47:19 -0400
Received: from brick.kernel.dk ([87.55.233.238]:28620 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbYFFIrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 04:47:18 -0400
Date: Fri, 6 Jun 2008 10:47:16 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, jeremy@goop.org, mingo@elte.hu,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 6/10] arm: convert to generic helpers for IPI function calls
Message-ID: <20080606084715.GK5757@kernel.dk>
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com> <1212051504-12561-7-git-send-email-jens.axboe@oracle.com> <20080602122935.GB27125@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080602122935.GB27125@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02 2008, Russell King wrote:
> On Thu, May 29, 2008 at 10:58:20AM +0200, Jens Axboe wrote:
> > This converts arm to use the new helpers for smp_call_function() and
> > friends, and adds support for smp_call_function_single().
> 
> > +void arch_send_call_function_ipi(cpumask_t mask)
> >  {
> > -	return smp_call_function_on_cpu(func, info, retry, wait,
> > -					cpu_online_map);
> > +	send_ipi_message(mask, IPI_CALL_FUNC);
> >  }
> 
> Can things like the above be inline functions to be included in the
> generic code?

Sure, it could be put asm/smp.h for the supported archs.

-- 
Jens Axboe

