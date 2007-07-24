Return-Path: <linux-kernel-owner+w=401wt.eu-S1760741AbXGXN0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741AbXGXN0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 09:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbXGXN0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 09:26:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:64571 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345AbXGXN0o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 09:26:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,574,1175497200"; 
   d="scan'208";a="254056069"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [linux-pm] Re: Hibernation considerations
Date: Tue, 24 Jul 2007 21:26:35 +0800
Message-ID: <9D7649D18729DE4BB2BD7B494F7FEDC236CF5C@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <Pine.LNX.4.44L0.0707231605410.2556-100000@iolanthe.rowland.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [linux-pm] Re: Hibernation considerations
Thread-Index: AcfNZzRH1AJF/7lyQCex9Hk4S3/JIgAjBHSQ
From: "Huang, Ying" <ying.huang@intel.com>
To: "Alan Stern" <stern@rowland.harvard.edu>, <david@lang.hm>
Cc: "Jeremy Maitin-Shepard" <jbms@cmu.edu>, "Milton Miller" <miltonm@bga.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       <nigel@nigel.suspend2.net>, "Pavel Machek" <pavel@ucw.cz>
X-OriginalArrivalTime: 24 Jul 2007 13:26:38.0933 (UTC) FILETIME=[43F81850:01C7CDF6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Alan Stern [mailto:stern@rowland.harvard.edu]
>It can't.  Indeed, in the absence of a freezer, user threads will need
>devices (more accurately, will submit I/O requests for devices) that
>have to be kept quiescent or low-power.  Drivers will need to delay
>those requests until the devices are returned to full operation.
>
>That's exactly what I've been saying all along: Drivers will need to
>be changed to delay I/O requests, if there is no freezer.

If it is a too big work to implement "delaying I/O requests" for every
driver, is it possible to implement it as follow:

1. It is triggered to suspend to RAM/DISK.
2. Replace the driver related syscall entries (such as sys_read,
sys_write, sys_ioctl, etc) in sys_call_table with special wrapper
entries provided by "suspend to RAM/DISK" subsystem, which will delay
I/O requests if appropriate.
3. When devices are quiesced, they are put into "low power" state and
system is put into suspend state; or the image is written to disk
(through snapshot/uswsusp or kexeced kernel).
4. After resuming from RAM/DISK, devices are put into "normal" state and
the syscall entries replaced in step 2 are restored.

Best Regards,
Huang Ying
