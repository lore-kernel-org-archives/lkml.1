Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab0CIDLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 22:11:41 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:34671 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab0CIDLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 22:11:36 -0500
To: Tejun Heo <tj@kernel.org>
Cc: Karel Zak <kzak@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       "linux-ide\@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, Jim Meyering <jim@meyering.net>
Subject: Re: ATA 4 KiB sector issues.
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net>
	<20100308195847.GC18077@nb.net.home> <4B95B39C.70402@kernel.org>
Date: Mon, 08 Mar 2010 22:09:05 -0500
In-Reply-To: <4B95B39C.70402@kernel.org> (Tejun Heo's message of "Tue, 09 Mar
	2010 11:34:04 +0900")
Message-ID: <yq1mxyi8a3y.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B95BC1C.0004:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Tejun" == Tejun Heo <tj@kernel.org> writes:

>>> Huh, what?  My homedir is on a 4KiB LBS/PBS drive and has been for
>>> ~2 years.

Tejun> By default, they aren't aligned properly, are they?

Single partition.  I did the alignment manually.


Tejun> libata is broken for logical 4KiB ATA devices tho.  I'll fix it
Tejun> up.

Matthew implemented support for this a while back...


Tejun> I'm just a bit worried that it might generate a lot of frustrated
Tejun> bug reports.  Well, maybe we should just advise users to install
Tejun> windows first and then install Linux.

Unfortunately there is no simple solution given that we can't go back in
time and fix legacy DOS/XP behavior.

The 1-alignment jumper (that some drives have) fixes things for the
first partition but will mess up our alignment for subsequent ones
unless the firmware actually reports the shift.  So no matter what we do
the user will have to have a bare minimum of knowledge about 512-byte
LBS/4 KB PBS drives.  That sucks.  But even Windows users are presented
with extra documentation and alignment utilities during the transition.

Having a 1 MB alignment by default and hoping that devices that lie will
be 0-aligned is the best we can do, I think.

-- 
Martin K. Petersen	Oracle Linux Engineering
