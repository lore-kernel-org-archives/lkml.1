Return-Path: <linux-kernel-owner+w=401wt.eu-S1758545AbZBZDGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545AbZBZDGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 22:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZBZDGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 22:06:40 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:38106 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbZBZDGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 22:06:38 -0500
To: Theodore Tso <tytso@mit.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <matthew@wil.cx>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>
	<49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net>
	<20090226025043.GJ1363@mit.edu>
Date: Wed, 25 Feb 2009 22:05:30 -0500
In-Reply-To: <20090226025043.GJ1363@mit.edu> (Theodore Tso's message of "Wed\, 25 Feb 2009 21\:50\:43 -0500")
Message-ID: <yq1r61lgao5.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.49A606FE.010D:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Ted" == Theodore Tso <tytso@mit.edu> writes:

>> Because of 63-sector legacy problems a bunch of ATA vendors will
>> initially ship 512/4096 drives that are not naturally aligned.
>> I.e. logical sector 63 will be aligned on a 4KB hardware sector
>> boundary to overcome the misaligned default partitioning.
>> 

Ted> Are we *sure* that this is what they plan to be doing?  

I have asked my contacts to verify.  That was the plan as of last
October.


Ted> Is there a way we can query the hardware to find out for sure what
Ted> drives are doing what?

Yep.  And with my patches the appropriate alignment is exposed in sysfs
for each block device.

Hardware workarounds for DOS partition table brain damage have existed
for a long time.  On a lot of RAID arrays you have to pick a LUN
personality.  And by choosing DOS/Windows/Linux you often align sector
63 to the internal RAID chunk size.

I'm working with several RAID vendors to make sure they set the right
alignment offset when they do that.  That isn't currently the case.  The
alignment knobs only recently made their appearance in the spec to
accommodate the 4KB sector transition.


Ted> I'll note that Vista starts all new partitions at the 1MB boundary,
Ted> so its filesystems will be naturally aligned.

Maybe.  See above.

-- 
Martin K. Petersen	Oracle Linux Engineering
