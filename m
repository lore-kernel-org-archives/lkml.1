Return-Path: <linux-kernel-owner+w=401wt.eu-S2992942AbXDDP6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992942AbXDDP6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992976AbXDDP6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:58:45 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:28293 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992942AbXDDP6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:58:44 -0400
Subject: Re: real time hang w/ latency tracing
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070404154249.GA31171@elte.hu>
References: <1175626625.10738.21.camel@imap.mvista.com>
	 <1175650887.3722.2.camel@dwalker1> <20070404085133.GC2521@elte.hu>
	 <1175701013.15973.8.camel@imap.mvista.com> <20070404154249.GA31171@elte.hu>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 08:57:57 -0700
Message-Id: <1175702277.15973.17.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 17:42 +0200, Ingo Molnar wrote:

> i mean non-printk related breakages to the normal serial driver - which 
> is now surprised by this raw lock in an -rt kernel.
> 
> this is a hard issue and there's no easy solution i can see. neither 
> having it as a raw lock is a good solution, nor having it as a 
> preemptible lock is a good solution.

The machine that I'm using is relatively fast, but on slower machine
it's possible to reproduce this same hang just by running,

echo 0 > /proc/sys/kernel/preempt_max_latency

then pressing enter a few times .. Which would be a fairly common
happening with people using latency tracing an a serial port I would
imagine..

The other fix I test was using the hack for sysrq,

        if (up->port.sysrq || oops_in_progress)

in serial8250_console_write to then also check "irqs_disabled()" , but
I'm sure mass usage of the serial port would cause some issues with
that.. Although both fixes I tested resulted in the serial port becoming
garbled after about 10 min. with the preempt_thresh at 1 .

Daniel

