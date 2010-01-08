Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324Ab0AHA2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab0AHA2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 19:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625Ab0AHA2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 19:28:34 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60894 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab0AHA2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 19:28:34 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 8 Jan 2010 09:25:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
Message-Id: <20100108092514.f7555c1c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100108092333.1040c799.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100104182429.833180340@chello.nl>
	<20100104182813.753545361@chello.nl>
	<20100105054536.44bf8002@infradead.org>
	<alpine.DEB.2.00.1001050916300.1074@router.home>
	<20100105192243.1d6b2213@infradead.org>
	<alpine.DEB.2.00.1001071007210.901@router.home>
	<alpine.LFD.2.00.1001070814080.7821@localhost.localdomain>
	<1262884960.4049.106.camel@laptop>
	<alpine.LFD.2.00.1001070934060.7821@localhost.localdomain>
	<alpine.LFD.2.00.1001070937180.7821@localhost.localdomain>
	<alpine.LFD.2.00.1001071031440.7821@localhost.localdomain>
	<1262900683.4049.139.camel@laptop>
	<alpine.LFD.2.00.1001071426590.7821@localhost.localdomain>
	<20100108092333.1040c799.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jan 2010 09:23:33 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 7 Jan 2010 14:33:50 -0800 (PST)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > 
> > On Thu, 7 Jan 2010, Peter Zijlstra wrote:
> > >
> > > I haven't yet looked at the patch, but isn't expand_stack() kinda like
> > > what you want? That serializes using anon_vma_lock().
> > 
> > Yeah, that sounds like the right thing to do.  It is the same operation, 
> > after all (and has the same effects, especially for the special case of 
> > upwards-growing stacks).
> > 
> > So basically the idea is to extend that stack expansion to brk(), and 
> > possibly mmap() in general.
> > 
> Hmm, do_brk() sometimes unmap conflicting mapping. Isn't it be a problem ?
> Stack expansion just fails and SEGV if it hit with other mmaps....
Sorry please ignore the last line...

Sorry for noise.
-Kame

