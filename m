Return-Path: <linux-kernel-owner+w=401wt.eu-S1759371AbYAXXRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371AbYAXXRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 18:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758783AbYAXXRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 18:17:33 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:31958 "EHLO
	outbound5-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758723AbYAXXRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 18:17:31 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <47991DD7.9070009@am.sony.com>
Date: Thu, 24 Jan 2008 15:23:03 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Steven Rostedt <rostedt@goodmis.org>, Daniel Walker <dwalker@mvista.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH] defer printks in irqs
References: <20080123160236.969334052@goodmis.org>	 <20080123160441.236562634@goodmis.org>	 <1201107978.13596.16.camel@imap.mvista.com>	 <Pine.LNX.4.58.0801231213430.12932@gandalf.stny.rr.com>	 <1201110185.13596.22.camel@imap.mvista.com>	 <Pine.LNX.4.58.0801231315500.6127@gandalf.stny.rr.com>	 <47991454.50603@am.sony.com> <1201214935.6341.105.camel@lappy>
In-Reply-To: <1201214935.6341.105.camel@lappy>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jan 2008 23:17:24.0739 (UTC) FILETIME=[4752DD30:01C85EDF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> I suspect these features reduce the chance a crash messages makes it out
> onto the console, but fail to spot any of the copious text mention this
> critical issue.

Anything not in interrupts would not be deferred.
The following code is meant to avoid deferring in oops as well.
I'm not sure if that covers all crash cases or not.
If you know of other cases, and ways to detect them, please advise.

>> +#ifdef CONFIG_PRINTK_DEFER_IN_IRQ
>> +		/*
>> +		 * If we're in an interrupt and it's not an emergency,
>> +		 * don't emit to console just yet.
>> +	         */
>> +		if ((irqs_disabled() || in_interrupt()) && !oops_in_progress) {
>> +			defer = 1;
>> +		}
>> +#endif

I made the code conditional because printk messages are pretty
critical for debugging, and I wanted someone to be aware if they
altered the behavior in any way.  I suspect that only in embedded,
when people are having realtime performance problems, would this
change be of interest.

Please recognize that I'm not submitting this for kernel inclusion
at this time.  Please see the larger thread for context.  That said,
I appreciate the feedback on the code.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

