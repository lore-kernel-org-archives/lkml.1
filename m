Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbYH2O3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbYH2O3x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 10:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756613AbYH2O3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 10:29:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48362 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbYH2O3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 10:29:42 -0400
Date: Fri, 29 Aug 2008 10:29:40 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: John Kacur <jkacur@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, mgross@linux.intel.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       peterz@infradead.org, mingo@elte.hu, tglx@linutronix.de,
       arjan@infradead.org
Subject: Re: [PATCH RFC] pm_qos_requirement might sleep
In-Reply-To: <520f0cf10808282331r3425f4f4jfac2d3a7d53c8821@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0808291028540.27078@gandalf.stny.rr.com>
References: <20080812224926.GA20652@linux.intel.com>  <1218736137.10800.234.camel@twins>  <520f0cf10808141551k283aecb8y647d0f5ae321b81f@mail.gmail.com>  <20080825163412.GA21910@linux.intel.com>  <1219682129.8515.81.camel@twins> 
 <520f0cf10808260148k47368b71he2737ea1a59bbe4d@mail.gmail.com>  <20080826161802.GB9862@linux.intel.com>  <520f0cf10808261045v9dddcdcnd1a86b224aa3feb0@mail.gmail.com>  <20080828194420.GB6802@linux.intel.com>  <20080828173201.8912a1f3.akpm@linux-foundation.org>
 <520f0cf10808282331r3425f4f4jfac2d3a7d53c8821@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Aug 2008, John Kacur wrote:
> 
> Hi Andrew
> 
> The purpose of the patch is to remove the spin_lock around the read in
> the function pm_qos_requirement - since spinlocks can sleep in -rt and
> this function is called from idle. I did propose a patch, that simply
> removed the spinlock, since Peter Zilstra and others (yourself) point
> out, the lock isn't needed to read a single word from memory. Although
> the patch worked fine, Arjan objected to it, because it was not
> symmetric. A reader of the code might wonder why it was locked in
> other functions but not here. He suggested changing it to an atomic
> type might be less confusing. The alternative which I like better
> actually is to simply remove the lock in pm_qos_requirement and add a
> comment for readers of the code.

This is a much better changelog, and is what should have been written in 
the first place ;-)

-- Steve

