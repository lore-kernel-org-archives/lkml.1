Return-Path: <linux-kernel-owner+w=401wt.eu-S1752288AbZFVOyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbZFVOyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbZFVOyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:54:12 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:36430 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbZFVOyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:54:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=XP5H7ZzhV+9bOSB1nppgU5xV7yi2PGkssPHAC8YgU1GwQ7UmKg2LlbQNfViLCf9reb
         7i1bHS5OgOr9bbBFsXQ7FuYj0yZiCAdK1DczdWTR1bG5chxkjwBDK29tTeDQc5bJoQ3P
         JcIl2e4W+n8FISvpkf0X6Uvi7XtFgWZz/Tqp0=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20090622115627.GL24366@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	 <20090622115627.GL24366@elte.hu>
Date: Mon, 22 Jun 2009 16:54:13 +0200
Message-ID: <7c86c4470906220754yccebd67r4d87ff85af5c6f2e@mail.gmail.com>
Subject: Re: I.11 - Missing definitions for generic events
From: stephane eranian <eranian@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 1:56 PM, Ingo Molnar<mingo@elte.hu> wrote:
>> 11/ Missing definitions for generic hardware events
>>
>> As soon as you define generic events, you need to provide a clear
>> and precise definition at to what they measure. This is crucial to
>> make them useful. I have not seen such a definition yet.
>
> Do you mean their names aren't clear enough? :-)
>
No I'd like to see a defintion behind every name:

PERF_COUNT_HW_CPU_CYCLES: impacted by freq scaling or not?
PERF_COUNT_HW_INSTRUCTIONS
PERF_COUNT_HW_CACHE_REFERENCES: what cache level, data, code?
PERF_COUNT_HW_CACHE_MISSES: what cache level, data, code?
PERF_COUNT_HW_BRANCH_INSTRUCTIONS: taken, not-taken?
PERF_COUNT_HW_BRANCH_MISSES
PERF_COUNT_HW_BUS_CYCLES: what bus?

Take BUS_CYCLES, and based on my example on Core with UNHALTED_REFERENCE_CYCLE,
without a clear definition, it seems hard to understand if you need to
map it to 0x13c on a generic
counter or on fixed counter 2.

Having clearly spelled out definitions help port PCL to other
processors, it also helps user
understand which event they need to select. Users should not have to
dig through the
code to find the actual mapping for each PMU to understand what the
events actually
measure.
