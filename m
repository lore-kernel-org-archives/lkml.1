Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab0CILjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 06:39:06 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:42171 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592Ab0CILi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 06:38:59 -0500
Message-ID: <4B963351.50707@msgid.tls.msk.ru>
Date: Tue, 09 Mar 2010 14:38:57 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Karel Zak <kzak@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, Jim Meyering <jim@meyering.net>,
       Neil Brown <neilb@suse.de>
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net> <170fa0d21003081134g491034e5v4aad4d43853e48ec@mail.gmail.com> <4B95F071.3070400@msgid.tls.msk.ru> <20100309100153.GD18077@nb.net.home> <4B961FE1.5040105@msgid.tls.msk.ru> <20100309111523.GL28189@discord.disaster>
In-Reply-To: <20100309111523.GL28189@discord.disaster>
X-Enigmail-Version: 0.95.0
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> On Tue, Mar 09, 2010 at 01:16:01PM +0300, Michael Tokarev wrote:
>> Karel Zak wrote:
>>> I did almost all my tests with scsi_debug or MD RAID0 on scsi_debug.
>>> It works as expected.
>> Actually, for raid0, the alignment is questionable.  Should it be a
>> multiple of chunk size or whole stripe size?  I'm not sure, both ways
>> has bad and good sides..  But if it is the latter, the same issues
>> pops up again: do a 3-disk raid0 and you'll have to align to 3*2^N.
> 
> Yes, alignment is still needed, especially for filesystems that can
> do stripe unit aligned allocation like XFS. If you don't align the
> filesystem properly, all the data IO will be mis-aligned to the
> underlying disks and stripe unit sized IO will hit multiple disks
> rather than just one....

I understand alignment is needed, the question is if the alignment
should be to chunk size or full-stripe size.  In neither case it
will be bad for underlying disks.

/mjt
