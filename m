Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbZF1O5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbZF1O5k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 10:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbZF1O5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 10:57:25 -0400
Received: from emulex.emulex.com ([138.239.112.1]:52383 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbZF1O5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 10:57:23 -0400
Message-ID: <4A477F00.70305@emulex.com>
Date: Sun, 28 Jun 2009 10:32:32 -0400
From: James Smart <James.Smart@Emulex.Com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>, Olaf Hering <olh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Benny Halevy <bhalevy@panasas.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Smart, James" <James.Smart@Emulex.Com>
Subject: Re: [PATCH] SCSI: userspace cannot use scsi_command_size_tbl, COMMAND_SIZE
 and scsi_device_type
References: <1246122359.32198.7.camel@hpdv5.satnam> <4A47222B.5020702@panasas.com>
In-Reply-To: <4A47222B.5020702@panasas.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jun 2009 14:32:36.0180 (UTC) FILETIME=[47E5D140:01C9F7FD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry folks --  the nuance of the clibrary having it's own version of a 
kernel header for distros was completely unknown to me.

Christoph mentioned this to me last week, with the recommendation to 
back out the patch and move the other headers that were exprted into 
include/linux - thus nothing in include/scsi gets export.  No Problem. 
and I'll do so shortly.

How does a lowly contributor track these kind of nuances ?

-- james s



Boaz Harrosh wrote:
> On 06/27/2009 08:05 PM, Jaswinder Singh Rajput wrote:
>   
>> userspace cannot use scsi_command_size_tbl, COMMAND_SIZE
>> and scsi_device_type defined in kernel
>>
>> fix the following 'make headers_check' warnings:
>>
>>   usr/include/scsi/scsi.h:159: userspace cannot call function or variable defined in the kernel
>>   usr/include/scsi/scsi.h:285: userspace cannot call function or variable defined in the kernel
>>
>> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
>>     
>
> include/scsi/scsi.h was always provided by glibc and was never exported from Kernel.
> It was only recently added to include/scsi/Kbuild. (In this merge window, was never released)
> (see: [9e4f5e29] [SCSI] FC Pass Thru support)
>
> Two questions. 
> 1. Are we sure this will work. Is the Header fully compatible with glibc's header.
> 2. What will this do to distor's package managers having the same file in two packages?
>    Don't we need a followup patch sent to glibc to remove that Header from there?
>
> James Smart
>   What is the new definitions needed in user-mode in scsi.h that is not available in glibc's
> supplied header?
>
> (For reference see this patch from 2007: [e629a7dd] do not export /usr/include/scsi in make headers_install)
>
> Boaz
>   
