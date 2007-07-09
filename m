Return-Path: <linux-kernel-owner+w=401wt.eu-S1757684AbXGISKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684AbXGISKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 14:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbXGISJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 14:09:55 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:29096 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753600AbXGISJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 14:09:54 -0400
Message-ID: <469279EA.4020702@cfl.rr.com>
Date: Mon, 09 Jul 2007 14:09:46 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Kent Overstreet <kent.overstreet@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] LVM/RAID/FS integration
References: <6f703f960706271609m6fdfb9c1ha3555a68fe1d9d55@mail.gmail.com>
In-Reply-To: <6f703f960706271609m6fdfb9c1ha3555a68fe1d9d55@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jul 2007 18:10:06.0030 (UTC) FILETIME=[60CAE6E0:01C7C254]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1021-15288.000
X-TM-AS-Result: No--4.623600-5.000000-2
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kent Overstreet wrote:
> The trouble is it's completely impractical with current tools; we need
> tighter integration between md and LVM. Basically, we need a new type
> of VG; you'd only be able to make it out of PVs that are the same size
> (or close). Then, when you create an LV you decide what kind of
> redundancy you want; the LVM internally creates multiple LVs and raids
> them together to make the LV the fs sees.

In theory LVM is meant to handle the raid bits as well, once the mirror 
target is improved to properly handle error correction, and the raid5 
target stabilizes.  Thus md won't be needed, you will just need an 
interface between the filesystem and lvm.

> This could, sort of, be done in userspace, but I think it'll work
> better if dm and md are better integrated in the kernel. I thought i'd
> throw out my ideas before I get too far in. Thoughts?

This is the kind of thing that should go in userspace.  The filesystem 
should just fire off events that tell a userspace daemon things like 
"the raid5 volume is now at x% use" and let it choose the policy, 
possibly by asking lvm to resize the underlying volume, then sending a 
message back to the fs that the volume has been resized, and it can 
start using the extra space.

