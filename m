Return-Path: <linux-kernel-owner+w=401wt.eu-S1763891AbZLQCGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763891AbZLQCGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 21:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754991AbZLQCGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 21:06:30 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40000 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbZLQCG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 21:06:28 -0500
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode drive -v2
From: Keith Mannthey <kmannth@us.ibm.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1261013871.7245.21.camel@localhost.localdomain>
References: <1260907788.6521.10.camel@keith-laptop>
	 <1261004964.21028.521.camel@laptop>
	 <1261013871.7245.21.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 16 Dec 2009 18:06:27 -0800
Message-Id: <1261015587.6521.95.camel@keith-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 17:37 -0800, john stultz wrote:
> On Thu, 2009-12-17 at 00:09 +0100, Peter Zijlstra wrote:
> > On Tue, 2009-12-15 at 12:09 -0800, Keith Mannthey wrote:
> > > This driver supports the Real-Time Linux (RTL) BIOS feature.  The RTL
> > > feature allows non-fatal System Management Interrupts (SMIs) to be
> > > disabled on supported IBM platforms. 
> > > 
> > > 
> > > The Device is presented as a special "_rtl_" table to the OS in the
> > > Extended BIOS Data Area.  There is a simple protocol for entering and
> > > exiting the mode at runtime.  This driver creates a simple sysfs
> > > interface to allow a simple entry and exit from RTL mode in the
> > > UFI/BIOS. 
> > 
> > Why not simply always run with these non-fatal SMIs disabled and provide
> > their function through the OS proper?
> > 
> > That way you don't need no silly switches and gain consistent platform
> > behaviour.
> 
> Keith can probably correct me here if I'm wrong, but my understanding is
> that the SMIs provide hardware error detection, that while non-fatal
> are still important to the management of the system. 
> 
> The hardware may be used with other OSes or older Linux distros that do
> not provide a replacement for the SMI functionality. Further, disabling
> the SMIs can limit other features like power-throttling by the hardware,
> so its not something that can be always disabled in the hardware.
> 
> So this driver provides a switch to allow the System to notify the
> hardware that the OS is capable of providing the error detection and is
> taking that responsibility over.
> 
> The second piece required, which uses this interface to notify the BIOS
> its taking over this responsibility, is the ibm-prtmd daemon. This is
> the userland app that monitors the edac driver and sends the ipmi
> messages to the management module.

Just to clarify a bit:

To properly enter the mode you need to ask the BIOS to enter the mode
(this driver) and then ask the BMC (service processor via ipmi), then
you need to start real ecc detection and reporting services.  With all
that working you are running with comparable hardware RAS. 

The 3 parts are:
RTL kernel driver (this patch)
Working ECC error detection (EDAC drivers presently)
Userspace to manage the mode changes and ecc error reporting (ibm-prtm)

https://sourceforge.net/projects/ibm-prtm there is not much more than
the code there but that is the user space part of the equation. 

Thanks,
  Keith Mannthey
  LTC Real-Time 

