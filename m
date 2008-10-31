Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbYJaNsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbYJaNsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 09:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYJaNsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 09:48:10 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:57202 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbYJaNsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 09:48:09 -0400
Date: Fri, 31 Oct 2008 08:47:19 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Dave Chinner <david@fromorbit.com>
cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
       Paul Menage <menage@google.com>, Derek Fults <dfults@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] cpuset writeback throttling
In-Reply-To: <20081030220344.GL4985@disturbed>
Message-ID: <Pine.LNX.4.64.0810310838160.21396@quilx.com>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
 <20081030210826.GR17077@disturbed> <Pine.LNX.4.64.0810301632030.3839@quilx.com>
 <20081030220344.GL4985@disturbed>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008, Dave Chinner wrote:

> Yes, I know about those tests at SGI - they were to demonstrate the
> feature worked (i.e. proof-of-concept demonstration), not regression
> test the change.

I did some regression tests at that time before publishing the initial 
patchsets. That was mainly using standard tests (AIM7). There have been 
some changes since then though.

> This is a fairly major change in behaviour to the writeback path on
> NUMA systems and so has the potential to introduce subtle new
> issues. Hence I'm asking about the level of testing and exposure
> it has had. It doesn't really sound like it has had much coverage
> to me....

Sure we need more testing. Solomita did some testing as evident from his 
messages. See f.e. 
http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-09/msg02939.html

> I'm concerned right now because Nick and others (including myself)
> have recently found lots of nasty data integrity problems in the
> writeback path that we are currently trying to test fixes for.
> It's not a good time to introduce new behaviours as that will
> definitely perturb any regression testing we are running....

The writeback throttling that is addressed in the patchset mainly changes 
the calculation of the limits that determine when writeback is started and 
select inodes based on their page allocation on certain nodes. That is 
relatively independent of the locking scheme for writeback.
