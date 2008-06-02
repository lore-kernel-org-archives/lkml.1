Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbYFBVmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbYFBVmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 17:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbYFBVlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 17:41:55 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54866 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751549AbYFBVly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 17:41:54 -0400
Date: Mon, 2 Jun 2008 16:41:51 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, "Derek L. Fults" <dfults@sgi.com>,
       devik <devik@cdi.cz>, Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Randy.Dunlap" <rddunlap@osdl.org>, suresh.b.siddha@intel.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may have realtime uses)
Message-ID: <20080602214151.GA7072@sgi.com>
References: <20080601213019.14ea8ef8.pj@sgi.com> <20080602164203.GA2477@sgi.com> <48443E66.6060205@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48443E66.6060205@qualcomm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 11:39:34AM -0700, Max Krasnyansky wrote:
> Ah, I know exactly what you're talking about.  However this is non-issue these
> days. In order to clear cpuN from all the timers and other things all you need
> to do is to bring that cpu off-line
> 	echo 0 > /sys/devices/cpu/cpuN/online
> and then bring it back online
> 	echo 1 > /sys/devices/cpu/cpuN/online

Although it seemed like something of a hack, we experimented with this
previously and found that it didn't work reliably.  I'm sure things
have gotten better, but will need to revisit.

> 
> There are currently a couple of issues with scheduler domains and hotplug
> event handling. I do have the fix for them, and Paul had already acked it.

Until a proven reliable method for doing this is firmly in place (as
firmly as anything is, anyway),  I don't think we should be removing
the alternative.

> initialization). See my latest "default IRQ affinity" patch.

Nice idea.

> Also isolcpus= conflicts with the scheduler domains created by the cpusets.

What sort of conflict are we talking about?  I assume once you've begun setting up cpusets that include those cpus that you're intention is to change the original behavior.

