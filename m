Return-Path: <linux-kernel-owner+w=401wt.eu-S935353AbZLQBj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935353AbZLQBj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936063AbZLQBiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:38:14 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:58404 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935126AbZLQBiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:38:00 -0500
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode drive -v2
From: john stultz <johnstul@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Keith Mannthey <kmannth@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1261004964.21028.521.camel@laptop>
References: <1260907788.6521.10.camel@keith-laptop>
	 <1261004964.21028.521.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 17:37:51 -0800
Message-ID: <1261013871.7245.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
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

Keith can probably correct me here if I'm wrong, but my understanding is
that the SMIs provide hardware error detection, that while non-fatal
are still important to the management of the system. 

The hardware may be used with other OSes or older Linux distros that do
not provide a replacement for the SMI functionality. Further, disabling
the SMIs can limit other features like power-throttling by the hardware,
so its not something that can be always disabled in the hardware.

So this driver provides a switch to allow the System to notify the
hardware that the OS is capable of providing the error detection and is
taking that responsibility over.

The second piece required, which uses this interface to notify the BIOS
its taking over this responsibility, is the ibm-prtmd daemon. This is
the userland app that monitors the edac driver and sends the ipmi
messages to the management module.

thanks
-john

