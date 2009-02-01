Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbZBARlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbZBARlK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 12:41:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbZBARk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 12:40:56 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57209 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbZBARkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 12:40:55 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4985DE82.5030208@s5r6.in-berlin.de>
Date: Sun, 01 Feb 2009 18:40:18 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
References: <20090127001708.GA4815@nowhere>	<20090126163015.7f879b18@infradead.org>	<20090131180347.GC5884@nowhere>	<20090131101502.7ce8e7af@infradead.org>	<20090131182843.GD5884@nowhere>	<4985CC57.7090800@s5r6.in-berlin.de> <20090201090429.0c7e1362@infradead.org>
In-Reply-To: <20090201090429.0c7e1362@infradead.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sun, 01 Feb 2009 17:22:47 +0100
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> I have stuff in drivers/firewire/ done in a private workqueue and some
>> in the shared workqueue which I will eventually move either into
>> short-lived ad hoc created kthreads /or/ preferably into a thread pool
>> implementation --- if such a thing will have found its way into the
>> kernel when I have time for my project.
...
> what are the requirements for you to do this?
> 
> right now, the async calls are "fire and forget... but you can wait for
> completion". The "price" is that the code needs to allocate a little
> bit of memory for management overhead. The second price then is that 
> if this allocation fails, the code needs to run "in context".
> 
> Would this be a problem?
> 
> I can add a variant of the API where you pass in some memory of your
> own, which then does not fail. (but also won't get freed automatically
> etc)

I'm not quite sure yet but I believe I can run the work in the current
context if there was an allocation failure, provided those failures are
unlikely.

Hmm.  I don't see the "async/mgr" in the process list of that 2.6.29-rc3
box next to me.  Under which circumstances is this facility available
(long after boot)?  Or am I just barging into a discussion to /make/ it
available after boot?
-- 
Stefan Richter
-=====-==--= --=- ----=
http://arcgraph.de/sr/
