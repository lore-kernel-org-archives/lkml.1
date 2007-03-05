Return-Path: <linux-kernel-owner+w=401wt.eu-S1752717AbXCEHu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbXCEHu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 02:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbXCEHu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 02:50:28 -0500
Received: from mail.queued.net ([207.210.101.209]:4033 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbXCEHu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 02:50:27 -0500
Message-ID: <45EBCBBE.6000001@debian.org>
Date: Mon, 05 Mar 2007 02:50:22 -0500
From: Andres Salomon <dilinger@debian.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] highres: Do not run the TIMER_SOFTIRQ after switching
 to	highres mode
References: <45E8E2F8.1030102@debian.org> <1172912540.24738.108.camel@localhost.localdomain> <45EAAA21.4040803@debian.org> <1173013794.24738.130.camel@localhost.localdomain> <45EAC5B1.2060306@debian.org> <20070305072518.GB14993@elte.hu>
In-Reply-To: <20070305072518.GB14993@elte.hu>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andres Salomon <dilinger@debian.org> wrote:
> 
>> Thomas Gleixner wrote:
>>>>> The question is, how the tick timer gets enqueued in the softirq queue.
>>>>> Can you isolate the codepath, where this happens ?
>>> The TIMER_SOFTIRQ runs the hrtimers during bootup until a usable
>>> clocksource and clock event sources are registered. The switch to high
>>> resolution mode happens inside of the TIMER_SOFTIRQ, but runs the
>>> softirq afterwards. That way the tick emulation timer, which was set up
>>> in the switch to highres might be executed in the softirq context, which
>>> is a BUG. The rbtree has not to be touched by the softirq after the
>>> highres switch.
>>>
>> And an additional request, just to make it explicit that we should not 
>> have any NO_SOFTIRQ callbacks in the tree; BUG out if we encounter 
>> such a thing.
> 
> please change it to WARN_ON_ONCE()...
> 
> 'bug out' might mean: 'dead box'/'no resume'/'no bootup'.
> 
> 	Ingo


Certainly; note that hrtimers.c has quite a few BUG calls which could
render a box dead, though.

Patch to follow..

