Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbYFKJoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbYFKJoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 05:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbYFKJn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 05:43:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:59214 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbYFKJn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 05:43:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,623,1204531200"; 
   d="scan'208";a="258504194"
Subject: Re: [linux-pm] [PATCH -mm 2/2] kexec jump -v11: save/restore
	device state
From: "Huang, Ying" <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0806110418370.4233@localhost.localdomain>
References: <1213082106.22608.30.camel@caritas-dev.intel.com>
	 <alpine.LFD.1.10.0806101400090.14381@localhost.localdomain>
	 <1213146074.21923.10.camel@caritas-dev.intel.com>
	 <alpine.LFD.1.10.0806110418370.4233@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 11 Jun 2008 17:46:24 +0800
Message-Id: <1213177584.17610.0.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 11 Jun 2008 09:43:51.0648 (UTC) FILETIME=[A7DF8600:01C8CBA7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-11 at 04:21 -0400, Len Brown wrote:
> On Wed, 11 Jun 2008, Huang, Ying wrote:
> > On Tue, 2008-06-10 at 14:01 -0400, Len Brown wrote:
> > > 
> > > On Tue, 10 Jun 2008, Huang, Ying wrote:
> > > 
> > > > This patch implements devices state save/restore before after kexec.
> > > > 
> > > > 
> > > > This patch together with features in kexec_jump patch can be used for
> > > > following:
> > > > 
> > > > - A simple hibernation implementation without ACPI support. You can
> > > >   kexec a hibernating kernel, save the memory image of original system
> > > >   and shutdown the system. When resuming, you restore the memory image
> > > >   of original system via ordinary kexec load then jump back.
> > > 
> > > What part of ACPI's role in hibernation are you trying to avoid
> > > 1. enabling wake devices
> > > 2. removing power from the system
> > > 3. something else?
> > 
> > ACPI S5 is used instead of S4 for this simple hibernation
> > implementation. That is, before creating the hibernation image, the ACPI
> > _PTS is not executed, devices are not put into low power state and wake
> > devices are not enabled. After creating the hibernation image, the image
> > is saved to disk and system is shutdown (go to S5). When resuming from
> > hibernated image, ACPI _BFS and _WAK are not executed too.
> 
> Doesn't that resume the devices and their drivers into an unknown state?

device_suspend(PMSG_FREEZE) and device_power_down(PMSG_FREEZE) are
called before hibernation; device_power_up(PMSG_RESTORE) and
device_resume(PMSG_RESTORE) are called after restore. The new
hibernation/restore device driver callbacks introduced by Rafael is
used. So I think the device/driver state will be saved/restored
properly.

It is planed to support ACPI S4 in the future. But I think a hibernation
scheme without ACPI may be useful in some situation too.

Best Regards,
Huang Ying

