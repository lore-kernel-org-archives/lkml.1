Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbZKDA1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbZKDA1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 19:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbZKDA1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 19:27:21 -0500
Received: from smtp2.ultrahosting.com ([74.213.174.253]:33295 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750838AbZKDA1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 19:27:20 -0500
Date: Tue, 3 Nov 2009 13:34:32 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Ingo Molnar <mingo@elte.hu>
cc: Ian Campbell <Ian.Campbell@citrix.com>, Tejun Heo <tj@kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Correct nr_processes() when CPUs have been unplugged
In-Reply-To: <20091103160734.GA21362@elte.hu>
Message-ID: <alpine.DEB.1.10.0911031324380.32136@V090114053VZO-1>
References: <1257243074.23110.779.camel@zakaz.uk.xensource.com> <20091103160734.GA21362@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009, Ingo Molnar wrote:

> Sidenote: percpu areas currently are kept allocated on x86.

They must be kept allocated for all possible cpus. Arch code cannot decide
to not allocate per cpu areas.

Search for "for_each_possible_cpu" in the source tree if you want more
detail.

> That might change in the future though, especially with virtual systems
> where the possible range of CPUs can be very high - without us
> necessarily wanting to pay the percpu area allocation price for it. I.e.
> dynamic deallocation of percpu areas is something that could happen in
> the future.

Could be good but would not be as easy as you may think since core code
assumes that possible cpus have per cpu areas configured. There will be
the need for additional notifiers and more complex locking if we want to
have percpu areas for online cpus only. Per cpu areas are permanent at
this point which is a good existence guarantee that avoids all sorts of
complex scenarios.

> Nice one. I'm wondering why it was not discovered for such a long time.

Cpu hotplug is rarely used (what you listed are rare and unusual cases)
and therefore online cpus == possible cpus == present cpus.
