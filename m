Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbYE2AqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbYE2AqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 20:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbYE2Apx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 20:45:53 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:42428 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777AbYE2App (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 20:45:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WTc5RoFdEZQnl9sI+01VR4j9rZhysFEUbM6xJMDleNvucY1AA2DTQoXP/ytRRpg1x1Xk+uJMAs82Pta805lsuVaiVMSiNh6Zwt7fHsnSyDwa1UZPVUxXsVxyjDfn+oDXgIbVxpWWdJw3Yf6YEwUpX0glyymo9e96qAtDxI/TYNg=
Message-ID: <a8e1da0805281745g31c8217fk860dfe17cc674be5@mail.gmail.com>
Date: Thu, 29 May 2008 08:45:43 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH][-mm] reclassify sg_sysfs_class for lockdep
Cc: akpm@linux-foundation.org, greg@kroah.com, matthew@wil.cx,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <1211985600.3445.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080527101009.GA3015@darkstar.te-china.tietoenator.com>
	 <1211985600.3445.14.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 10:40 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2008-05-27 at 18:10 +0800, Dave Young wrote:
>> As register sg_interface, the sg_add will be called, which then will
>> add device to sg_sysfs_class. This will cause lockdep warning,
>> please see following email
>>
>> In this case the locks are from diffrent classi, one is sdev_class,
>> another is sg_sysfs_class
>>
>> Here reclassify the sg_sysfs_class for lockdep
>
> This isn't really a generic solution, is it?  It only works because we
> currently only have two users of the interface functions, so if we
> reclassify one they look separate to lockdep.  It will fall over again
> if we ever get another one.
>
> Surely the correct fix is to initialise lockdep for the mutex the same
> way we did for the semaphore in class_register() (which does exactly the
> same locking without triggering lockdep)?  That way we'll also fix the
> problem for other conversions of semaphore->mutex.

Matthew & greg did the work already.

>From my original idea I don't want to do this for all classes, and I
would think it as a rare case.

Regards
dave
