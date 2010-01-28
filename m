Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771Ab0A1IHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab0A1IHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 03:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191Ab0A1IHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 03:07:21 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:44426 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab0A1IHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 03:07:19 -0500
Subject: Re: PROBLEM: reproducible crash KVM+nf_conntrack all recent 2.6
 kernels
From: Jon Masters <jonathan@jonmasters.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org
In-Reply-To: <1264663210.2793.110.camel@tonnant>
References: <1264657559.2793.103.camel@tonnant>
	 <1264663210.2793.110.camel@tonnant>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Thu, 28 Jan 2010 03:07:11 -0500
Message-Id: <1264666031.2793.117.camel@tonnant>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-28 at 02:20 -0500, Jon Masters wrote:
> On Thu, 2010-01-28 at 00:46 -0500, Jon Masters wrote:
> 
> > A number of people seem to have reported this crash in various forms,
> > but I have yet to see a solution, and can reproduce on 2.6.33-rc5 this
> > evening so I know it's still present in the latest upstream kernels too.
> > Userspace is Fedora 12, and this happens on both all recent F12 kernels
> > (sporadic in 2.6.31 until recently, solidly reproducible on 2.6.32) and
> > upstream 2.6.32, and 2.6.33-rc5 also - hard to find a "known good".
> > 
> > The problem happens when using netfilter with KVM (problem does not
> > occur without the firewall loaded, for example) and will occur within a
> > few minutes of attempting to start or stop a guest that is connecting to
> > the network - the easiest way to reproduce so far is simply to start up
> > a bunch of Fedora guests and have them do a "yum update" cycle.
> > 
> > All of the crashes appear similar to the following (2.6.33-rc5):
> 
> Rebuilt the kernel with all debug options turned on, got some lockdep
> warnings (haven't looked further yet). Here's the output (attached full
> boot log also):

> [  339.730086] RIP: 0010:[<ffffffff813e5f3e>]  [<ffffffff813e5f3e>]
> nf_ct_remove_expectations+0x49/0x5c

This appears to be in the hlist_for_each_entry_safe iteration within
nf_ct_remove_expectations, iterating over the list of nf_conn_help(ers)
returned by nfct_help. I don't know what that code does (I have an idea
but only at a high level at this stage), though I'm poking a little here
to see if I can understand enough of netfilter to be useful. Feel free
to give me some pointers to help you guys debug this faster.

Jon.


