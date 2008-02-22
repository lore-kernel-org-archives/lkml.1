Return-Path: <linux-kernel-owner+w=401wt.eu-S1763469AbYBVTT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763469AbYBVTT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757185AbYBVTTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:19:50 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:24839 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197AbYBVTTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:19:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Eumo6YuFftVLcKZTqjS9D26Q+KinZ1/sQgjaemnIKFKLWAifzXnzpkILsqin32t7alEl5bJPnUyUlRyMveR+wKOS1V2vXjFynGdlbu07ZavuwdJZD19V3jYa2sS2BIHRg3G8FOTeBPtOiEdvauP8KW0f7fG2trX8JuT4XQEmMx0=
Message-ID: <9810cff90802221119j23818e74g2721512a693a0a01@mail.gmail.com>
Date: Fri, 22 Feb 2008 11:19:48 -0800
From: "Bill Huey (hui)" <bill.huey@gmail.com>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH [RT] 08/14] add a loop counter based timeout mechanism
Cc: "Andi Kleen" <ak@suse.de>, "Gregory Haskins" <ghaskins@novell.com>,
       mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, kevin@hilman.org, cminyard@mvista.com,
       dsingleton@mvista.com, dwalker@mvista.com, npiggin@suse.de,
       dsaxena@plexity.net, gregkh@suse.de, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com
In-Reply-To: <20080222190814.GD11213@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
	 <20080221152707.4804.59177.stgit@novell1.haskins.net>
	 <200802211741.10299.ak@suse.de>
	 <20080222190814.GD11213@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 11:08 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>  One approach would be to set the RTLOCK_DELAY parameter to something like
>  -1 for default, and to set it to the number of cycles required for about
>  10 cache misses at boot time.  This would automatically scale with CPU
>  frequency and memory latency.

Yeah, I'm not very keen on having a constant there without some
contention instrumentation to see how long the spins are. It would be
better to just let it run until either task->on_cpu is off or checking
if the "current" in no longer matches the mutex owner for the runqueue
in question. At that point, you know the thread isn't running.
Spinning on something like that is just a waste of time. It's for that
reason that doing in the spin outside of a preempt critical section
isn't really needed

bill
