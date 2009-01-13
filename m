Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbZAMU1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbZAMU1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 15:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbZAMU1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 15:27:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39761
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752599AbZAMU1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 15:27:02 -0500
Date: Tue, 13 Jan 2009 12:27:03 -0800 (PST)
Message-Id: <20090113.122703.157508326.davem@davemloft.net>
To: mcarlson@broadcom.com
Cc: dwmw2@infradead.org, Valdis.Kletnieks@vt.edu, alessandro.suardi@gmail.com,
       jaswinderlinux@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.28-git8: tg3 doesn't work due to firmware not loading
 (-git7 is ok)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090113183948.GA21847@xw6200.broadcom.net>
References: <1231676698.25018.147.camel@macbook.infradead.org>
	<20090111.133929.57600645.davem@davemloft.net>
	<20090113183948.GA21847@xw6200.broadcom.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Matt Carlson" <mcarlson@broadcom.com>
Date: Tue, 13 Jan 2009 10:39:48 -0800

> On Sun, Jan 11, 2009 at 01:39:29PM -0800, David Miller wrote:
> > From: David Woodhouse <dwmw2@infradead.org>
> > Date: Sun, 11 Jan 2009 12:24:58 +0000
> > 
> > > Other drivers will load the firmware later, at the time the device is
> > > brought up. This means that even if you build the driver into the kernel
> > > without its firmware, it can still request the firmware later, when you
> > > try to start _using_ it. And when the file system is available.
> > 
> > For example, for mounting an NFS root using that device.... Oh, will I
> > need an initramfs for that once you pull the firmware-in-kernel
> > option?
> > 
> > To me, device probe is in fact the place to fail firmware discovery
> > for networking devices.  Because such a failure can mean you can't
> > mount your root filesystem.
> 
> David, is this the direction you want to take the fix?  I'm sitting on
> a patch that elaborates on David Woodhouse's work which moves the
> request_firmware call to tg3_open().  Before I posted it for comment,
> I wanted to make sure the patch is moving in the right direction.

You can post it, sure.

But it doesn't actually fix the nfsroot case, that will still be
broken.
