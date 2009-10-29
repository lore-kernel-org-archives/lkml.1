Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbZJ2Fle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbZJ2Fle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 01:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbZJ2Fle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 01:41:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50388
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754068AbZJ2Fld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 01:41:33 -0400
Date: Wed, 28 Oct 2009 22:41:57 -0700 (PDT)
Message-Id: <20091028.224157.92041844.davem@davemloft.net>
To: arndbergmann@googlemail.com
Cc: airlied@linux.ie, dri-devel@lists.sourceforge.net, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com
Subject: Re: is avoiding compat ioctls possible?
From: David Miller <davem@davemloft.net>
In-Reply-To: <200910281640.18491.arnd@arndb.de>
References: <200910281313.32827.arnd@arndb.de>
	<20091028.051631.212225494.davem@davemloft.net>
	<200910281640.18491.arnd@arndb.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arndbergmann@googlemail.com>
Date: Wed, 28 Oct 2009 16:40:18 +0100

> I'm pretty sure it was ok when we started adding the compat_ioctl
> handlers years ago. I think most people just ignored these for
> the majority of drivers that can't possibly run on s390. Even
> on s390, gcc will always do the right thing if you call call ioctl
> with a pointer to a normal object in the .data section, heap or stack,
> but hand-written assembly or other compilers may not.

Arnd, even compat_sys_ioctl() itself has constructs like:

	case FS_IOC_RESVSP:
	case FS_IOC_RESVSP64:
		error = ioctl_preallocate(filp, (void __user *)arg);
		goto out_fput;

That's why I asked about the 'arg' argument to sys_ioctl
on s390 :-)
