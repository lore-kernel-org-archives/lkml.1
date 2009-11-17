Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415AbZKQPvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbZKQPvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbZKQPvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:51:40 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:32147 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbZKQPvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:51:39 -0500
Date: Tue, 17 Nov 2009 07:51:01 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: Greg KH <greg@kroah.com>, lud <linux-usb@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 2 (usb/whci)
Message-Id: <20091117075101.0bf72415.randy.dunlap@oracle.com>
In-Reply-To: <4B028BBB.1080803@csr.com>
References: <20091102173845.210d1c57.sfr@canb.auug.org.au>
	<20091102091339.479a3ddb.randy.dunlap@oracle.com>
	<20091111090403.5fb0229e.randy.dunlap@oracle.com>
	<20091111173015.GA9641@kroah.com>
	<4B028BBB.1080803@csr.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B02C67C.0163:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009 11:40:43 +0000 David Vrabel wrote:

> Greg KH wrote:
> > On Wed, Nov 11, 2009 at 09:04:03AM -0800, Randy Dunlap wrote:
> >> On Mon, 2 Nov 2009 09:13:39 -0800 Randy Dunlap wrote:
> >>
> >>> On Mon, 2 Nov 2009 17:38:45 +1100 Stephen Rothwell wrote:
> >>>
> >>>> Hi all,
> >>>>
> >>>> Changes since 20091030: <<<<<<<<<<<<<<<<<<<<<<<<<<
> >>>
> >>> whci build fails on i386 due to 64-bit multiply & divide:
> >>>
> >>> ERROR: "__udivdi3" [drivers/usb/host/whci/whci-hcd.ko] undefined!
> >>> ERROR: "__umoddi3" [drivers/usb/host/whci/whci-hcd.ko] undefined!
> >>
> >> Still present in linux-next-20091111.
> > 
> > David, can you please look into this and resolve it?
> 
> Yes,  I've been on holiday and haven't had a change to look into it yet.
> 
> I can't immediately think of any 64 bit maths and I don't understand why
>  I haven't seen it.  I always build for i386.

When the driver is built-in (not a loadable module), the messages are:

drivers/built-in.o: In function `qset_add_urb':
(.text+0x4595f8): undefined reference to `__umoddi3'
drivers/built-in.o: In function `qset_add_urb':
(.text+0x45969a): undefined reference to `__udivdi3'

Those could still refer to other (inline) functions...

---
~Randy
