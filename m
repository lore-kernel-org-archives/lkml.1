Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813Ab0AHPwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab0AHPwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 10:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633Ab0AHPw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 10:52:29 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:45892 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab0AHPw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 10:52:28 -0500
Date: Fri, 8 Jan 2010 09:51:49 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Arjan van de Ven <arjan@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
In-Reply-To: <20100107204940.253ed753@infradead.org>
Message-ID: <alpine.DEB.2.00.1001080946390.23727@router.home>
References: <20100104182429.833180340@chello.nl> <20100104182813.753545361@chello.nl> <20100105054536.44bf8002@infradead.org> <alpine.DEB.2.00.1001050916300.1074@router.home> <20100105192243.1d6b2213@infradead.org> <alpine.DEB.2.00.1001071007210.901@router.home>
 <alpine.LFD.2.00.1001070814080.7821@localhost.localdomain> <alpine.DEB.2.00.1001071025450.901@router.home> <20100107204940.253ed753@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010, Arjan van de Ven wrote:

> if an app has to change because our kernel sucks (for no good reason),
> "change the app" really is the lame type of answer.

We are changing apps all of the time here to reduce the number of system
calls. Any system call usually requires context switching, scheduling
activities etc. Evil effects if you want the processor for computation
and are sensitive to cpu caching effects. It is good to reduce the number
of system calls as much as possible.

System calls are at best placed to affect the largest memory
possible in a given context and be avoided in loops.

