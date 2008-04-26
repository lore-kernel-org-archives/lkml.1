Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbYDZOOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbYDZOOS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 10:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYDZOOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 10:14:06 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57723 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751886AbYDZOOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 10:14:05 -0400
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, peterz@infradead.org, sam@ravnborg.org,
       "Paul E. McKenney" <paulmck@us.ibm.com>
In-Reply-To: <20080425231100.b93a1601.akpm@linux-foundation.org>
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com>
	 <1208890227-24808-2-git-send-email-jens.axboe@oracle.com>
	 <20080425231100.b93a1601.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 26 Apr 2008 09:13:56 -0500
Message-Id: <1209219236.3113.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-25 at 23:11 -0700, Andrew Morton wrote:
> Also, init_call_single_data() is __cpuinit but isn't declared that way. 
> There have been rare occasions (FRV was one) where this matters - iirc the
> compiler was emitting a short-relative-addressing-form instruction which
> which wasn't able to branch far enough once things were linked.  We hae
> this problem in eight zillion other places, of course.  And it's a pita to
> go adding __cpunit etc to the declaration because the compiler usually
> won't tell us when it gets out of sync with reality.  So we could leave he
> code as-is and wait for stuff to break :(

Erm, that's a bug in the frv toolchain, isn't it?  The linker should
*never* rely on C code annotation for jump lengths ... mainly because
you can screw it all up again in the linker script, so the sectional
annotations should only be in the function body (think
-ffunction-sections)

We have exactly this problem on parisc: our standard relocation jumps
are only 17 bits (on ILP32). The linker actually lays down special
sandwich sections between individual functions (places where we jump to
as a 17 bit relative and then do another absolute jump via a pointer).
The sandwich sections should be added at final link time every place the
linker sees the relative jump is out of range.

James


