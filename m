Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbZAWPkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbZAWPkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 10:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbZAWPkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 10:40:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:46182 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbZAWPkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 10:40:25 -0500
Subject: Re: CPU scheduler question/problem
From: Peter Zijlstra <peterz@infradead.org>
To: Pawel Dziekonski <dzieko@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <2cd4df870901221334n7e242e79ka961f899c03c70cb@mail.gmail.com>
References: <2cd4df870901221334n7e242e79ka961f899c03c70cb@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 16:40:19 +0100
Message-Id: <1232725219.4826.131.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-22 at 22:34 +0100, Pawel Dziekonski wrote:
> question: is there a way to better balance processes over different
> cores and do it automagically?

Hard, the load-balancing code is a bunch of heuristics that work 'well'
for most of the things.

The pipe workload you mentioned has would behave that way because pipes
'assume' a produces/consumer behaviour, and thus are more likely to
place both tasks on the same cpu -- but will eventually pull them apart
if they want to run concurrently.

You might enable SCHED_DEBUG=y and try

 echo NO_SYNC_WAKEUPS > /debug/sched_features

For that particular load.

About your quantum chemistry application -- you say they share a
workload, does that mean they synchronize a lot on locks? If so, the
scheduler might, at times of serialization, think it is a
produces/consumer load and move tasks together, and then later, when
they run independently, move them apart again.

I'm afraid you'll have to share a bit more of how your application works
in order to get a more informed answer.



