Return-Path: <linux-kernel-owner+w=401wt.eu-S934692AbYBVUPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934692AbYBVUPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757063AbYBVUPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 15:15:39 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:36935 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530AbYBVUPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 15:15:38 -0500
Subject: Re: [PATCH [RT] 08/14] add a loop counter based timeout mechanism
From: "Peter W. Morreale" <pmorreale@novell.com>
To: paulmck@linux.vnet.ibm.com
Cc: "Bill Huey (hui)" <bill.huey@gmail.com>, Andi Kleen <ak@suse.de>,
       Gregory Haskins <ghaskins@novell.com>, mingo@elte.hu,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       kevin@hilman.org, cminyard@mvista.com, dsingleton@mvista.com,
       dwalker@mvista.com, npiggin@suse.de, dsaxena@plexity.net,
       gregkh@suse.de, sdietrich@novell.com, mkohari@novell.com
In-Reply-To: <20080222194341.GE11213@linux.vnet.ibm.com>
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
	 <20080221152707.4804.59177.stgit@novell1.haskins.net>
	 <200802211741.10299.ak@suse.de> <20080222190814.GD11213@linux.vnet.ibm.com>
	 <9810cff90802221119j23818e74g2721512a693a0a01@mail.gmail.com>
	 <9810cff90802221121s216f69f4k4a5f39eaaf11dd7f@mail.gmail.com>
	 <20080222194341.GE11213@linux.vnet.ibm.com>
Content-Type: text/plain
Organization: Linux Solutions Group
Date: Fri, 22 Feb 2008 13:15:29 -0700
Message-Id: <1203711329.4147.46.camel@hermosa.morrealenet>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-22 at 11:43 -0800, Paul E. McKenney wrote:
> 
> The fixed-time spins are very useful in cases where the critical section
> is almost always very short but can sometimes be very long.  In such
> cases, you would want to spin until either ownership changes or it is
> apparent that the current critical-section instance will be long.
> 

This is what the adaptive patch set does.  All current spinners exit the
loop on an owner change.  

In this case each "spinner" will traverse the outer rt lock loop and
re-attempt to acquire the lock.  If unsuccessful, the task will re-enter
the adaptive wait loop again, providing that there are still "timeout"
iterations left for that particular task. 

I do have some stats on the rt lock/adaptive algorithm from a crude
patch used during development.  As Bill has noted, the correct way to
obtain these would be to extend lockstats.  It was just more expedient
to create this crude patch at the time.  If it is helpful to look at
these results in the meantime, I can easily make them, as well as the
patch, available.  


-PWM

