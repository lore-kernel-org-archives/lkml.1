Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101Ab0AQPJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab0AQPJo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 10:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058Ab0AQPJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 10:09:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:49520 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab0AQPJm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 10:09:42 -0500
Subject: Re: [PATCH v3 04/12] Add "handle page fault" PV helper.
From: Peter Zijlstra <peterz@infradead.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       riel@redhat.com, cl@linux-foundation.org
In-Reply-To: <20100117144411.GI31692@redhat.com>
References: <1262700774-1808-1-git-send-email-gleb@redhat.com>
	 <1262700774-1808-5-git-send-email-gleb@redhat.com>
	 <1263490267.4244.340.camel@laptop>  <20100117144411.GI31692@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 17 Jan 2010 16:09:40 +0100
Message-ID: <1263740980.557.20980.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-17 at 16:44 +0200, Gleb Natapov wrote:
> On Thu, Jan 14, 2010 at 06:31:07PM +0100, Peter Zijlstra wrote:
> > On Tue, 2010-01-05 at 16:12 +0200, Gleb Natapov wrote:
> > > Allow paravirtualized guest to do special handling for some page faults.
> > > 
> > > The patch adds one 'if' to do_page_fault() function. The call is patched
> > > out when running on physical HW. I ran kernbech on the kernel with and
> > > without that additional 'if' and result were rawly the same:
> > 
> > So why not program a different handler address for the #PF/#GP faults
> > and avoid the if all together?
> I would gladly use fault vector reserved by x86 architecture, but I am
> not sure Intel will be happy about it.

Whatever are we doing to end up in do_page_fault() as it stands? Surely
we can tell the CPU to go elsewhere to handle faults?

Isn't that as simple as calling set_intr_gate(14, my_page_fault)
somewhere on the cpuinit instead of the regular page_fault handler?
