Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab0CHSdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 13:33:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60493 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab0CHSdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 13:33:07 -0500
Message-ID: <4B954224.6010208@zytor.com>
Date: Mon, 08 Mar 2010 10:29:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, Karel Zak <kzak@redhat.com>,
       Jim Meyering <jim@meyering.net>
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1zl2ic058.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2010 07:18 AM, Martin K. Petersen wrote:
> 
> Tejun> Partitioners maybe should only align partitions which will be
> Tejun> used by Linux and default to the traditional layout for others
> Tejun> while allowing explicit override.
> 
> I don't think we take the partition type into account.  Karel?
> 

We should not take the partition type into account.  The other aspect is
that FAT partitions need to be formatted differently to maintain the
alignment once set; I have recently contributed patches (which were
accepted) into mkdosfs to do the right thing there.

Looking at the Windows XP article, it looks like it is limited to
certain BIOSes; unfortunately it doesn't say what the particular BIOS
issue is.  If we can find a system which actually exhibits the bug it
might be possible to reverse-engineer a solution.

> Tejun> Reportedly, commonly used partitioners aren't ready to handle
> Tejun> drives larger than 2 TiB in any configuration and alignment isn't
> Tejun> done properly for drives with 4 KiB physical sectors.  4 KiB
> Tejun> logical sector support is broken in both the kernel 
> 
> Huh, what?  My homedir is on a 4KiB LBS/PBS drive and has been for ~2
> years.

For > 2 TiB drives with 4 KiB logical sectors and MS-DOS partition
tables, it is.

> Tejun> Unfortunately, the transition to 4 KiB sector size, physical only
> Tejun> or logical too, is looking fairly ugly.  Hopefully, a reasonable
> Tejun> solution can be reached in not too distant future but even with
> Tejun> all the software side updated, it looks like it's gonna cause
> Tejun> significant amount of confusion and frustration.
> 
> With regards to XP compatibility I don't think we should go too much out
> of our way to accommodate it.  XP has been disowned by its master and I
> think virtualization will take care of the rest.

I think that's is wildly optimistic, but I do observe there is a fix
from Microsoft in the article you reference.

> FWIW, recent fdisk has a command line flag that will enable/disable DOS
> compatible layout.

Yes, unfortunately it is still on by default.

	-hpa
