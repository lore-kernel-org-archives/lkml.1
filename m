Return-Path: <linux-kernel-owner+w=401wt.eu-S936900AbXGMWh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936900AbXGMWh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 18:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933120AbXGMWhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 18:37:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:59031 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387AbXGMWhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 18:37:47 -0400
Date: Sat, 14 Jul 2007 00:37:27 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3][try 1] init: enable system-on-initramfs
In-Reply-To: <4697D6EB.5020404@zytor.com>
Message-ID: <Pine.LNX.4.58.0707132344140.13842@be1.lrz>
References: <Pine.LNX.4.58.0707132039080.3222@be1.lrz> <4697D6EB.5020404@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19ux845j04VkOuGHWF7UHvF+eAYhccudxJltmo
 QxzwlnKJx+yjZw+f9e9dnpQ8xynPYH6RKUEDmK8KHQ4NqS7pFb
 uBUImhkgP4XJWH14utZEw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007, H. Peter Anvin wrote:
> Bodo Eggert wrote:

> > I toyed with setting up a diskless system in initramfs. In the process, I
> > came across some things:
> > 
> > 1)  There is no way to have the kernel not mount a filesystem,
> >     unless you use /init or rdinit=.
> 
> And?  Just use rdinit=/sbin/init and no patch is needed.

rdinit is supposed to do a different job from /sbin/init, therefore it
will not do the security callbacks the original code would do.

And besides that, it feels like turning the wrong knob for that task.

> > 2a) I figured if you prepared the root fs to contain a running system, you
> >     woud probably also set up a runnable system on it. Therefore I changed
> >     the default to boot from tmpfs if there was no /init nor a root= option.
> >     (If there is a /init, it will be executed as usural.)
> > 
> >     Unfortunately the way I do it, this will override the rdev setting, but
> >     that should be OK, since rdev is dead. Isn't it?
> 
> That's pretty hideous.  There shouldn't be a need for doing that.
> 
> rdev, unfortunately, isn't dead -- it lives on in the form of
> /proc/sys/kernel/real-root-dev, as I found out doing the klibc set.

It just missed it's own funeral:
"Obsolete root change mechanism
 ------------------------------

 The following mechanism was used before the introduction of pivot_root.
 Current kernels still support it, but you should _not_ rely on its
 continued availability." (Documentation/initrd.txt)


I don't insist on changing the default, it was just a logical step from 
preparing initramfs to hold a system.

-- 
Top 100 things you don't want the sysadmin to say:
48. Tell me again what that '-r' option to rm does
