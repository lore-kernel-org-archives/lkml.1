Return-Path: <linux-kernel-owner+w=401wt.eu-S1161105AbXDCScF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161105AbXDCScF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 14:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161103AbXDCScE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 14:32:04 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37347 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161053AbXDCScD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 14:32:03 -0400
Date: Tue, 3 Apr 2007 21:32:01 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Rene Herman <rene.herman@gmail.com>
cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
In-Reply-To: <46129968.9000304@gmail.com>
Message-ID: <Pine.LNX.4.64.0704032124591.8078@sbz-30.cs.Helsinki.FI>
References: <460D7F70.3090702@gmail.com> <20070331064711.GF6246@kernel.dk>
 <460EA727.8070306@gmail.com> <84144f020704010306q600f58ddge1d42753362cf4e2@mail.gmail.com>
 <4610481D.8000102@gmail.com> <46104954.50608@gmail.com>
 <Pine.LNX.4.64.0704020949160.23099@sbz-30.cs.Helsinki.FI>
 <20070402071018.GE11996@kernel.dk> <Pine.LNX.4.64.0704021152280.27165@sbz-30.cs.Helsinki.FI>
 <46111ED7.20201@gmail.com> <Pine.LNX.4.64.0704021837480.6518@sbz-30.cs.Helsinki.FI>
 <46112650.8080208@gmail.com> <Pine.LNX.4.64.0704021906040.7500@sbz-30.cs.Helsinki.FI>
 <461165FD.2010508@gmail.com> <Pine.LNX.4.64.0704030908420.20080@sbz-30.cs.Helsinki.FI>
 <Pine.LNX.4.64.0704030956330.20741@sbz-30.cs.Helsinki.FI> <461256C1.4020906@gmail.com>
 <Pine.LNX.4.64.0704031723580.3355@sbz-30.cs.Helsinki.FI>
 <Pine.LNX.4.64.0704032030470.8078@sbz-30.cs.Helsinki.FI> <46129968.9000304@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Rene Herman wrote:
> That is, the exact same oops the tar test showed which I expect is progress --
> the dd is now in fact doing something :-)

Yes, that's expected. I think we fixed dd now.

On Tue, 3 Apr 2007, Rene Herman wrote:
> When I now switched the monitor to 5va2 itself it was happily generating more
> oopses and supposedly "fixing up recursive faults", while advicing me to
> reboot. 2 seconds later it didn't leave me a choice as it dropped dead :-)

Please enable CONFIG_DEBUG_SLAB now and reproduce. It should tell us 
what's going wrong there.

On Tue, 3 Apr 2007, Rene Herman wrote:
> Just to keep track, I'm now using the patches (minus 03) at:
> 
> http://members.home.nl/rene.herman/mcdx/
> 
> (for lkml: with 03, the machine locks itself hard each and every time without
> information).

Yes, because it is totally broken. So please just drop the patch. AFAICT 
the driver makes the process sleep in mcdex_transfer() until an interrupt 
comes to acknowledge that the I/O has completed but the patch makes the 
code sleep while holding the mutex and once the interrupt comes and tries 
to grab it, the machine will deadlock.

We probably need to fix it somehow but lets see what CONFIG_DEBUG_SLAB 
tells us first. Btw, if anyone has a datasheet for this beast, I would 
like a copy.

				Pekka
