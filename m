Return-Path: <linux-kernel-owner+w=401wt.eu-S932805AbZLGBVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbZLGBVj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 20:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755794AbZLGBVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 20:21:36 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35619 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbZLGBVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 20:21:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iBOBtVrEeHSqkdrZmjXwgRVpR3ikDhkz+C6kgM4zCAOU+n0MSH64f4/tiZcavp8D+V
         JsM8hYJQTAznZShM3wayJbw6XPWYc+Fsl/CC49ujbJB54a7kmSgsxGXLa3tdLUQeeqJG
         1XYEXESJnvfVS1WM9jTB7KYuXqDCQjGuCl6Gk=
Date: Mon, 7 Dec 2009 02:21:41 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [patch 13/23] plist: Make plist debugging raw_spinlock aware
Message-ID: <20091207012140.GB4966@nowhere>
References: <20091206110944.492100233@linutronix.de> <20091206111957.806855005@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091206111957.806855005@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 06, 2009 at 06:02:57PM -0000, Thomas Gleixner wrote:
> plists are used with spinlocks and raw_spinlocks. Change the plist
> debugging to handle both types.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/linux/plist.h |   43 +++++++++++++++++++++++++++++++++++++------
>  kernel/futex.c        |    6 +++---
>  lib/plist.c           |    8 +++++---
>  3 files changed, 45 insertions(+), 12 deletions(-)
> 
> Index: linux-2.6-tip/include/linux/plist.h
> ===================================================================
> --- linux-2.6-tip.orig/include/linux/plist.h
> +++ linux-2.6-tip/include/linux/plist.h
> @@ -81,7 +81,8 @@ struct plist_head {
>  	struct list_head prio_list;
>  	struct list_head node_list;
>  #ifdef CONFIG_DEBUG_PI_LIST
> -	spinlock_t *lock;
> +	raw_spinlock_t *rawlock;
> +	spinlock_t *spinlock;
>  #endif
>  };



This could be a union probably, as we don't use both at the
same time?

