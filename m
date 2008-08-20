Return-Path: <linux-kernel-owner+w=401wt.eu-S1758717AbYHTOuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717AbYHTOuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 10:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756959AbYHTOul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 10:50:41 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:54582 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874AbYHTOuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 10:50:39 -0400
Date: Wed, 20 Aug 2008 10:50:35 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Eran Liberty <liberty@extricom.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Steven Rostedt <srostedt@redhat.com>, Alan Modra <amodra@au1.ibm.com>,
       Scott Wood <scottwood@freescale.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       segher@kernel.crashing.org
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
Message-ID: <20080820105035.49f29509@zod.rchland.ibm.com>
In-Reply-To: <alpine.DEB.1.10.0808201022080.23571@gandalf.stny.rr.com>
References: <48591941.4070408@extricom.com>
	<48A92E15.2080709@extricom.com>
	<48A9901B.1080900@redhat.com>
	<20080818154746.GA26835@Krystal>
	<48A9AFA7.8080508@freescale.com>
	<alpine.DEB.1.10.0808181425090.796@gandalf.stny.rr.com>
	<1219110814.8062.2.camel@pasglop>
	<alpine.DEB.1.10.0808182208110.13401@gandalf.stny.rr.com>
	<1219113549.8062.13.camel@pasglop>
	<1219114600.8062.15.camel@pasglop>
	<alpine.DEB.1.10.0808182304300.13401@gandalf.stny.rr.com>
	<1219119431.8062.35.camel@pasglop>
	<1219216705.21386.46.camel@pasglop>
	<alpine.DEB.1.10.0808200913070.13132@gandalf.stny.rr.com>
	<1219241819.26429.24.camel@jdub.homelinux.org>
	<alpine.DEB.1.10.0808201022080.23571@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008 10:22:49 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Wed, 20 Aug 2008, Josh Boyer wrote:
> > 
> > Segher was looking at this a bit this morning.  He thinks it's really
> > -fno-omit-frame-pointer that is causing this.  That really shouldn't
> > even be set on PowerPC, but FTRACE uses select which overrides the
> > depends on stuff in Kconfig.
> 
> I can easily make a patch that makes that select an x86 only.

That's probably a first step, but you might want to wait until Segher
can fill in more details.  I'm sort of just relaying what he and I were
talking about on IRC.  IIRC, he was testing builds with and without
both -pg and -fno-omit-frame-pointer and found the bug only when
-fno-omit-frame-pointer was present.

josh
