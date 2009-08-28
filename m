Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbZH1U7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbZH1U7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 16:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbZH1U7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 16:59:12 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:54123 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753196AbZH1U7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 16:59:11 -0400
Date: Fri, 28 Aug 2009 16:21:33 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Thomas Gleixner <tglx@linutronix.de>
cc: Gregory Haskins <ghaskins@novell.com>, Rik van Riel <riel@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, raz ben yehuda <raziebe@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       peterz@infradead.org, maximlevitsky@gmail.com, efault@gmx.de,
       wiseman@macs.biu.ac.il, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
In-Reply-To: <alpine.LFD.2.00.0908282158100.19335@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0908281619520.15573@gentwo.org>
References: <1251282598.3514.20.camel@raz>  <alpine.DEB.1.10.0908260943090.9924@gentwo.org>  <1251297910.1791.22.camel@maxim-laptop> <1251322663.3882.48.camel@raz> <4A96B997.1070001@nortel.com> <alpine.DEB.1.10.0908271257270.17470@gentwo.org>
 <alpine.LFD.2.00.0908272242500.2888@localhost.localdomain> <4A97071F.5070804@novell.com> <4A973DAE.4020508@redhat.com> <4A975025.8030500@novell.com> <4A975CC4.1090208@novell.com> <alpine.LFD.2.00.0908281218560.2888@localhost.localdomain>
 <alpine.DEB.1.10.0908281446520.7317@gentwo.org> <alpine.LFD.2.00.0908282100040.19335@localhost.localdomain> <alpine.DEB.1.10.0908281551450.17784@gentwo.org> <alpine.LFD.2.00.0908282158100.19335@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009, Thomas Gleixner wrote:

> The statistics stuff needs to be tackled anyway as we need to offload
> the sched accounting to some other cpu.

The vm statisticcs in mm/vmstat.c are different from the sched accounting.

> What slab queue stuff is running on timers and cannot be switched off
> in such a context?

slab does run a timer every 2 second to age queues. If there was activity
then there can be a relatively long time in which we periodically throw
out portions of the cached data.

> Device specific stuff should not happen on such a CPU when there is no
> device handled on it.

The device may periodically check for conditions that require action.
