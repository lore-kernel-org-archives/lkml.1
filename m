Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbYAWRMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbYAWRMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbYAWRMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:12:34 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:36039 "EHLO
	outbound9-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752267AbYAWRMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:12:33 -0500
X-Greylist: delayed 2246 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jan 2008 12:12:33 EST
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <47976E00.2050404@am.sony.com>
Date: Wed, 23 Jan 2008 08:40:32 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 08/20 -v5] initialize the clock source to jiffies clock.
References: <20080123160236.969334052@goodmis.org> <20080123160442.383241528@goodmis.org>
In-Reply-To: <20080123160442.383241528@goodmis.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jan 2008 16:34:59.0308 (UTC) FILETIME=[E51CBAC0:01C85DDD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> The latency tracer can call clocksource_read very early in bootup and
> before the clock source variable has been initialized. This results in a
> crash at boot up (even before earlyprintk is initialized). Since the
> clock->read variable points to NULL.
> 
> This patch simply initializes the clock to use clocksource_jiffies, so
> that any early user of clocksource_read will not crash.

There's a similar problem with reads of sched_clock() too early
on some architectures.  This problem reminds me of a fix I need
to re-send to the ARM mailing list.  That aside, I heartily recommend
applying this patch, whether the rest of this system gets mainlined
or not.

FWIW:
Acked-by: Tim Bird <tim.bird@am.sony.com>

 -- Tim


=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

