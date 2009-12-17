Return-Path: <linux-kernel-owner+w=401wt.eu-S1763858AbZLQBvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763858AbZLQBvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936149AbZLQBvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:51:14 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47987 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763779AbZLQBu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:50:57 -0500
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode drive -v2
From: Keith Mannthey <kmannth@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>
In-Reply-To: <1261004964.21028.521.camel@laptop>
References: <1260907788.6521.10.camel@keith-laptop>
	 <1261004964.21028.521.camel@laptop>
Content-Type: text/plain
Date: Wed, 16 Dec 2009 17:50:55 -0800
Message-Id: <1261014655.6521.84.camel@keith-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-17 at 00:09 +0100, Peter Zijlstra wrote:
> On Tue, 2009-12-15 at 12:09 -0800, Keith Mannthey wrote:
> > This driver supports the Real-Time Linux (RTL) BIOS feature.  The RTL
> > feature allows non-fatal System Management Interrupts (SMIs) to be
> > disabled on supported IBM platforms. 
> > 
> > 
> > The Device is presented as a special "_rtl_" table to the OS in the
> > Extended BIOS Data Area.  There is a simple protocol for entering and
> > exiting the mode at runtime.  This driver creates a simple sysfs
> > interface to allow a simple entry and exit from RTL mode in the
> > UFI/BIOS. 
> 
> Why not simply always run with these non-fatal SMIs disabled and provide
> their function through the OS proper?
> 
> That way you don't need no silly switches and gain consistent platform
> behaviour.

Peter, 

This driver will load and work on widely used Intel and AMD based IBM
hardware.  A decent amount of the IBM blades and a few of the rack-mount
servers with regular firmware support this mode.  This is not special
hardware with special features is is regular hardware/firmware that can
enter this special mode.

There are 2 major things that change when you in this mode that keep it
from being a good fit for many situations. 

1. ECC memory error detection and reporting is the sole responsibility
of the OS. I have practical experience with this and let just say this
does not "just work" everywhere even within Linux. 

2. The cpu can no longer be externally throttled. This means externally
implemented cooling or power saving options just don't work. 

These 2 things make it impractical for it to be an all the time
everywhere type of thing.  I think a run time state change the OS can
request is a good fit for the issues and complications at hand.

Thanks,
  Keith Mannthey 
  LTC Real-Time 

