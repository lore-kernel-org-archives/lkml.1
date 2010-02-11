Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab0BKPcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 10:32:12 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47223 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755377Ab0BKPcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 10:32:10 -0500
Date: Thu, 11 Feb 2010 10:32:08 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the suspend tree
In-Reply-To: <201002111411.35634.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1002111029440.1571-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, Rafael J. Wysocki wrote:

> On Thursday 11 February 2010, Stephen Rothwell wrote:
> > Hi Rafael,
> > 
> > After merging the suspend tree, today's linux-next build (powerpc
> > ppc64_defconfig) produced this warning:
> > 
> > drivers/usb/core/hcd-pci.c:138: warning: 'wait_for_companions' defined but not used
> > 
> > Introduced by commit ce74abf51a15ab82a9fae6dcd8a9c0038945f10e ("USB:
> > implement non-tree resume ordering constraints for PCI host controllers").
> 
> Thanks for the info, I'll fix this up later today in my tree.

Clearly wait_for_companions() needs to be inside "#ifdef
CONFIG_PM_SLEEP ... #endif".  In fact, all the new functions added by
the patch should be protected this way, with suitable do-nothing inline
versions provided when CONFIG_PM_SLEEP isn't defined.

Alan Stern

