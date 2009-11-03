Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbZKCGmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbZKCGmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 01:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZKCGmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 01:42:37 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:54280 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbZKCGmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 01:42:36 -0500
From: "Dasgupta, Romit" <romit@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Tue, 3 Nov 2009 12:12:07 +0530
Subject: RE: [PATCH 1/1] PM: Making bdi threads non-freezable
Thread-Topic: [PATCH 1/1] PM: Making bdi threads non-freezable
Thread-Index: Acpb7DeOqt9uHO/fRwa6uutit1KcVwAY223A
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59301DE1EC179@dbde02.ent.ti.com>
References: <B85A65D85D7EB246BE421B3FB0FBB59301DE1EBC66@dbde02.ent.ti.com>
 <200911021943.49943.rjw@sisk.pl>
In-Reply-To: <200911021943.49943.rjw@sisk.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: Re: [PATCH 1/1] PM: Making bdi threads non-freezable
> 
> On Monday 02 November 2009, Dasgupta, Romit wrote:
> > Fixes the case when bdi threads are in the refrigerator but file system sync
> > can happen after this. This is possible in MMC when
> CONFIG_MMC_UNSAFE_RESUME is
> > not set.
> 
> What's going to happen if we attemt to suspend the underlying block device(s)
> when the bdi thread are doing their job?  Is there any synchronisation
> mechanism for that?
> 
There is no explicit synchronization AFAICT. However, it looks like the call to 'del_gendisk' would invoke 'sync_filesystem' down the line. 'sync_filesystem' would end with synchronous writes of inodes followed by a call to '__sync_blockddev'. 
After this call I believe there should not be any activity pending for the blockdevice. So this should not lead to any race. My tests on the development board did not show any issues. But some FS experts may comment.

Regards,
-Romit

