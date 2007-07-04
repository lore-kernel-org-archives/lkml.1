Return-Path: <linux-kernel-owner+w=401wt.eu-S1759500AbXGDGiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500AbXGDGiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 02:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbXGDGh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 02:37:58 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:54218 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbXGDGh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 02:37:57 -0400
Message-ID: <468B3FDA.7060809@linux.vnet.ibm.com>
Date: Wed, 04 Jul 2007 12:06:10 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: cmm@us.ibm.com
CC: Kalpak Shah <kalpak@clusterfs.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [EXT4 set 3][PATCH 1/1] ext4 nanosecond timestamp
References: <1183275416.4010.125.camel@localhost.localdomain> <1183458506.4102.5.camel@garfield.linsyssoft.com> <1183519975.3922.7.camel@localhost.localdomain>
In-Reply-To: <1183519975.3922.7.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Mingming Cao wrote:
> On Tue, 2007-07-03 at 15:58 +0530, Kalpak Shah wrote:
>> On Sun, 2007-07-01 at 03:36 -0400, Mingming Cao wrote:
>>> +
>>> +#define EXT4_INODE_GET_XTIME(xtime, inode, raw_inode)			       \
>>> +do {									       \
>>> +	(inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);	       \
>>> +	if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))     \
>>> +		ext4_decode_extra_time(&(inode)->xtime,			       \
>>> +				       raw_inode->xtime ## _extra);	       \
>>> +} while (0)
>>> +
>>> +#define EXT4_EINODE_GET_XTIME(xtime, einode, raw_inode)			       \
>>> +do {									       \
>>> +	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))		       \
>>> +		(einode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);      \
>>> +	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))	       \
>>> +		ext4_decode_extra_time(&(einode)->xtime,		       \
>>> +				       raw_inode->xtime ## _extra);	       \
>>> +} while (0)
>>> +
>> This nanosecond patch seems to be missing the fix below which is required for http://bugzilla.kernel.org/show_bug.cgi?id=5079
>>
>> If the timestamp is set to before epoch i.e. a negative timestamp then the file may have its date set into the future on 64-bit systems. So when the timestamp is read it must be cast as signed.
> 
> Missed this one.
> Thanks. Will update ext4 patch queue tonight with this fix.
> 
>


IIRC in the conference call it was decided to not to apply this patch. Andreas may be able to update better.

-aneesh
