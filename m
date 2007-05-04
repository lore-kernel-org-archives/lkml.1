Return-Path: <linux-kernel-owner+w=401wt.eu-S1766618AbXEDUjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766618AbXEDUjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 16:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766611AbXEDUjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 16:39:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:40542 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766579AbXEDUjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 16:39:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,494,1170662400"; 
   d="scan'208";a="242093562"
Date: Fri, 4 May 2007 13:36:45 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, htejun@gmail.com, akpm@linux-foundation.org
Subject: Re: [patch 0/7] Asynchronous Notification for ATAPI devices (v2) -
 resend
Message-Id: <20070504133645.7d053549.kristen.c.accardi@intel.com>
In-Reply-To: <1178310603.3711.54.camel@mulgrave.il.steeleye.com>
References: <20070504111222.c2e373cf.kristen.c.accardi@intel.com>
	<1178310603.3711.54.camel@mulgrave.il.steeleye.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 May 2007 15:30:03 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Fri, 2007-05-04 at 11:12 -0700, Kristen Carlson Accardi wrote:
> > This patch series implements Asynchronous Notification (AN) for SATA
> > ATAPI devices as defined in SATA 2.5 and AHCI 1.1 and higher.  Drives
> > which support this feature will send a notification when new media is
> > inserted and removed, preventing the need for user space to poll for
> > new media.  This support is exposed to user space via a flag that will
> > be set in /sys/block/sr*/capability_flags.  If the flag is set, user
> > space can disable polling for the new media, and the genhd driver will
> > send a KOBJ_CHANGE event with the envp set to MEDIA_CHANGE_EVENT=1.
> > 
> > Note that this patch only implements support for directly attached
> > drives - AN with drives attached to a port multiplier requires 
> > additional changes.
> 
> I seem to remember when this came up before, the observation was made
> that AENs occur for many more things than simple media change notices,
> so we should probably have a more generic AEN handling mechanism.  Is
> there any plan to move in this direction
> 
> James
> 
In this implementation, we use kobject_uevent_env (vs. just 
kobject_uevent in the original implementation) to send a KOBJ_CHANGE
with the enviroment value of MEDIA_CHANGE=1.  For other asynchronous
events, you could still use KOBJ_CHANGE with a different env value.
