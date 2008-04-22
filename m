Return-Path: <linux-kernel-owner+w=401wt.eu-S1755583AbYDVMNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbYDVMNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 08:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbYDVMNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 08:13:22 -0400
Received: from brick.kernel.dk ([87.55.233.238]:2163 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbYDVMNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 08:13:21 -0400
Date: Tue, 22 Apr 2008 14:13:16 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, anton@samba.org
Subject: Re: [PATCH 3/11] powerpc: convert to generic helpers for IPI function calls
Message-ID: <20080422121315.GE12774@kernel.dk>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-4-git-send-email-jens.axboe@oracle.com> <18445.54284.194023.553595@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18445.54284.194023.553595@cargo.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22 2008, Paul Mackerras wrote:
> Jens Axboe writes:
> 
> > This converts ppc to use the new helpers for smp_call_function() and
> > friends, and adds support for smp_call_function_single().
> 
> Looks OK, and runs on a dual G5 powermac here.  I'll try on some
> bigger IBM boxes tomorrow, or maybe Anton can do that.

Thanks a lot, Paul!

> I notice that you have changed the semantics slightly in that
> previously, the powerpc implementation would wait for the other cpus
> to have taken the interrupt, and print a message if they didn't all
> take the interrupt (this was different from the function of the `wait'
> parameter, which said whether to wait for all cpus to finish executing
> the specified function).
> 
> Now the generic smp_call_function_mask doesn't wait for the other cpus
> to take the interrupt.  I don't think that's likely to be a problem,
> but I do think that's worth mentioning in the patch description.
> 
> It's probably also worth mentioning that smp_send_stop no longer has
> the behaviour of doing its stuff even if someone is holding the lock,
> but that is OK (presumably) because now the lock (call_function_lock
> in the new code) is held for much shorter periods and there doesn't
> appear to be much danger of other cpus getting stuck or panicking
> while holding that lock.

I touched on both of these points in the initial mail, but perhaps you
missed it as I didn't CC everyone for the 0/11 part. I'll add the full
explanation to the 1/11 patch as well.

> You can put Acked-by: Paul Mackerras <paulus@samba.org> on the ppc
> patch, but please extend the description a bit as outlined above.

I'll add the ack, let me know if you still think I should do more on the
changelog side.

-- 
Jens Axboe

