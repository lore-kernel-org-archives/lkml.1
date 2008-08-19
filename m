Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbYHSDla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbYHSDla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 23:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbYHSDlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 23:41:21 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:59472 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752579AbYHSDlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 23:41:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtIFAOfdqUhMRKxB/2dsb2JhbACBYrNhgVg
Date: Mon, 18 Aug 2008 23:36:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       Eran Liberty <liberty@extricom.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Steven Rostedt <srostedt@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
Message-ID: <20080819033618.GA24085@Krystal>
References: <48A9901B.1080900@redhat.com> <20080818154746.GA26835@Krystal> <48A9AFA7.8080508@freescale.com> <alpine.DEB.1.10.0808181425090.796@gandalf.stny.rr.com> <1219110814.8062.2.camel@pasglop> <alpine.DEB.1.10.0808182208110.13401@gandalf.stny.rr.com> <1219113549.8062.13.camel@pasglop> <alpine.DEB.1.10.0808182240330.13401@gandalf.stny.rr.com> <20080819024707.GA22659@Krystal> <alpine.DEB.1.10.0808182329220.13401@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808182329220.13401@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:35:35 up 75 days,  8:16,  8 users,  load average: 0.42, 0.46,
	0.43
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Mon, 18 Aug 2008, Mathieu Desnoyers wrote:
> 
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > 
> > > On Tue, 19 Aug 2008, Benjamin Herrenschmidt wrote:
> > > 
> > > > 
> > > > > Hmm, this was originally copied from x86, where we did a cmpxchg, but that 
> > > > > is probably not needed since all of this is done in kstop_machine. Also, 
> > > > > only the "get" is needed. If we don't fault there, we wont fault on the 
> > > > > put (unless we have permissions wrong, and that would be a bug).
> > > > 
> > > > Would it ? How do we make sure the kernel text is mapped writeable ?
> > > 
> > > We map it writeable if FTRACE is enabled.
> > > 
> > 
> > Argh. See text_poke(). It's there exactly for this purpose on x86.
> 
> Ouch, I just did. text_poke is quite heavy. It would be interesting to see 
> that performed on 20,000 locations at one time. I could play with it, but 
> I'm a bit nervous.
> 

It's alread used to modify the LOCK prefixes in alternative.c and did
not seem to be too slow for that.. it should therefore be ok.

Mathieu

> -- Steve

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
