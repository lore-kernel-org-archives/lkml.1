Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbYCXQBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbYCXQBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 12:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbYCXQBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 12:01:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:53678 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbYCXQBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 12:01:03 -0400
Date: Mon, 24 Mar 2008 17:01:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: it is fun to strace /sbin/init
Message-ID: <20080324160102.GB4069@atrey.karlin.mff.cuni.cz>
References: <20080323135110.GA294@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080323135110.GA294@tv-sign.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Ptracing of /sbin/init is not allowed. Of course, this is dangerous, but may
> be useful. Introduce the kernel boot parameter to allow this, so that we can't
> surprise some special/secured systems.
> 
> Afaics, with the recent changes there is no kernel problems with ptracing init,
> it can't lose SIGNAL_UNKILLABLE flag and be killed by accident. However, admin
> should know what it does, "gdb /sbin/init 1" stops init, it can't
> reap zombies

It can't be killed, but you can stop it and not ever restart it. From
that point on, zombies will accumulate until we OOM, right?

> @@ -803,6 +803,8 @@ and is between 256 and 4096 characters. 
>  			Run specified binary instead of /sbin/init as init
>  			process.
>  
> +	init_ptrace	[KNL] Allows to ptrace init.
> +

No words about it being dangerous, but I believe it is.

If it is not, lets do the patch, but not optional.

If it is dangerous, option does not make it better.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
