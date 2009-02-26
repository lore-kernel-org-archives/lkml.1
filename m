Return-Path: <linux-kernel-owner+w=401wt.eu-S1764073AbZBZAGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764073AbZBZAGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 19:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762671AbZBZAFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:05:15 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:40377 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759977AbZBZAFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:05:12 -0500
To: david@lang.hm
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <matthew@wil.cx>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>
	<49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net>
	<alpine.DEB.1.10.0902251549180.26625@asgard.lang.hm>
Date: Wed, 25 Feb 2009 19:04:41 -0500
In-Reply-To: <alpine.DEB.1.10.0902251549180.26625@asgard.lang.hm> (david@lang.hm's message of "Wed\, 25 Feb 2009 15\:49\:58 -0800 \(PST\)")
Message-ID: <yq1wsbegj1i.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.49A5DC9E.0159:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "david" == david  <david@lang.hm> writes:

>> 512-byte logical / 512-byte hardware (current) 512-byte logical /
>> 4096-byte hardware (ATA, doing read-modify-write) 4096-byte logical /
>> 4096-byte hardware (SCSI initially, ATA later)

david> add to this good support for SSDs

david> ?? logical / 128K hardware

david> or similar.

Yep.  And that goes for RAID arrays too.

For SCSI there some knobs we can query to get this information and my
alignment changes are using those (and they are in turn what Willy's
stuff hooks into).

I've been lobbying the SSD vendors whose architecture is prone to
misalignment problems to propose a similar set of knobs for ATA.  But so
far it's just been a lot of talking.

My topology changes are a bit abstract in the sense that they expose:

 - smallest I/O you can submit without incurring a penalty (hw sector,
   raid chunk size)

 - optimal I/O size for the device in question

 - biggest I/O you can submit without incurring a penalty

 - alignment

We can use these parameters to lay out partitions and filesystems
optimally.  Just like we currently do with XFS but implemented in a more
generic way that all filesystems can use.

-- 
Martin K. Petersen	Oracle Linux Engineering
