Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbZETMSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbZETMSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 08:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbZETMSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 08:18:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:60849 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbZETMSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 08:18:05 -0400
Subject: Re: [PATCH]cpuset: add new API to change cpuset top group's cpus
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Len Brown <lenb@kernel.org>, Shaohua Li <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
In-Reply-To: <87ljosnfzb.fsf@basil.nowhere.org>
References: <20090519073942.GA10864@sli10-desk.sh.intel.com>
	 <1242722454.26820.461.camel@twins>
	 <20090519084852.GA13682@sli10-desk.sh.intel.com>
	 <1242723364.26820.466.camel@twins> <1242729538.26820.497.camel@twins>
	 <alpine.LFD.2.00.0905191429440.29241@localhost.localdomain>
	 <1242772601.26820.527.camel@twins>  <87ljosnfzb.fsf@basil.nowhere.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 20 May 2009 14:17:05 +0200
Message-Id: <1242821825.26820.583.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-20 at 13:58 +0200, Andi Kleen wrote:

> Could you explain that please? How does changing the top level
> cpuset affect other cpu sets?


Suppose you have 8 cpus and created 3 cpusets:

 A: cpu0 - system administration stuff
 B: cpu1-5 - generic computational stuff
 C: cpu6-7 - latency critical stuff

Each such set is made a load-balance domain (iow load-balancing on the
top level set is disabled).

Now, suppose someone thinks its a good idea to remove cpu0 because the
machine is running against some thermal limit -- what will all the
administration stuff (including sshd) do?

Same goes for the latency critical stuff.

You really want to start shrinking the generic computational capacity
first.

The thing is, you cannot simply rip cpus out from under a system, people
might rely on them being there and have policy attached to them -- esp.
people touching cpusets should know that a machine isn't configured
homogeneous and any odd cpu will do.


