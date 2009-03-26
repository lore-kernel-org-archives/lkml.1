Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbZCZFYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbZCZFYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 01:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbZCZFYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 01:24:35 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:58028 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbZCZFYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 01:24:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=uQpsZRWlSoDlw1G6ClSlxYiD2hcbxzYCQKDFQmWuek3TQIyggEF4PhQAH5abdJbAdz
         wlT7bRjxVYE5nFPQj85dr0C6heUYdR9kO3Bsm/8F/tZ8MaO2aS8svlglwtkNMeUzFNeL
         qV2lqGtVV+kcAzrS9FxQJ9rDsKR3DWQf4Bz3A=
Message-ID: <49CB118B.7080501@gmail.com>
Date: Thu, 26 Mar 2009 14:24:27 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: greg@kroah.com, cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] sysfs: care-free suicide for sysfs files
References: <20090325035707.15921.42150.stgit@bob.kio> <20090325041702.15921.59355.stgit@bob.kio>
In-Reply-To: <20090325041702.15921.59355.stgit@bob.kio>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Alex Chiang wrote:
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index 39320a5..993edd1 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -583,6 +583,8 @@ void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
>  		sd->s_sibling = NULL;
>  
>  		sysfs_drop_dentry(sd);
> +		if (sysfs_type(sd) == SYSFS_KOBJ_ATTR)
> +			sysfs_file_check_suicide(sd);
>  		sysfs_deactivate(sd);
>  		sysfs_put(sd);
>  	}

I think there's a hole here.  sysfs_file_check_suicide() should be
done inside sysfs_deactivate() such that commiting suicide atomically
deactivates the sd.  This will solve the multiple writes to suicide
node problem nicely.

Thanks.

-- 
tejun
