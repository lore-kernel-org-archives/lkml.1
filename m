Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbXHNVw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbXHNVw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbXHNV3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:29:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51070 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760625AbXHNV3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:29:04 -0400
Date: Tue, 14 Aug 2007 23:28:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: William Cattey <wdc@MIT.EDU>
Cc: Andi Kleen <andi@firstfloor.org>, cra@WPI.EDU,
       linux-kernel@vger.kernel.org
Subject: Re: vm86.c audit_syscall_exit() call trashes registers
Message-ID: <20070814212858.GB23308@one.firstfloor.org>
References: <20070814183119.GC17694@angus.ind.WPI.EDU> <p73r6m5n90l.fsf@bingen.suse.de> <78642229-39DD-4956-9385-5A3F960BFEEF@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78642229-39DD-4956-9385-5A3F960BFEEF@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 04:52:54PM -0400, William Cattey wrote:
> The corruption originally looked like a race condition.
> 
> Sometimes the EDID buffer would be all zeros.
> Sometimes it would contain partial data, and then the rest of the  
> buffer filled with zeros.
> The amount of data transferred into the buffer before going to all  
> zeros is non-deterministic.
> 
> When we put a known value in each byte of the buffer before making  
> the vm86 call, the known data would always be overwritten either with  
> EDID data or zeros.

Hmm, that might be consistent with something going wrong with sleeping.
Was the system under high load? Perhaps something else can thrash
some real mode state when you sleep. On the other hand vm86 in user
mode can schedule anyways, so it might have already happened.

But I think the mutex was actually added post 2.6.16 so if you saw
it in 2.6.16 already it might have been something else.

Also when audit is not enabled (did you have it enabled?) the audit
function doesn't do very much?

If you can reliably reproduce it one way might be to comment
out more and more of the audit code until you find who causes
the corruption (that might cause some corrupted audit data,
but that should be fine for testing) 

-Andi
