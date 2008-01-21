Return-Path: <linux-kernel-owner+w=401wt.eu-S1760763AbYAUXgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760763AbYAUXgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbYAUXgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:36:33 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:21204 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387AbYAUXgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:36:33 -0500
Date: Mon, 21 Jan 2008 15:34:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sam Ravnborg <sam@ravnborg.org>, lkml <linux-kernel@vger.kernel.org>,
       dipankar@in.ibm.com, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] rcu: fix section mismatch
Message-Id: <20080121153409.7511407e.randy.dunlap@oracle.com>
In-Reply-To: <200801211138.38591.rusty@rustcorp.com.au>
References: <20080119115643.43236e70.randy.dunlap@oracle.com>
	<20080119212549.GD29070@uranus.ravnborg.org>
	<200801211138.38591.rusty@rustcorp.com.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jan 2008 11:38:38 +1100 Rusty Russell wrote:

> On Sunday 20 January 2008 08:25:49 Sam Ravnborg wrote:
> > On Sat, Jan 19, 2008 at 11:56:43AM -0800, Randy Dunlap wrote:
> > > rcu_online_cpu() should be __cpuinit instead of __devinit.
> >
> > So if we have:
> > CONFIG_HOTPLUG=n
> > CONFIG_HOTPLUG_CPU=y
> >
> > then this is a oops candidate.
> 
> At first glance, this can't happen because all CONFIG_HOTPLUG_CPU depends on 
> CONFIG_HOTPLUG or selects it, for all archs.

Mostly, but arch/mips/ seems to be different (neither depends nor selects)
unless it has changed very recently (I looked at 2.6.24-rc8).

> But CONFIG_PM_SLEEP_SMP selects CONFIG_HOTPLUG_CPU, without requiring 
> CONFIG_HOTPLUG: turning on SUSPEND or HIBERNATION does this.
> 
> Perhaps it's time to revisit reverse-depends for select?

It would be nice if someone did that.

---
~Randy
