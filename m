Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbYKQJOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbYKQJOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 04:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYKQJOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 04:14:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56349
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751589AbYKQJOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 04:14:05 -0500
Date: Mon, 17 Nov 2008 01:14:03 -0800 (PST)
Message-Id: <20081117.011403.06989342.davem@davemloft.net>
To: mingo@elte.hu
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl
Subject: Re: [Bug #11308] tbench regression on each kernel release from
 2.6.22 -&gt; 2.6.28
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081117090648.GG28786@elte.hu>
References: <1ScKicKnTUE.A.VxH.DIHIJB@chimera>
	<NjF0-fuClJC.A.73B.cLHIJB@chimera>
	<20081117090648.GG28786@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 17 Nov 2008 10:06:48 +0100

> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.26 and 2.6.27.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11308
> > Subject		: tbench regression on each kernel release from  2.6.22 -&gt; 2.6.28
> > Submitter	: Christoph Lameter <cl@linux-foundation.org>
> > Date		: 2008-08-11 18:36 (98 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121847986119495&w=4
> > 		  http://marc.info/?l=linux-kernel&m=122125737421332&w=4
> 
> Christoph, as per the recent analysis of Mike:
> 
>  http://fixunix.com/kernel/556867-regression-benchmark-throughput-loss-a622cf6-f7160c7-pull.html
> 
> all scheduler components of this regression have been eliminated.
> 
> In fact his numbers show that scheduler speedups since 2.6.22 have 
> offset and hidden most other sources of tbench regression. (i.e. the 
> scheduler portion got 5% faster, hence it was able to offset a 
> slowdown of 5% in other areas of the kernel that tbench triggers)

Although I respect the improvements, wake_up() is still several orders
of magnitude slower than it was in 2.6.22 and wake_up() is at the top
of the profiles in tbench runs.

It really is premature to close this regression at this time.

I am working with every spare moment I have to try and nail this
stuff, but unless someone else helps me people need to be patient.
