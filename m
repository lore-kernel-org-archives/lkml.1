Return-Path: <linux-kernel-owner+w=401wt.eu-S1755005AbZKHTtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbZKHTtg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 14:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbZKHTtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 14:49:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42560 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZKHTtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 14:49:35 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Michael A. Griffith" <grif@acm.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Please get this committed, _NOW_ (preferrably 5 years ago), thanks.
From: Andi Kleen <andi@firstfloor.org>
References: <20091108120008.GA21611@rhlx01.hs-esslingen.de>
Date: Sun, 08 Nov 2009 20:49:39 +0100
In-Reply-To: <20091108120008.GA21611@rhlx01.hs-esslingen.de> (Andreas Mohr's message of "Sun, 8 Nov 2009 13:00:08 +0100")
Message-ID: <871vk87q5o.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Mohr <andi@lisas.de> writes:

> boy am I angry about this...

Angry about yourself?

> --- linux-2.6.32-rc6/init/main.c.orig	2009-11-08 11:09:51.000000000 +0100
> +++ linux-2.6.32-rc6/init/main.c	2009-11-08 12:40:11.000000000 +0100
> @@ -846,7 +846,47 @@ static noinline int init_post(void)
>  	run_init_process("/bin/init");
>  	run_init_process("/bin/sh");
>  
> -	panic("No init found.  Try passing init= option to kernel.");
> +	panic("No init found.  Try passing init= option to kernel. "
> +              "See Linux " __FILE__ " for guidance.");

That seems like the wrong approach. The kernel can actually distingush
many of these cases, so it could just tell the user about them directly.

> +/* ok, so you've got this pretty unintuitive message and are wondering
> + * what the H*** went wrong.
> + * Some high-level reasons for failure (listed roughly in order of execution)
> + * to load the init binary are:
> + * A) Unable to mount root FS

This the kernel knows so it could just say. In fact it's already
printed usually, but it could be printed again.

> + * B) init binary doesn't exist on rootfs

This is knows also.

> + * C) other requirements not met

No idea what that should be.

> + * D) binary exists but dependencies not available

I think you're refering to shared libraries here. This is actually not correct,
because if dynamic linking for init fails this will not result in this error message.

> + * E) binary cannot be loaded

This it also knows.

So please just fix the output.

-Andi
