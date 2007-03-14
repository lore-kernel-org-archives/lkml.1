Return-Path: <linux-kernel-owner+w=401wt.eu-S1750808AbXCNP0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750808AbXCNP0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbXCNP02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:26:28 -0400
Received: from uhweb15152.united-hoster.com ([85.88.15.152]:44559 "EHLO
	uhweb15152.united-hoster.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbXCNP0S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:26:18 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Mar 2007 11:26:17 EDT
From: Frank Seidel <frank@kernalert.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 5/9] signalfd/timerfd v3 - signalfd compat code ...
Date: Wed, 14 Mar 2007 16:19:28 +0100
User-Agent: KMail/1.9.5
References: <send-serie.davidel@xmailserver.org.5031.1173654242.5>
In-Reply-To: <send-serie.davidel@xmailserver.org.5031.1173654242.5>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703141619.28505.frank@kernalert.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007 20:19:27 Davide Libenzi wrote:
Hi,
i'm not (at least until yet) really that familiar with the kernel, but 
currently trying to get into it also via reading of code and patches 
here. So please don't take my comments in this (and posibly following)
mails to serious. ;-)

> +asmlinkage long compat_sys_signalfd(int ufd,
> +                                 const compat_sigset_t __user 
*sigmask,
> +                                 compat_size_t sigsetsize)
> +{
> +     compat_sigset_t ss32;
> +     sigset_t tmp;
> +     sigset_t __user *ksigmask;
> +
Would it be good to put this in a

if (sigmask) {

like its e.g. done in compat_sys_epoll_pwait or would this be
totally useless here?

> +     if (sigsetsize != sizeof(compat_sigset_t))
> +             return -EINVAL;
> +     if (copy_from_user(&ss32, sigmask, sizeof(ss32)))
> +             return -EFAULT;
> ...

Have fun,
Frank
