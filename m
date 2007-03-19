Return-Path: <linux-kernel-owner+w=401wt.eu-S1030746AbXCSXnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030746AbXCSXnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 19:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030753AbXCSXnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 19:43:15 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:60779 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030756AbXCSXnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 19:43:13 -0400
Date: Mon, 19 Mar 2007 16:41:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: Mike Galbraith <efault@gmx.de>, Andrew Morton <akpm@linux-foundation.org>,
       Tejun Heo <htejun@gmail.com>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>
Subject: Re: kref refcounting breakage in mainline
Message-Id: <20070319164123.756b43a7.randy.dunlap@oracle.com>
In-Reply-To: <20070315145414.GA18542@kroah.com>
References: <20070302005833.949be737.akpm@linux-foundation.org>
	<20070306002521.GA12164@kroah.com>
	<1173159802.6955.6.camel@Homer.simpson.net>
	<20070306210445.GB29164@kroah.com>
	<1173245937.6613.26.camel@Homer.simpson.net>
	<1173541446.6561.32.camel@Homer.simpson.net>
	<20070315052724.GA12576@kroah.com>
	<1173945187.6624.14.camel@Homer.simpson.net>
	<20070315080639.GA14641@kroah.com>
	<1173953960.6624.45.camel@Homer.simpson.net>
	<20070315145414.GA18542@kroah.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007 07:54:14 -0700 Greg KH wrote:

> On Thu, Mar 15, 2007 at 11:19:20AM +0100, Mike Galbraith wrote:
> > On Thu, 2007-03-15 at 01:06 -0700, Greg KH wrote:
> > 
> > > That's good.  But why don't we have a module name for this driver?
> > > 
> > > And if we don't have a module name, why would there be a symlink to
> > > remove?  That's what is keeping your module from unloading, right?
> > 
> > You keep saying "module", and that's making me a bit nervous ;-)
> > 
> > Just to be sure we're not talking past each other, when you say module,
> > don't mean the modprobe kind... i hope.  This "module" as in driver is
> > compiled in.  (said that before, but you may have missed it)
> 
> Ahh, that changes everything here, thanks for letting me know, I had
> missed this.
> 
> The problem is that the module_init() is failing, yet this isn't really
> a module, it's built into the kernel.  So some of the module teardown
> logic is dieing when it thinks that we really have a full module
> structure here (owner and such).

Urgh, it's not a "loadable" module, but it's still a logical module.

> I'll look at this further tomorrow, as I'm travelling pretty much all
> day today, sorry.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
