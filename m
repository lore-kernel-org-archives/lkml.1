Return-Path: <linux-kernel-owner+w=401wt.eu-S935923AbZDISRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935923AbZDISRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758669AbZDISRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:17:42 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54096 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756441AbZDISRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:17:42 -0400
Date: Thu, 9 Apr 2009 14:17:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
cc: linux-pm@lists.linux-foundation.org, <schwidefsky@de.ibm.com>,
       <ubraun@linux.vnet.ibm.com>, <heiko.carstens@de.ibm.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [RFC][PATCH] Add late pm notifiers for hibernate
In-Reply-To: <1239205077.4241.15.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0904091414340.2992-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009, Michael Holzheu wrote:

> From: Michael Holzheu <holzheu at linux.vnet.ibm.com>
> 
> This patch is a suggestion to solve the issue reported by Ursula Braun:
> https://lists.linux-foundation.org/pipermail/linux-pm/2009-March/020443.html
> 
> On s390 we have device drivers that don't belong to a Linux bus. Therefore
> we can't use the PM device callbacks (dev_pm_ops). The only way to get
> informed that we hibernate or resume is the pm_notifier_call_chain.

I'm curious to know what device drivers these are that don't have a 
bus.  Could they use the platform bus?  That's more or less what it's 
intended for -- devices that don't fit anywhere else.

> Unfortunately some of our drivers need a frozen userspace to do their
> hibernate actions and the current notifiers are called before userspace is
> frozen. Another point is that we want our console driver to suspend as late
> as possible so that we can see all the hibernate progress messages on the
> console.

It's possible to avoid suspending the console at all if you boot with
"no_console_suspend" as a kernel parameter.

Alan Stern

