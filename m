Return-Path: <linux-kernel-owner+w=401wt.eu-S932579AbXAYDYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbXAYDYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 22:24:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932566AbXAYDYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 22:24:04 -0500
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:41406 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932549AbXAYDYD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 22:24:03 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.0.6487.1
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch] scsi: use lock per host instead of per device forshared queue tag host
Date: Wed, 24 Jan 2007 19:25:11 -0800
Message-ID: <B70A50D07063384EB9BCE3330D18414F02F5AF9D@nonameb.ptu.promise.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] scsi: use lock per host instead of per device forshared queue tag host
Thread-Index: Acc/2TxkbUnpGckfQReqvrsqh7ZrvgAVtD1Q
From: "Ed Lin" <ed.lin@promise.com>
To: "James Bottomley" <James.Bottomley@SteelEye.com>
Cc: "linux-scsi" <linux-scsi@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>, "jeff" <jeff@garzik.org>,
       "Promise_Linux" <Promise_Linux@promise.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
> Sent: Wednesday, January 24, 2007 9:00 AM
> To: Ed Lin
> Cc: linux-scsi; linux-kernel; jeff; Promise_Linux
> Subject: Re: [patch] scsi: use lock per host instead of per 
> device forshared queue tag host
> 
...
> 
> This patch looks OK in principle.
> 
> However, are you sure you're not using a sledgehammer to crack a nut?
> If the only reason you're doing this is because of the shared tag map,
> then probably that should be the area you protect with a per-tag-map
> lock.   The net effect of what you've done will be to serialise all
> accesses to your storage devices.  For a small number of devices, this
> probably won't matter than much, but for large numbers of devices,
> you're probably going to introduce artificial performance 
> degredation in
> the I/O scheduler.
> 
> James
> 

Thanks.
Maybe this issue needs more discussion. I'll follow up.

Ed Lin
