Return-Path: <linux-kernel-owner+w=401wt.eu-S1751779AbZK2NHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbZK2NHN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 08:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbZK2NHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 08:07:12 -0500
Received: from daytona.panasas.com ([67.152.220.89]:10222 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750956AbZK2NHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 08:07:11 -0500
Message-ID: <4B127202.1010900@panasas.com>
Date: Sun, 29 Nov 2009 15:07:14 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091125 Remi/fc10 Thunderbird/3.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       open-osd <osd-dev@open-osd.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: linux-next: manual merge of the osd tree with the scsi tree
References: <20091127143229.108298c6.sfr@canb.auug.org.au> <4B123A82.10104@panasas.com>
In-Reply-To: <4B123A82.10104@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Nov 2009 13:07:17.0361 (UTC) FILETIME=[E0758610:01CA70F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2009 11:10 AM, Boaz Harrosh wrote:
> On 11/27/2009 05:32 AM, Stephen Rothwell wrote:
>> Hi Boaz,
>>
>> Today's linux-next merge of the osd tree got a conflict in
>> drivers/scsi/osd/osd_uld.c between commit
>> f89b9ee4a722721ed205b8c29555ac75fbe8c2cc ("[SCSI] osduld: Use
>> device->release instead of internal kref") from the scsi tree and commit
>> 9b579fe8588b861dcf0c9b620757729643db4557 ("osduld: Use device->release
>> instead of internal kref") from the osd tree.
>>
>> These are slightly different versions of the same patch ...
>>
>> And commit 01e4c32c668251e74eb179ee1207c075466c4ef8 ("osduld: No need to
>> use dev_set_drvdata on embedded devices") from the osd also contributes
>> to the conflict.
>>
> 
> James has squashed these two patches together. Which do belong together
> I should say. In my tree they are separate. I will change my tree to
> match James's.
> 
> Thanks James, I prefer it much better this way.
> 

James hi.

In your merge of the patch:
    [SCSI] osduld: Use device->release instead of internal kref
at:
    [jejb: fold in use of container_of]

You have made a mistake, which renders the driver unusable.
At osd_remove() you changed the use of dev_get_drvdata to an, container_of()
but it is the *wrong* dev at this point this dev here is the grand-parent of
the embedded dev in question.

Also at the next patch:
    [SCSI] libosd: osd_dev_info: Unique Identification of an OSD device

a new use of dev_get_drvdata() is not converted to a container_of(), which by
now will return NULL.

Should I repost the correct two patches (my preference)? should I send in a fix to
current scsi-misc tree? or should I send two SQUASH-ME patches to the two bad commits
in your tree?

How do you want to proceed?

>> I fixed it up (the obvious way) and can carry the fix for a while.
> 

Stephan, I have not yet fixed up the conflict in -next, please carry that
fix you have for a little while, until we resolve it.

> Thanks
> Boaz

Boaz
