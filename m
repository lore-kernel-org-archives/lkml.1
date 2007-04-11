Return-Path: <linux-kernel-owner+w=401wt.eu-S1751677AbXDKJ0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbXDKJ0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 05:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbXDKJ0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 05:26:49 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:31860 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbXDKJ0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 05:26:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=QYp9Ce6LSS9eH+M+bWw/ZLsesLk8W38JNA6rVCN25MprlwuXDI6S2uheZBAmfqiug62P5NXLBnI+8D6dh66lfEC1Yogn+U6c8LExw3ScjDmwZigvPU6KeAKi7zykz7lvLc0O/2IA+YsfLVZz0mEjrwAdxYfIwhRPxyJD9gWUBKg=
Message-ID: <461CA9D2.7020501@gmail.com>
Date: Wed, 11 Apr 2007 18:26:42 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: gregkh@suse.de, maneesh@in.ibm.com, dmitry.torokhov@gmail.com,
       oneukum@suse.de, rpurdie@rpsys.net, James.Bottomley@SteelEye.com,
       stern@rowland.harvard.edu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 12/14 UPDATED] sysfs: implement sysfs_dirent active reference
 and immediate disconnect
References: <11760923261269-git-send-email-htejun@gmail.com>	<11760923292724-git-send-email-htejun@gmail.com>	<20070411041515.GA10619@htj.dyndns.org> <20070411110006.1007b209@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070411110006.1007b209@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Cornelia Huck wrote:
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.21-rc6-ge666c753-dirty #54
> -------------------------------------------------------
> kslowcrw/64 is trying to acquire lock:
>  (&sch->reg_mutex){--..}, at: [<00000000004233b2>] mutex_lock+0x3e/0x4c
> 
> but task is already holding lock:
>  (&sd->s_active){----}, at: [<0000000000209578>] remove_dir+0xec/0x144
> 
> which lock already depends on the new lock.

This is probably because s_active has different write locked and
unlocked by different threads but it doesn't tell lockdep about it.
I'll read lockdep docs and update it.

Thanks for testing.

-- 
tejun
