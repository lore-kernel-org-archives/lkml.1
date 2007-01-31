Return-Path: <linux-kernel-owner+w=401wt.eu-S1161064AbXAaXtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161064AbXAaXtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 18:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161104AbXAaXtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 18:49:22 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:21373 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161022AbXAaXtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 18:49:20 -0500
Date: Wed, 31 Jan 2007 17:45:41 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH RFC] sd: spin down disks on removal or power-down
In-reply-to: <45C0FA3B.5030508@s5r6.in-berlin.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>,
       Andrew Morton <akpm@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, htejun@gmail.com
Message-id: <45C12A25.8080805@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <45BD522F.3070706@shaw.ca> <20070129154706.dfb3edab.akpm@osdl.org>
 <1170116201.3378.29.camel@mulgrave.il.steeleye.com> <45BE9252.3040108@shaw.ca>
 <45C0FA3B.5030508@s5r6.in-berlin.de>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Robert Hancock wrote:
>>> http://marc.theaimsgroup.com/?t=116922621200002
>> It looks like Tejun's patch essentially does the same thing as mine with
>> the addition of the control from userspace. There is one exception
>> though, my patch also does the stop on removal of the SCSI disk (i.e.
>> writing 1 to its "delete" file in sysfs, what scsiadd -r does).
> 
> Isn't sd_shutdown called at this occasion?

Ah, indeed it is. I was thinking of the way I had written my patch, 
where it only does the spindown if the system state is SYSTEM_POWER_OFF 
so I needed an extra call to force this on removal. Tejun's patch just 
checks for not SYSTEM_RESTART, so it should happen on removal as well.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

