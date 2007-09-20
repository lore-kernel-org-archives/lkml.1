Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbXITJoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbXITJoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 05:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbXITJoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 05:44:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:52870 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbXITJoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 05:44:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=BU4JMI1obl2IRdNJDbF/j8Xw1vf+lQ+y5SjJWoowqVnXmDgVNusITKJaZzu7SoRLvA8YuOXj8COPsv0D1M0HB2WEBWZQJ4I1ECSn2uniGujykQjTTxgSkx13i6pYPWEOiq6GigxSTaQiUMtcF0CguQSI9VsdYEpQz7GTH/3MisA=
Message-ID: <46F240DF.7050303@gmail.com>
Date: Thu, 20 Sep 2007 18:43:59 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: ebiederm@xmission.com, greg@kroah.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCH 4/4] sysfs: make suicidal nodes just do it directly
References: <11902731752407-git-send-email-htejun@gmail.com>	<11902731751771-git-send-email-htejun@gmail.com> <20070920112440.6216644b@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070920112440.6216644b@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Thu, 20 Sep 2007 16:26:15 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> Sysfs now allows direct suicide.  Make suicidial sysfs nodes to use
>> it and remove now unncessary callback mechanism.
>>
>> Signed-off-by: Tejun Heo <htejun@gmail.com>
>> ---
>>  drivers/base/core.c         |   33 ----------------------
>>  drivers/s390/cio/ccwgroup.c |   25 +++-------------
>>  drivers/scsi/scsi_sysfs.c   |   13 +--------
>>  fs/sysfs/file.c             |   63 -------------------------------------------
>>  include/linux/device.h      |    6 ----
>>  include/linux/sysfs.h       |    9 ------
>>  6 files changed, 6 insertions(+), 143 deletions(-)
>>
> 
> Just browsing through this (I'll review and do some tests later), but
> you missed drivers/s390/cio/device.c::ccw_device_remove_disconnected().
> 
> Following (not event compile tested) patch (which is basically a revert
> of 59a8a6e227cf0bc42e5be741ebfea97c222ab9ef) should take care of it.
> 
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

Thanks for spotting this.  After converting ccwgroup, I thought that was
it for s390.

-- 
tejun
