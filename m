Return-Path: <linux-kernel-owner+w=401wt.eu-S1756355AbZCPQ3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbZCPQ3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 12:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbZCPQ3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 12:29:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56296 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbZCPQ3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:29:01 -0400
Message-ID: <49BE7DEF.1060005@zytor.com>
Date: Mon, 16 Mar 2009 09:27:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Greg Freemyer <greg.freemyer@gmail.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Matthew Wilcox <matthew@wil.cx>, Theodore Tso <tytso@mit.edu>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>	 <49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net>	 <20090226025043.GJ1363@mit.edu>	 <20090226030735.GA16891@parisc-linux.org>	 <yq1eixlg4mn.fsf@sermon.lab.mkp.net> <49A6B604.1060702@zytor.com>	 <yq1iqmxey1o.fsf@sermon.lab.mkp.net> <49A70379.3050306@zytor.com> <87f94c370903160751t6de5ed2t40163a6590ba633@mail.gmail.com>
In-Reply-To: <87f94c370903160751t6de5ed2t40163a6590ba633@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Freemyer wrote:
> If the reported geometry of these drives was changed to have sectors /
> track be a multiple of 8, wouldn't that fix most of the issues.
> 
> ie. If the drive were to report 56 sectors per track, then a
> traditional partitioning tool would start the first partition as
> sector 56 and a Vista like partitioning tool would place the first
> partition at sector 2048.  Both would have the same 4K sector
> alignment.
> 
> If my logic is sound, anyway to get this recommendation upstream to
> hardware manufacturers.  It seems like an almost trivial change for
> them.
> 
> FYI: It sounds to me like partitioning tools should totally drop
> efforts to align with cylinders, instead they should start asking what
> the unit of atomic read/writes is at the physical layer and if any
> offsets are needed to align the partition with the atomic write areas.
> 
> That would fit better for both SSD technology and for this 4K sectors
> issue than trying to continue to support cylinders at all.

As long as BIOSes played along with it (which some of them may not do --
remember the geometry that matters is the one reported by the BIOS)
However, it definitely would be a major step in the right direction, as
it would let *most* systems Do The Right Thing instead of weirdly
misaligning the partitions and trying to cope with that.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

