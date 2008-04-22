Return-Path: <linux-kernel-owner+w=401wt.eu-S1764136AbYDVOvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764136AbYDVOvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbYDVOvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:51:13 -0400
Received: from brick.kernel.dk ([87.55.233.238]:25437 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587AbYDVOvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:51:12 -0400
Date: Tue, 22 Apr 2008 16:51:06 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
Message-ID: <20080422145105.GJ12774@kernel.dk>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-2-git-send-email-jens.axboe@oracle.com> <alpine.LFD.1.10.0804220735350.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804220735350.2779@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22 2008, Linus Torvalds wrote:
> 
> 
> On Tue, 22 Apr 2008, Jens Axboe wrote:
> > +
> > +static inline void csd_flag_wait(struct call_single_data *data)
> > +{
> > +	/* Wait for response */
> > +	do {
> > +		/*
> > +		 * We need to see the flags store in the IPI handler
> > +		 */
> > +		smp_mb();
> > +		if (!(data->flags & CSD_FLAG_WAIT))
> > +			break;
> > +		cpu_relax();
> > +	} while (1);
> > +}
> 
> You forgot to free the "data" here? The waiter must also free the object, 
> since now the callee does not.

The ipi interrupt handler does that, see kfree() in
generic_smp_call_function_single_interrupt() or call_func_data_free() in
generic_smp_call_function_interrupt().

-- 
Jens Axboe

