Return-Path: <linux-kernel-owner+w=401wt.eu-S934563AbZJONBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934563AbZJONBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 09:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933129AbZJONBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 09:01:14 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:34813 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090AbZJONBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 09:01:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=nGgfBBoThJTPgHPkB/DwzUhOVEzegGyyI7+d9zWB5zo8MnUx5Z6hvOlzFPDhFbR0vC
         pVL70+IFC/bvljNq6KNH1oFjt65+0PS7jnHMtQuXVKocIO5Gu+agOsMn67+WLDg6tkG2
         S8647uaH3n2CaXY6I3GD8RBORj6p4bqPAOSWc=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 6/7] um: Convert mmapper to unlocked_ioctl
Date: Thu, 15 Oct 2009 15:00:34 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ALan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Dike <jdike@addtoit.com>
References: <20091015083906.716130653@linutronix.de> <20091015083933.997426614@linutronix.de>
In-Reply-To: <20091015083933.997426614@linutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200910151500.34820.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 October 2009, Thomas Gleixner wrote:
> The ioctl is empty and needs no serialization. We might remove it
> completely but that would change the return value from -ENOIOCTLCMD to
> -ENOTTY.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jeff Dike <jdike@addtoit.com>

This one is tricky if you want to get it right according to the
book. ENOIOCTLCMD is never a valid return code for user space,
but sys_ioctl passes it down anyway.

However, returning -ENOIOCTLCMD from an *unlocked_ioctl* function
automatically gets turned into -EINVAL. It does this to allow
the same functions to be used for unlocked_ioctl and compat_ioctl.
In effect, this patch is functionally identical to removing the
ioctl function, which I think is what should be done here.

	Arnd <><
