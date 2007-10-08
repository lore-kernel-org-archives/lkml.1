Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbXJHSpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbXJHSpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 14:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbXJHSov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 14:44:51 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:40291 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbXJHSou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 14:44:50 -0400
Date: Mon, 8 Oct 2007 11:45:23 -0700
From: Mike Kravetz <kravetz@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: -rt more realtime scheduling issues
Message-ID: <20071008184523.GA29656@monkey.ibm.com>
References: <20071006021548.GE4587@monkey.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071006021548.GE4587@monkey.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 07:15:48PM -0700, Mike Kravetz wrote:
> After applying the fix to try_to_wake_up() I was still seeing some large
> latencies for realtime tasks.

I've been looking for places in the code where reschedule IPIs should
be sent in the case of 'overload' to redistribute RealTime tasks based
on priority.  However, an even more basic question to ask might be:  Are
the use of reschedule IPIs reliable enough for this purpose.  In the
code, there is the following comment:

/*
 * this function sends a 'reschedule' IPI to another CPU.
 * it goes straight through and wastes no time serializing
 * anything. Worst case is that we lose a reschedule ...
 */

After a quick read of the code, it does appear that reschedule's can
be lost if the the IPI is sent at just the right time in schedule
processing.  Can someone confirm this is actually the case?

The issue I see is that the 'rt_overload' mechanism depends on reschedule
IPIs for RealTime scheduling semantics.  If this is not a reliable
mechanism then this can lead to breakdowns in RealTime scheduling semantics.

Are these accurate statements?  I'll start working on a reliable delivery
mechanism for RealTime scheduling.  But, I just want to make sure that
is really necessary.

-- 
Mike
