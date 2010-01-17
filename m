Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127Ab0AQPMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab0AQPMq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 10:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910Ab0AQPMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 10:12:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882Ab0AQPMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 10:12:45 -0500
Date: Sun, 17 Jan 2010 17:12:18 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       riel@redhat.com, cl@linux-foundation.org
Subject: Re: [PATCH v3 04/12] Add "handle page fault" PV helper.
Message-ID: <20100117151218.GJ31692@redhat.com>
References: <1262700774-1808-1-git-send-email-gleb@redhat.com>
 <1262700774-1808-5-git-send-email-gleb@redhat.com>
 <1263490267.4244.340.camel@laptop>
 <20100117144411.GI31692@redhat.com>
 <1263740980.557.20980.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263740980.557.20980.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 17, 2010 at 04:09:40PM +0100, Peter Zijlstra wrote:
> On Sun, 2010-01-17 at 16:44 +0200, Gleb Natapov wrote:
> > On Thu, Jan 14, 2010 at 06:31:07PM +0100, Peter Zijlstra wrote:
> > > On Tue, 2010-01-05 at 16:12 +0200, Gleb Natapov wrote:
> > > > Allow paravirtualized guest to do special handling for some page faults.
> > > > 
> > > > The patch adds one 'if' to do_page_fault() function. The call is patched
> > > > out when running on physical HW. I ran kernbech on the kernel with and
> > > > without that additional 'if' and result were rawly the same:
> > > 
> > > So why not program a different handler address for the #PF/#GP faults
> > > and avoid the if all together?
> > I would gladly use fault vector reserved by x86 architecture, but I am
> > not sure Intel will be happy about it.
> 
> Whatever are we doing to end up in do_page_fault() as it stands? Surely
> we can tell the CPU to go elsewhere to handle faults?
> 
> Isn't that as simple as calling set_intr_gate(14, my_page_fault)
> somewhere on the cpuinit instead of the regular page_fault handler?
> 
Hmm, good idea. I'll look into that. Thanks.

--
			Gleb.
