Return-Path: <linux-kernel-owner+w=401wt.eu-S1750720AbZESJAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750720AbZESJAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 05:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbZESJAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 05:00:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39404 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbZESJAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 05:00:38 -0400
Subject: Re: [GIT PULL] cputime patch for 2.6.30-rc6
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Michael Abbott <michael@araneidae.co.uk>,
       Jan Engelhardt <jengelh@medozas.de>
In-Reply-To: <20090519104900.12e1f80c@skybase>
References: <20090518160904.7df88425@skybase>
	 <1242660243.26820.439.camel@twins>  <20090519104900.12e1f80c@skybase>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 19 May 2009 11:00:35 +0200
Message-Id: <1242723635.26820.471.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-19 at 10:49 +0200, Martin Schwidefsky wrote:

> Well, don't do stupid things like that. That falls into the same
> category as programs calling gettimeofday all the time.

Is gtod a global DoS? The worry I have about these cputime
for_each_cpu() loops in the proc code is that any odd unpriv user can
take the whole machine down (provided the machine is large enough).

Granted, this would only be a real problem for SGI and their insane
boxes atm, but it might very well be a problem for us in the near
future, given the rate Intel seems to increase cores.

So, I'm really not objecting too much to the patch at hand, but I'd love
to find a solution to this problem.

My personal favourite is to lower the resolution/accuracy of the answer
the bigger the box gets.
