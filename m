Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYCUPXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYCUPXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 11:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbYCUPXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 11:23:07 -0400
Received: from relay1.sgi.com ([192.48.171.29]:35948 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751423AbYCUPXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 11:23:06 -0400
Date: Fri, 21 Mar 2008 10:23:05 -0500
From: Jack Steiner <steiner@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: ak@suse.de, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - Allow NODES_SHIFT to be a config option on x86_64
Message-ID: <20080321152305.GA28098@sgi.com>
References: <20080321133425.GA11095@sgi.com> <20080321142648.GB31719@elte.hu> <20080321145401.GA10303@sgi.com> <20080321145736.GC1545@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321145736.GC1545@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 03:57:36PM +0100, Ingo Molnar wrote:
> 
> * Jack Steiner <steiner@sgi.com> wrote:
> 
> > On Fri, Mar 21, 2008 at 03:26:49PM +0100, Ingo Molnar wrote:
> > > 
> > > * Jack Steiner <steiner@sgi.com> wrote:
> > > 
> > > > Allow the maximum number of nodes in an x86_64 system to be 
> > > > configurable. This patch does NOT change the default value but allows 
> > > > the value to be a config option.
> > > 
> > > i've applied your patch - but i'm wondering, shouldnt we auto-scale the 
> > > default according to max number of CPUs? (with some sensible scaling 
> > > that happens to meet your expected large-system needs as well ;-) All 
> > > the current manual configuration of nodes shift is ugly.
> > 
> > I would prefer to auto-scale, too, but our hardware platform allows 
> > too many options to make it easy. The current system configs will 
> > support from 0 to 32 cpus per node (some nodes have memory only).
> > 
> > However, I'm open to suggestions if you have any ideas....
> 
> how about scaling for the worst case, and allowing distros to tune down 
> if they really want? What's the cost of a too large NODE_SHIFT?
> 


NODE_SHIFT affects a number of nodemasks so you probably don't want it
a lot larger than needed - especially if you are going over 64 nodes. Our
target value is currently 512 although it is possible that it may
change to 256.

Let me do some experiments on auto-config. I'll get back to you....

--- jack

