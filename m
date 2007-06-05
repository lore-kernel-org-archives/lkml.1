Return-Path: <linux-kernel-owner+w=401wt.eu-S1760431AbXFEATS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760431AbXFEATS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 20:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757561AbXFEATK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 20:19:10 -0400
Received: from ozlabs.org ([203.10.76.45]:59826 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756960AbXFEATJ (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 20:19:09 -0400
Subject: Re: Interesting interaction between lguest and CFS
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linux-kernel@vger.kernel.org
In-Reply-To: <20070604173710.GR11166@waste.org>
References: <20070604173710.GR11166@waste.org>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 10:18:54 +1000
Message-Id: <1181002734.25878.56.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 12:37 -0500, Matt Mackall wrote:
> With 2.6.22-rc3-mm1, I've got a long-running video transcoding going
> on. In other windows, I'm compiling, reading email, etc. with no
> noticeable problems.
> 
> If I fire up lguest and leave it sitting at a shell prompt for a
> couple moments, when I return to type something at the prompt, it can
> take 2-3 seconds for my input to echo. Once it starts responding,
> typing latency disappears. Suspend the other app and the latency
> disappears.

This sounds like the waker process (nice 19) not getting a chance to
run.  You can hack around it for the moment by changing "nice(19)" in
Documentation/lguest/lguest.c to something less aggressive.

The real solution is to switch to an fd.  Fortunately, I have just such
a patch.  I am shuffling it forward in my queue now, and will send when
testing is complete...

Thanks!
Rusty.


