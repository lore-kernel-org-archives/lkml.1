Return-Path: <linux-kernel-owner+w=401wt.eu-S1762896AbXEQFIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762896AbXEQFIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 01:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760350AbXEQFIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 01:08:11 -0400
Received: from 203-97-71-235.dsl.clear.net.nz ([203.97.71.235]:3841 "EHLO
	gazelle.ad.endace.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759769AbXEQFIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 01:08:10 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: Software raid0 will crash the file-system, when each disk is 5TB
Date: Thu, 17 May 2007 17:08:07 +1200
Message-ID: <659F626D666070439A4A5965CD6EBF406B3471@gazelle.ad.endace.com>
In-Reply-To: <17995.56011.742143.418388@notabene.brown>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Software raid0 will crash the file-system, when each disk is 5TB
Thread-Index: AceYPGvtHz1VoFOuRXean0ucGU8FiAAA2LaA
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com><6bffcb0e0705151629j78920ca2r9337dccdfc1bb6a9@mail.gmail.com><17994.19043.771733.453896@notabene.brown><659F626D666070439A4A5965CD6EBF406B31C5@gazelle.ad.endace.com><17995.42562.870806.396617@notabene.brown><659F626D666070439A4A5965CD6EBF406B33ED@gazelle.ad.endace.com><17995.49602.427417.500049@notabene.brown><659F626D666070439A4A5965CD6EBF406B3428@gazelle.ad.endace.com> <17995.56011.742143.418388@notabene.brown>
From: "Jeff Zheng" <Jeff.Zheng@endace.com>
To: "Neil Brown" <neilb@suse.de>
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>, <linux-raid@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> What is the nature of the corruption?  Is it data in a file 
> that is wrong when you read it back, or does the filesystem 
> metadata get corrupted?
The corruption is in fs metadata, jfs is completely destroied, after 
Umount, fsck does not recogonize it as jfs anymore. Xfs gives kernel 
Crash, but seems still recoverable.
> 
> Can you try the configuration that works, and sha1sum the 
> files after you have written them to make sure that they 
> really are correct?
We have verified the data on the working configuration, we have written 
around 900 identical 10G files , and verified that the md5sum is
actually
the same. The verification took two days though :)

> My thought here is "maybe there is a bad block on one device, 
> and the block is used for data in the 'working' config, and 
> for metadata in the 'broken' config.
> 
> Can you try a degraded raid10 configuration. e.g.
> 
>    mdadm -C /dev/md1 --level=10 --raid-disks=4 /dev/first missing \
>    /dev/second missing
> 
> That will lay out the data in exactly the same place as with 
> raid0, but will use totally different code paths to access 
> it.  If you still get a problem, then it isn't in the raid0 code.

I will try this later today. As I'm now trying different size of the
component.
3.4T, seems working. Test 4.1T right now.

> Maybe try version 1 metadata (mdadm --metadata=1).  I doubt 
> that would make a difference, but as I am grasping at straws 
> already, it may be a straw woth trying.

Well the problem may also be in 3ware disk array, or disk array driver.
The guy
complaining about the same problem is also using 3ware disk array
controller.
But there is no way to verify that and a single disk array has been
working fine for us.

Jeff
