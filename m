Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbZGNFA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbZGNFA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 01:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZGNFA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 01:00:26 -0400
Received: from smtp.zeugmasystems.com ([70.79.96.174]:22082 "EHLO
	zeugmasystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752627AbZGNFA0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 01:00:26 -0400
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jul 2009 01:00:26 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
x-cr-hashedpuzzle: AHBT AeaT AzAv BLta DE/S DPii EAsJ OQeX OstK Pkvz Qd8p Q5me RYUA SsWI VV74 VaUO;2;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcA;Sosha1_v1;7;{866200E8-1A8E-43BB-A2C2-0408E76D1941};YQBzAGkAbgBoAGEAQAB6AGUAdQBnAG0AYQBzAHkAcwB0AGUAbQBzAC4AYwBvAG0A;Tue, 14 Jul 2009 04:45:05 GMT;YQB2AG8AaQBkAGkAbgBnACAAcgB1AG4AXwB3AG8AcgBrAHEAdQBlAHUAZQAoACkAIAByAGUAYwB1AHIAcwBpAG8AbgA=
x-cr-puzzleid: {866200E8-1A8E-43BB-A2C2-0408E76D1941}
Content-class: urn:content-classes:message
Subject: avoiding run_workqueue() recursion
Date: Mon, 13 Jul 2009 21:45:05 -0700
Message-ID: <DDFD17CC94A9BD49A82147DDF7D545C501CFAC29@exchange.ZeugmaSystems.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: avoiding run_workqueue() recursion
Thread-Index: AcoEPdtQ1MzNRWL6QnWcYcE3tsrvXQ==
From: "Anirban Sinha" <ASinha@zeugmasystems.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew:

I had a question about one of your previous commits: 

: commit 2355b70fd59cb5be7de2052a9edeee7afb7ff099
: Author: Lai Jiangshan <laijs@cn.fujitsu.com>
: Date:   Thu Apr 2 16:58:24 2009 -0700
:
:    workqueue: avoid recursion in run_workqueue()

http://git.kernel.org/linus/2355b70fd59cb5be7de2052a9edeee7afb7ff099 


I saw a few discussions on the mailing list around this. I also did see
your "I still don't know why I merged ..." comment on this. I have the
following observations. I am new in the kernel hacking world, so please
bear with me.

(a) I do agree that flushing the work queues from within run_workqueue()
is buggy in itself.

(b) I do also agree that recursive call to run_workqueue() is bad due to
the reasons cited in the commit log (even though I had a good laugh when
I saw the "morton gets to eat his hat" stuff :)).

(c) I am a little puzzled by the change the patch made. If we let the
call sleep on completion when keventd is itself running the
flush_workqueue(), are we not introducing a deadlock? If the thread that
is itself is responsible for walking the workqueue and dispatching the
work functions goes to sleep, who will wake it up?
In my honest opinion, I think we should simply return when (cwq->thread
== current) is true. I think in that condition,  it should be just a
nop.


Please let me know what you think.

cheers,

ani
  


