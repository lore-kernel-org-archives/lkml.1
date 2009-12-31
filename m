Return-Path: <linux-kernel-owner+w=401wt.eu-S1752073AbZLaJEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbZLaJEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 04:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbZLaJEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 04:04:12 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51076 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbZLaJEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 04:04:09 -0500
Message-ID: <4B3C68F7.60100@cs.helsinki.fi>
Date: Thu, 31 Dec 2009 11:03:51 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Nitin Gupta <ngupta@vflare.org>
CC: Andi Kleen <andi@firstfloor.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] [mmotm v2] Add notifiers for various swap events
References: <1262232518-2841-1-git-send-email-ngupta@vflare.org>
In-Reply-To: <1262232518-2841-1-git-send-email-ngupta@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nitin Gupta wrote:
> Events:
>  - Swapon
>  - Swapoff
>  - When a swap slot is freed
> 
> This is required for ramzswap module which implements RAM based block
> devices to be used as swap disks. These devices require a notification
> on these events to function properly.
> 
> Currently, I'm not sure if any of these event notifiers have any other
> users. However, adding ramzswap specific hooks instead of this generic
> approach resulted in a bad/hacky code with too many 'ifdef CONFIG_RAMZSWAP'
> spread all over the core kernel code.
> 
> For SWAP_EVENT_SLOT_FREE, callbacks are made under swap_lock. Currently, this
> is not a problem since ramzswap is the only user and the callback it registers
> can be safely made under this lock. However, if this event finds more users,
> we might have to work on reducing contention on this lock (per-swap lock?).
> 
> v2: added comment before swap slot free notifier call to clarify that
> ramzswap is currently the only user of this notifier.
> 
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>

Andi didn't seem to like this one and we're still waiting for Hugh to 
comment on the issue. But, FWIW,

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

			Pekka
