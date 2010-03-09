Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab0CITJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:09:54 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:39766 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab0CITJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:09:51 -0500
Message-ID: <4B969C62.9030300@vflare.org>
Date: Wed, 10 Mar 2010 00:37:14 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Pekka Enberg <penberg@gmail.com>, andi@firstfloor.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ramzswap: Eliminate stale data in compressed memory
References: <d760cf2d1003050222m6e509ffaqa498645c52f7d98e@mail.gmail.com>
In-Reply-To: <d760cf2d1003050222m6e509ffaqa498645c52f7d98e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2010 03:52 PM, Nitin Gupta wrote:
> ramzswap driver creates RAM based block devices which can be
> used (only) as swap disks. Pages swapped to these disks are
> compressed and stored in memory itself.
> 
> However, these devices do not get any notification when a swap
> slot is freed (swap_map[i] reaches 0). So, we cannot free memory
> allocated corresponding to this swap slot. Such stale data can
> quickly accumulate in (compressed) memory defeating the whole
> purpose of such devices.
> 
> To overcome this problem, we now add a callback in 'struct swap_info_struct'
> which is called as soon as a swap slot is freed.
> 
> Adding handler for this callback:
> 	swapon notifier --> set_swap_free_notify(swap_type, fn)
> 
> Removing handler:
> 	swapoff notifier --> set_swap_free_notify(swap_type, NULL)
> 
> 
> Alternative approaches:
> 1) Add callback directly in 'struct block_device_operations' but
> that is considered too hacky.
> 2) Use swap discard mechanism: It involves unncessary overhead of
> allocating 'discard bio' requests and its too slow to serve ramzswap
> needs.
> 
>  drivers/staging/ramzswap/ramzswap_drv.c   |   91 +++++++++++++++++++++++++++++
>  drivers/staging/ramzswap/ramzswap_drv.h   |    1 +
>  drivers/staging/ramzswap/ramzswap_ioctl.h |    1 +
>  include/linux/swap.h                      |   16 +++++-
>  mm/swapfile.c                             |   78 ++++++++++++++++++++++++
>  5 files changed, 185 insertions(+), 2 deletions(-)
> 


Any chance it can go into 2.6.34? Any comments?


Thanks,
Nitin
