Return-Path: <linux-kernel-owner+w=401wt.eu-S1762401AbYA1VRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762401AbYA1VRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 16:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbYA1VR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 16:17:27 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:63976 "EHLO
	outbound3-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707AbYA1VR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 16:17:26 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <479E459D.5080407@am.sony.com>
Date: Mon, 28 Jan 2008 13:14:05 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070926)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: a.p.zijlstra@chello.nl, rostedt@goodmis.org, dwalker@mvista.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       torvalds@linux-foundation.org, hch@infradead.org,
       mathieu.desnoyers@polymtl.ca, ghaskins@novell.com,
       acme@ghostprotocols.net, tglx@linutronix.de, sam@ravnborg.org,
       fche@redhat.com, jan.kiszka@siemens.com, johnstul@us.ibm.com,
       arjan@infradead.org, srostedt@redhat.com
Subject: Re: [PATCH] defer printks in irqs
References: <20080123160236.969334052@goodmis.org>	<20080123160441.236562634@goodmis.org>	<1201107978.13596.16.camel@imap.mvista.com>	<Pine.LNX.4.58.0801231213430.12932@gandalf.stny.rr.com>	<1201110185.13596.22.camel@imap.mvista.com>	<Pine.LNX.4.58.0801231315500.6127@gandalf.stny.rr.com>	<47991454.50603@am.sony.com>	<1201214935.6341.105.camel@lappy>	<47991DD7.9070009@am.sony.com> <20080126220151.784893b1.akpm@linux-foundation.org>
In-Reply-To: <20080126220151.784893b1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2008 21:16:01.0825 (UTC) FILETIME=[FC056110:01C861F2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> On Thu, 24 Jan 2008 15:23:03 -0800 Tim Bird <tim.bird@am.sony.com> wrote:
>> Peter Zijlstra wrote:
>>> I suspect these features reduce the chance a crash messages makes it out
>>> onto the console, but fail to spot any of the copious text mention this
>>> critical issue.
>> Anything not in interrupts would not be deferred.
>> The following code is meant to avoid deferring in oops as well.
>> I'm not sure if that covers all crash cases or not.
>> If you know of other cases, and ways to detect them, please advise.
>>
> 
> Yes, using oops_in_progress seems an appropriate fix for that.
> 
> I assume that another downside is that printk-from-interrupt will now get
> jumbled up with an interrupted pritk-from-non-interrupt.

No.  The order of printk messages (whether printk'ed
from interrupt context or not) should not be affected.
This patch should only affect the timing of when the
messages are output to console.

Note that an oops will flush any buffered messages
ahead of the oops messages themselves.

Some messages, not in oops, that were printk'ed in
interrupt context, may still be in the log buffer
but not have made it to console if the machine hangs
hard.  Because of this (IMO slight) downgrade in
debugging utility, I chose to make the changes
configurable.

> Please use checkpatch.

Will do from now on!  Thanks!
  -- Tim


=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

