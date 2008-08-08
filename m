Return-Path: <linux-kernel-owner+w=401wt.eu-S1757172AbYHHCZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbYHHCZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 22:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbYHHCZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 22:25:20 -0400
Received: from zen.handcraftedcomputers.com.au ([203.122.247.90]:2345 "EHLO
	zen.handcraftedcomputers.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753651AbYHHCZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 22:25:19 -0400
Message-ID: <489BAE70.5080909@handcraftedcomputers.com.au>
Date: Fri, 08 Aug 2008 11:54:48 +0930
From: Daryl Tester <dt-lkml@handcraftedcomputers.com.au>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Sven Wegener <sven.wegener@stealer.net>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM?: "permission denied" when accessing /proc/self/fd/*
 after setuid
References: <489A9357.50105@handcraftedcomputers.com.au> <alpine.LNX.1.10.0808071311300.16201@titan.stealer.net> <489B957D.9080206@handcraftedcomputers.com.au> <20080808005049.GA20707@martell.zuzino.mipt.ru>
In-Reply-To: <20080808005049.GA20707@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:

> Something similar was fixed in 2.6.22, but let me check.

You're right - from <http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.22>:

commit 8948e11f450e6189a79e47d6051c3d5a0b98e3f3
Author: Alexey Dobriyan <adobriyan@openvz.org>
Date:   Tue May 8 00:23:35 2007 -0700

    Allow access to /proc/$PID/fd after setuid()

    /proc/$PID/fd has r-x------ permissions, so if process does setuid(), it
    will not be able to access /proc/*/fd/. This breaks fstatat() emulation
    in glibc.

    open("foo", O_RDONLY|O_DIRECTORY)       = 4
    setuid32(65534)                         = 0
    stat64("/proc/self/fd/4/bar", 0xbfafb298) = -1 EACCES (Permission denied)


However, one of the kernels I tried this on (and failed) was a 2.6.24-19 -
is it possible this patch was backed out?

Cheers,
  --dt

