Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbZCENoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbZCENoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756567AbZCENk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:40:29 -0500
Received: from smtp.nokia.com ([192.100.105.134]:53054 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135AbZCENk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:40:27 -0500
Message-ID: <49AFD5EA.5010502@nokia.com>
Date: Thu, 05 Mar 2009 15:38:50 +0200
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Rohit Hagargundgi <h.rohit@samsung.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       "Bityutskiy Artem (Nokia-M/Helsinki)" <Artem.Bityutskiy@nokia.com>
Subject: Re: [PATCH 1/3] [MTD] Flex-OneNAND support
References: <20090303063605.GA30258@july>	<20090303124948.dda294e5.akpm@linux-foundation.org>	<49AE6907.1080702@nokia.com> <20090304085055.c9de6cbb.akpm@linux-foundation.org>
In-Reply-To: <20090304085055.c9de6cbb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2009 13:38:35.0395 (UTC) FILETIME=[AEBC0530:01C99D97]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>>> +	return mtd->ecc_stats.corrected - stats.corrected ? -EUCLEAN : 0;
>>>> +}
>>> I wonder what the heck EUCLEAN was invented for and whether MTD's
>>> extensive use of it is appropriate.
>> UBI uses it to detect bit-flips so that data can be moved before it
>> can no longer be read.  So it is pretty much essential for flash
>> memories.
> 
> That's not the point.
> 
> My point is: for what purpose was EUNCLEAN created by whoever created
> it and, given that, is its use by MTD appropriate?  Because it does
> appear that this gets returned all the way to userspace sometimes.

I have had a look at the use of EUCLEAN and found the following:
	1. It does not seem to be defined in POSIX
	2. It may have been used by unix variants to indicate an
attempt to mount a file system whose superblock was not marked
as clean.
	3. In Linux, it is used almost exclusively by MTD, with
one exception in smbfs, from which it is tempting to conclude that
smbfs (at least) is using it incorrectly.  There is one web page
http://www.wlug.org.nz/EUCLEAN where the author suggests ENOMEDIUM
might be a better choice.

Can you point me to where EUCLEAN is returned to userspace?  I took
a quick look and couldn't see it.

