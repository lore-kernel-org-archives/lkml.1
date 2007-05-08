Return-Path: <linux-kernel-owner+w=401wt.eu-S966035AbXEHQuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966035AbXEHQuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 12:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965748AbXEHQuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 12:50:23 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:50846
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965656AbXEHQuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 12:50:22 -0400
Date: Tue, 8 May 2007 09:47:51 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
In-Reply-To: <20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.64.0705080943420.29403@asgard.lang.hm>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
 <20070508141149.GJ4226@stusta.de> <alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
 <20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Cornelia Huck wrote:

> 2. Sheer volume of devices on a bus. Even if the indivdual probing
> doesn't take long, having all devices probed one after the other may
> take a lot of time. Putting the actual probe on a thread makes it
> possible to run several probes in parallel, thereby cutting probing
> time.
>
> (FWIW, the s390 cio layer does asynchronous probing at the bus level,
> where work is usually outstanding for a lot of devices at once. Where a
> 2.4 kernel might take half an hour to detect all devices, we slashed it
> down to half a minute. I believe we could make rescans work even better
> with multithreaded probing with some tweaking.)
>
>> Threading at the bus level just inevitably means things like random
>> numbers for devices depending on some timing/scheduling issue. That's
>> nasty.
>>
>> Threading at a driver level still does that (ie individual disks may be
>> attached in some order that depends on how fast they are to respond), but
>> in a much more controlled fashion, and only for drivers that explicitly
>> say that they can do it.
>
> How is that better? You still must rely on udev for persistent device
> names. And controlling device names in the driver can still be done in
> the device driver with multithreaded probing (on s390 ccw, devices
> already pop up in a random order, and the dasd driver manages to
> conjure up consistent names for those devices that the user specified.)

I have used userspace tools for managing multiple machines that spawn 
tasks in parallel on multiple machines and then buffers them per-machine 
to display the output of the commands in order, no matter which one 
finished first.

for example 'dsh m1,m2 ls /' would always result in

m1 .
m1 ..
.
.
m2 .
m2 ..
.
.

even if m2 finished before m1

why can't the detection be done in parallel, but the regestration of 
detected devices be done in order?

David Lang
