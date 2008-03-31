Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbYCaHMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbYCaHMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 03:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbYCaHMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 03:12:40 -0400
Received: from sacred.ru ([62.205.161.221]:50408 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbYCaHMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 03:12:39 -0400
Message-ID: <47F08ED6.1090103@openvz.org>
Date: Mon, 31 Mar 2008 11:12:22 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC, PATCH] fix SEM_UNDO with namespaces
References: <47EFFD1C.5020204@colorfullife.com>
In-Reply-To: <47EFFD1C.5020204@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 31 Mar 2008 11:12:15 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manfred Spraul wrote:
> Hi,
> 
> the attached patch should fix the combination of CLONE_NEWIPC with 
> shared sysv undo structures (the common case, just 
> sys_unshare(CLONE_NEWIPC)):
> lookup_undo() now locates the undo array based on both semid and the 
> namespace pointer.

If you start using any IPC object and then call unshare with CLONE_NEWIPC,
then it's your problem, but not the kernel. There are many issues that can
become broken from the user-level POV.

What's the problem with undo list? Does it become irrelevant and no undos
happen after the task dies?

I agree, that we should probably destroy this one when the task calls 
unshare, but trying to keep this list relevant is useless.

> Additionally, the patch tries to clean the code up by using the linked 
> list macros from <linux/list.h> instead of single linked lists.

May I ask you to split the patch into atomic parts, rather than
mixing fixes, reworks and cleanups together?

> The patch passes a few quick tests, I'm interested in feedback. Are 
> there test apps for testing the IPC namespace code?

This code is a part of OpenVZ kernels, so it passes some internal
tests we perform.

> --
>     Manfred
> 

Thanks,
Pavel
