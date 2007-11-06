Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbXKFSt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbXKFSt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 13:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755243AbXKFSts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:49:48 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55188 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795AbXKFStr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:49:47 -0500
Message-ID: <4730B753.2000901@us.ibm.com>
Date: Tue, 06 Nov 2007 12:49:55 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Avi Kivity <avi@qumranet.com>, Dor Laor <dor.laor@qumranet.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Use of virtio device IDs
References: <4730A15A.6070001@us.ibm.com>
In-Reply-To: <4730A15A.6070001@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Hi Rusty,
>
> I've written a PCI virtio transport and noticed something strange.  
> All current in-tree virtio devices register ID tables that match a 
> specific device ID, but any vendor ID.
>
> This is incompatible with using PCI vendor/device IDs for virtio 
> vendor/device IDs since vendors control what device IDs mean.  A 
> simple solution would be to assign a fixed vendor ID to all current 
> virtio devices.  This doesn't solve the problem completely though 
> since you would create a conflict between the PCI vendor ID space and 
> the virtio vendor ID space.
>
> The only solutions seem to be virtualizing the virtio vendor/device 
> IDs (which is what I'm currently doing) or to mandate that the virtio 
> vendor ID be within the PCI vendor ID space.  It's probably not 
> necessary to make the same requirement for device IDs though.

There's another ugly bit in the current implementation.

Right now, we would have to have every PCI vendor/device ID pair in the 
virtio PCI driver ID table for every virtio device.

This means every time a virtio device is added to Linux, the virtio PCI 
driver has to be modified (assuming that each virtio device uses a 
unique PCI vendor/device ID) :-/

Regards,

Anthony Liguori

> What are your thoughts?
>
> Regards,
>
> Anthony Liguori
>

