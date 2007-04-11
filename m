Return-Path: <linux-kernel-owner+w=401wt.eu-S1030780AbXDKESq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030780AbXDKESq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 00:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030799AbXDKESq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 00:18:46 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:65164 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030780AbXDKESp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 00:18:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=LNE2B8erzKdHTyboTD5eUXsEuFi8CUqGQpT7Aiih4X5BmNwNl2ARg4AcnYcrqigYwAIs6CONugn3qlO6rLmsEFNhDdbCCk0/zSD+IlwCqn8QPNBHbyeu1x7o4mp8bOXk92a3jXiQ3olKnoSkvgQIruTnPrJ0gVXafMjwH9Hb9Vo=
Message-ID: <461C619E.5040705@gmail.com>
Date: Wed, 11 Apr 2007 13:18:38 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: gregkh@suse.de, maneesh@in.ibm.com, dmitry.torokhov@gmail.com,
       oneukum@suse.de, rpurdie@rpsys.net, James.Bottomley@SteelEye.com,
       stern@rowland.harvard.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET #master] sysfs: make sysfs disconnect immediately on
 deletion, take 2
References: <11760923261269-git-send-email-htejun@gmail.com> <20070410164416.63469474@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070410164416.63469474@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Mon, 9 Apr 2007 13:18:46 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> With all the patches applied, the same test used in the last take ran
>> 9+hrs without any problem.
> 
> I get the following on startup:
> 
> =====================================
> [ BUG: bad unlock balance detected! ]
> -------------------------------------
> start_udev/197 is trying to release lock (&sd->s_active) at:
> [<0000000000209024>] release_sysfs_dirent+0x8c/0x118
> but there are no more locks to release!

Thanks a lot for spotting this.  I thought I enabled lock debugging but
apparently, didn't.  Anyways, the bug doesn't affect actual behavior.
It's just doing up_write() on an unlocked rwsem which is about to be
freed.  I've just posted the updated version of patch 12 to fix this.

-- 
tejun
