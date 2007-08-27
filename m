Return-Path: <linux-kernel-owner+w=401wt.eu-S1761314AbXH0WUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314AbXH0WUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 18:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbXH0WUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 18:20:38 -0400
Received: from mail0.lsil.com ([147.145.40.20]:62442 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbXH0WUg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 18:20:36 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] mptsas: scan the logical volume at first
Date: Mon, 27 Aug 2007 16:20:16 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D709409BA@NAMAIL4.ad.lsil.com>
In-Reply-To: <200708271058.01919.yinghai.lu@sun.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] mptsas: scan the logical volume at first
Thread-Index: Acfo0t2nHssrHEqdQee7X+gJSbO+HAAJL0YQ
From: "Moore, Eric" <Eric.Moore@lsi.com>
To: "Yinghai Lu" <Yinghai.Lu@Sun.COM>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Prakash, Sathya" <Sathya.Prakash@lsi.com>,
       "James Bottomley" <James.Bottomley@steeleye.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <mpt_linux_developer@lsi.com>, <linux-scsi@vger.kernel.org>
X-OriginalArrivalTime: 27 Aug 2007 22:20:17.0141 (UTC) FILETIME=[725A6A50:01C7E8F8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 27, 2007 11:58 AM,  Yinghai Lu wrote:
> 
> [PATCH] mptsas: scan the logical volume at first
> 
> user like to see the raid show as /dev/sda before left raw disks.
> So scan the volume at first to make their life easier.
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> 

Although I agree with the patch, there are people on this list that will
reject it due to the fact distro's ship today having udev label and
device id mapping, so device ordering should be an non-issue.  However
there are systems that ship that don't have BIOS BBS support, allowing
you to select the boot device. Without it BBS support, you are forced to
boot to the lowest device id.  There are HP and Dell systems like that.
Are SUN systems like that?   If so, there is an additional patch which I
have yet posted that will sort the raid volumes in acsending order.
Currently they are in descending order (due to Firmware putting them in
that order), which if you did a install to what you think is /dev/sda,
its really the highest target id, and when you reboot, the BIOS will
boot to the lowest id, which is /dev/sdb, and it will not find the boot
partition.

Eric
