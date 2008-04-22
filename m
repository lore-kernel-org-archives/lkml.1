Return-Path: <linux-kernel-owner+w=401wt.eu-S1762652AbYDVR0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762652AbYDVR0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757886AbYDVRZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:25:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756832AbYDVRZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:25:48 -0400
Date: Tue, 22 Apr 2008 10:25:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Broken] PCI: clean up resource alignment management
In-Reply-To: <b6a2187b0804220943l26f7b441sb5a7309dff0e84dc@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0804221020470.2779@woody.linux-foundation.org>
References: <b6a2187b0804220943l26f7b441sb5a7309dff0e84dc@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Apr 2008, Jeff Chua wrote:
> 
> I'm having problem loading pccard (Sony PC300 broadband card) with the
> recent git download, and bisected down to this commit.
> 
> commit 884525655d07fdee9245716b998ecdc45cdd8007
> Author: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Date:   Sun Mar 30 19:50:14 2008 +0400
> 
>     PCI: clean up resource alignment management

Ok, at worst we'll have to revert it, but before doing that, can you set 
up a bugzilla entry with a before-and-after version of "lspci -vv", full 
dmesg, and the output of /proc/iomem and /proc/ioports?

> The symptom that I'm seeing is ...
> 
> yenta_cardbus 0000:15:00.0: device not available because of BAR 7 [100:1ff] collisions
> yenta_cardbus: probe of 0000:15:00.0 failed with error -16

I suspect there wasn't a _real_ collision there, but the allocation failed 
because of the alignment bits not being set up right for cardbus bridges, 
but I'm not seeing the bug right now.

Ivan?

			Linus
