Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab0CIDNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 22:13:47 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:20712 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab0CIDNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 22:13:42 -0500
To: Tejun Heo <htejun@gmail.com>
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
	<4B95B5AC.8050101@gmail.com>
Date: Mon, 08 Mar 2010 22:11:32 -0500
In-Reply-To: <4B95B5AC.8050101@gmail.com> (Tejun Heo's message of "Tue, 09 Mar
	2010 11:42:52 +0900")
Message-ID: <yq1iq9689zv.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B95BCA0.002B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Tejun" == Tejun Heo <htejun@gmail.com> writes:

>> This will result in incorrect alignment for drives which lie about
>> the physical sector size to work around BIOS/drivers issues (C-1).
>> It would probably be best to align to at least 1MiB.

Tejun> I misread it.  C-1 would be disks w/o alignment information which
Tejun> will be aligned to optimal_io_size which again would be 0 and
Tejun> thus 1MiB alignment.  So, this should work, right?

Correct.  ATA only provides physical block size whereas SCSI has the
extra knobs in the block limits VPD.  And consequently ATA block devices
have min_io = physical block size and optimal_io = 0.

So we'll align to 1 MB by default.

-- 
Martin K. Petersen	Oracle Linux Engineering
