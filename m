Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbYKUJDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbYKUJDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 04:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYKUJD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 04:03:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55110
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752941AbYKUJDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 04:03:24 -0500
Date: Fri, 21 Nov 2008 01:03:20 -0800 (PST)
Message-Id: <20081121.010320.73660585.davem@davemloft.net>
To: mingo@elte.hu
Cc: cl@linux-foundation.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, efault@gmx.de, a.p.zijlstra@chello.nl
Subject: Re: [Bug #11308] tbench regression on each kernel release from
 2.6.22 -&gt; 2.6.28
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081121083044.GL16242@elte.hu>
References: <Pine.LNX.4.64.0811191341570.23502@quilx.com>
	<Pine.LNX.4.64.0811201727070.9089@quilx.com>
	<20081121083044.GL16242@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 21 Nov 2008 09:30:44 +0100

> 
> * Christoph Lameter <cl@linux-foundation.org> wrote:
> 
> > hmmm... Well we are almost there.
> > 
> > 2.6.22:
> > 
> > Throughput 2526.15 MB/sec 8 procs
> > 
> > 2.6.28-rc5:
> > 
> > Throughput 2486.2 MB/sec 8 procs
> > 
> > 8p Dell 1950 and the number of processors specified on the tbench 
> > command line.
> 
> And with net-next we might even be able to get past that magic limit? 
> net-next is linus-latest plus the latest and greatest networking bits:

In any event I'm happy to toss this from the regression list.

My sparc still shows the issues and I'll profile that independently.
I'm pretty sure it's the indirect calls and the deeper stack frames
(which == 128 bytes of extra stores at each level to save the register
window), but I need to prove that first.
