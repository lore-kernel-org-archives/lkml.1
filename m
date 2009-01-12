Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbZALQrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbZALQrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 11:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbZALQrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 11:47:25 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:48551 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbZALQrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 11:47:24 -0500
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <alpine.LFD.2.00.0901120818070.6528@localhost.localdomain>
References: <1231774622.4371.96.camel@laptop>
	 <alpine.LFD.2.00.0901120802430.6528@localhost.localdomain>
	 <alpine.LFD.2.00.0901120818070.6528@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 11:45:57 -0500
Message-Id: <1231778757.22806.24.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.496B73D1.01F9:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 08:20 -0800, Linus Torvalds wrote:
> 
> On Mon, 12 Jan 2009, Linus Torvalds wrote:
> > 
> > You made it back into the locked version.
> 
> Btw, even if you probably had some reason for this, one thing to note is 
> that I think Chris' performance testing showed that the version using a 
> lock was inferior to his local btrfs hack, while the unlocked version 
> actually beat his hack.
> 

The spinning hack was faster than everything before v7 (we'll call it
the Linus-fix), and the v7 code was much faster than my spin.

This is somewhere in between, with slightly better fairness than v7.

             spin         v7         v8
dbench 50    580MB/s      789MB/s    421MB/s
file creates 152 file/s   162 file/s 195 file/s
file stat    3.8s total   2.3s total 5.3s total

(the file stat run is total run time, so lower is better.  The other
numbers are files or MB per second, so higher is better)

For the file create run, v8 had much lower system time than v7,
averaging 1s of sys time per proc instead of 1.6s.

-chris


