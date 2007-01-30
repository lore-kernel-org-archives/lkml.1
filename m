Return-Path: <linux-kernel-owner+w=401wt.eu-S965302AbXA3AlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965302AbXA3AlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 19:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965261AbXA3AlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 19:41:08 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:61815 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965251AbXA3AlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 19:41:06 -0500
Date: Mon, 29 Jan 2007 18:33:22 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH RFC] sd: spin down disks on removal or power-down
In-reply-to: <1170116201.3378.29.camel@mulgrave.il.steeleye.com>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, htejun@gmail.com
Message-id: <45BE9252.3040108@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <45BD522F.3070706@shaw.ca> <20070129154706.dfb3edab.akpm@osdl.org>
 <1170116201.3378.29.camel@mulgrave.il.steeleye.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Mon, 2007-01-29 at 15:47 -0800, Andrew Morton wrote:
>> What we don't want to happen is for those disks to spin down during a
>> reboot.
>> It seems that this is OK with this patch.
>>
>> Also, we probably don't want them to be spun down during a kexec_load,
>> but
>> I expect that's OK too.
> 
> Actually, there's another case where we don't want to do spin down, and
> that's when we don't own the disc (think external array on a SAN).
> Telling this has always been the biggest stumbling block to spin down of
> SCSI devices.
> 
> There's a patch similar to yours which takes this into account, which is
> currently under discussion:
> 
> http://marc.theaimsgroup.com/?t=116922621200002

It looks like Tejun's patch essentially does the same thing as mine with 
the addition of the control from userspace. There is one exception 
though, my patch also does the stop on removal of the SCSI disk (i.e. 
writing 1 to its "delete" file in sysfs, what scsiadd -r does). I think 
it makes sense if the user selected the disk to be spun down on shutdown 
to do it on removal as well, as it is potentially about to be physically 
removed/powered down (especially for USB or FireWire disks).

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

