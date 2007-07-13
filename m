Return-Path: <linux-kernel-owner+w=401wt.eu-S1763208AbXGMTsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763208AbXGMTsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbXGMTsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:48:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48507 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592AbXGMTsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:48:03 -0400
Message-ID: <4697D6EB.5020404@zytor.com>
Date: Fri, 13 Jul 2007 12:47:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Bodo Eggert <7eggert@gmx.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3][try 1] init: enable system-on-initramfs
References: <Pine.LNX.4.58.0707132039080.3222@be1.lrz>
In-Reply-To: <Pine.LNX.4.58.0707132039080.3222@be1.lrz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> I toyed with setting up a diskless system in initramfs. In the process, I
> came across some things:
> 
> 1)  There is no way to have the kernel not mount a filesystem,
>     unless you use /init or rdinit=.

And?  Just use rdinit=/sbin/init and no patch is needed.

> 2a) I figured if you prepared the root fs to contain a running system, you
>     woud probably also set up a runnable system on it. Therefore I changed
>     the default to boot from tmpfs if there was no /init nor a root= option.
>     (If there is a /init, it will be executed as usural.)
> 
>     Unfortunately the way I do it, this will override the rdev setting, but
>     that should be OK, since rdev is dead. Isn't it?

That's pretty hideous.  There shouldn't be a need for doing that.

rdev, unfortunately, isn't dead -- it lives on in the form of
/proc/sys/kernel/real-root-dev, as I found out doing the klibc set.

	-hpa
