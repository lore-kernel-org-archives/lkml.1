Return-Path: <linux-kernel-owner+w=401wt.eu-S1751462AbZHRUA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbZHRUA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 16:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbZHRUA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 16:00:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55724 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbZHRUA2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 16:00:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC][PATCH 0/7] PM: Asynchronous suspend and resume (updated)
Date: Tue, 18 Aug 2009 22:01:11 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, Greg KH <gregkh@suse.de>
References: <200908122218.13975.rjw@sisk.pl> <200908170215.21173.rjw@sisk.pl> <1250579793.5351.79.camel@rzhang-dt>
In-Reply-To: <1250579793.5351.79.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908182201.11489.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 August 2009, Zhang Rui wrote:
> On Mon, 2009-08-17 at 08:15 +0800, Rafael J. Wysocki wrote:
> > On Wednesday 12 August 2009, Rafael J. Wysocki wrote:
> > > Hi,
> > > 
> > > The following patches introduce a mechanism allowing us to execute device
> > > drivers' suspend and resume callbacks asynchronously during system sleep
> > > transitions, such as suspend to RAM.  The idea is explained in the [1/1] patch
> > > message.
> > 
> > Changes:
> > 
> > * Added [1/7] that fixes kerneldoc comments in drivers/base/power/main.c
> >   (this is a 2.6.32 candidate).
> > 
> > * Added [2/7] adding a framework for representing PM link (idea described
> >   in the patch message).
> > 
> > * [3/7] is the async resume patch (idea described in the patch message).
> > 
> > * [4/7] is the async suspend patch.
> > 
> > * [5/7] - [7/7] set async_suspend for devices in a few selected subsystems.
> > 
> > The patches have been tested on HP nx6325.
> > 
> I tried this patch set and it does work. :)
> But unfortunately it doesn't save too much time.
> 
> I still think that the child device should inherit its parent's
> async_suspend flag to do the asynchronous resume more efficiently.
> 
> or at least we should provide such an interface
> in ﻿drivers/base/power/common.c, so that device can tell the device core
> to inherit this flag if there is no off-tree dependency.

Well, I'd prefer to identify all of the off-tree dependencies that have to be
taken into account and handle all devices asynchronously.

Thanks,
Rafael
