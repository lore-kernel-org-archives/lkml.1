Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbZHRNrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbZHRNrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 09:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbZHRNrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 09:47:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50974 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753568AbZHRNrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 09:47:41 -0400
Date: Tue, 18 Aug 2009 09:47:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Zhang Rui <rui.zhang@intel.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
       Greg KH <gregkh@suse.de>
Subject: Re: [RFC][PATCH 5/7] PM: Asynchronous suspend and resume of PCI
 devices
In-Reply-To: <1250578628.5351.64.camel@rzhang-dt>
Message-ID: <Pine.LNX.4.44L0.0908180947080.2995-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009, Zhang Rui wrote:

> On Mon, 2009-08-17 at 08:20 +0800, Rafael J. Wysocki wrote:
> > Set async_suspend for all PCI devices and PCIe port services.
> > 
> ﻿Alan said that we can not break the resume order of the uhci/ehci host
> controllers on some platforms.
> 
> For example,
> 00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
> Controller #4 (rev 02)
> 00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
> Controller #5 (rev 02)
> 00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI
> Controller #2 (rev 02)
> 00:1a.7 must be resumed after 00:1a.0 and 00:1a.1
> 
> please refer to this thread:
> http://marc.info/?l=linux-acpi&m=122996117918188&w=2
> 
> So I'm afraid we can not suspend/resume the PCI devices in parallel,
> unless we add this off-tree dependency at the same time.

It's okay for testing.  The dependency is needed mostly for 
resume-from-hibernation.

Alan Stern

