Return-Path: <linux-kernel-owner+w=401wt.eu-S1756624AbZJ0I0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbZJ0I0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 04:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbZJ0I0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 04:26:33 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60572 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756615AbZJ0I0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 04:26:31 -0400
Date: Tue, 27 Oct 2009 09:26:35 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alex Chiang <achiang@hp.com>
Cc: Mark Lord <lkml@rtr.ca>, Greg KH <greg@kroah.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
Message-ID: <20091027082635.GS10727@kernel.dk>
References: <20091012145700.GJ9228@kernel.dk> <4AD34494.7020602@rtr.ca> <20091012150603.GK9228@kernel.dk> <20091012214854.GA14102@ldl.fc.hp.com> <20091013082903.GQ9228@kernel.dk> <20091013172731.GB22797@ldl.fc.hp.com> <20091014081309.GM9228@kernel.dk> <20091020190707.GA25615@ldl.fc.hp.com> <20091026105419.GA10727@kernel.dk> <20091027024841.GA30509@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027024841.GA30509@ldl.fc.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26 2009, Alex Chiang wrote:
> * Jens Axboe <jens.axboe@oracle.com>:
> > > > acpiphp: enable_slot - physical_slot = 1
> > > > acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
> > > > acpiphp: enable_slot - physical_slot = 2
> > > > acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
> > > > acpiphp: enable_slot - physical_slot = 6
> > > > acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
> > > > acpiphp: enable_slot - physical_slot = 7
> > > > acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL
> > > 
> > > Hm, so for some reason, firmware on your machine is telling us
> > > that it doesn't think cards are present and/or enabled.
> > > 
> > > Unfortunately, I don't know why your firmware would be saying
> > > that. We could add some more debug printks to see what firmware
> > > thinks about your system... Or we could just wait and see what
> > > happens after you get your hardware replaced.
> 
> Let's try and find out why firmware is telling us that we didn't
> get ACPI_STA_ALL.
> 
> Can you please apply this debug patch and send the output? Again,
> please modprobe with debug=1.

acpiphp: enable_slot - physical_slot = 1
power_on_slot
  no _PS0
  no _PS0
  no _PS0
  no _PS0
  no _PS0
  no _PS0
  no _PS0
  no _PS0
get_slot_status
  reading config space dvid 0xffffffff
  reading config space dvid 0xffffffff
  reading config space dvid 0xffffffff
  reading config space dvid 0xffffffff
  reading config space dvid 0xffffffff
  reading config space dvid 0xffffffff
  reading config space dvid 0xffffffff
  reading config space dvid 0xffffffff
acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL

-- 
Jens Axboe

