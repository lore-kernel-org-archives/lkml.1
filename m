Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544Ab0ANIor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab0ANIor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 03:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756519Ab0ANIoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 03:44:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34620 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473Ab0ANIop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 03:44:45 -0500
Subject: Re: HW breakpoints perf_events request
From: Peter Zijlstra <peterz@infradead.org>
To: Joshua Pincus <joshua.pincus@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <bc915a051001131745m6fb70dcbx29b9d35f6fd7106c@mail.gmail.com>
References: <bc915a051001131745m6fb70dcbx29b9d35f6fd7106c@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 09:44:25 +0100
Message-ID: <1263458665.4244.256.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 17:45 -0800, Joshua Pincus wrote:
> However, there's nothing yet in place to allow a
> signal to be sent to the thread when a breakpoint
> has been hit.  Put another way, there's nothing here
> which affects execution flow of the user-app when the CPU
> traps due to a HW breakpoint.
> 
> Currently, the perf events infrastructure allows me
> to mmap() a block of memory and to poll() on it, waiting
> and watching for events to be described in that mmap'd
> buffer.  That will not be sufficient for what we need
> to do.  We need to have the ability to specify that
> execution of the thread should be interrupted, just as it
> would under ptrace(), and have a signal be delivered.
> Delivery of the signal must be received and processed
> by the application before the thread will be allowed to
> proceed to the nPC after the PC which caused the
> HW breakpoint event.
> 
> Is this possible?  Can we architect this feature into
> the perf_events infrastructure? 

We have fnctl() managing signal support, but that will only interrupt
the observing thread, not the threads being observed (unless they are
one and the same -- but using inheritance precludes that from being
true).

I'm not sure I'm willing to go in this direction with perf, the idea is
to have a minimum impact on the observed threads, explicitly sending
them signals and disturbing their execution goes against this.


