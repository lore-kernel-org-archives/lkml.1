Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbYE1OkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbYE1OkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 10:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbYE1OkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 10:40:07 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57595 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025AbYE1OkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 10:40:06 -0400
Subject: Re: [PATCH][-mm] reclassify sg_sysfs_class for lockdep
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: akpm@linux-foundation.org, greg@kroah.com, matthew@wil.cx,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <20080527101009.GA3015@darkstar.te-china.tietoenator.com>
References: <20080527101009.GA3015@darkstar.te-china.tietoenator.com>
Content-Type: text/plain
Date: Wed, 28 May 2008 09:40:00 -0500
Message-Id: <1211985600.3445.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-27 at 18:10 +0800, Dave Young wrote:
> As register sg_interface, the sg_add will be called, which then will
> add device to sg_sysfs_class. This will cause lockdep warning,
> please see following email
> 
> In this case the locks are from diffrent classi, one is sdev_class,
> another is sg_sysfs_class 
> 
> Here reclassify the sg_sysfs_class for lockdep

This isn't really a generic solution, is it?  It only works because we
currently only have two users of the interface functions, so if we
reclassify one they look separate to lockdep.  It will fall over again
if we ever get another one.

Surely the correct fix is to initialise lockdep for the mutex the same
way we did for the semaphore in class_register() (which does exactly the
same locking without triggering lockdep)?  That way we'll also fix the
problem for other conversions of semaphore->mutex.

James



