Return-Path: <linux-kernel-owner+w=401wt.eu-S1757788AbXJ2Q4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788AbXJ2Q4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 12:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbXJ2Q4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 12:56:08 -0400
Received: from [198.99.130.12] ([198.99.130.12]:36703 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbXJ2Q4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 12:56:06 -0400
Date: Mon, 29 Oct 2007 12:55:29 -0400
From: Jeff Dike <jdike@addtoit.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       user-mode-linux-devel@lists.sourceforge.net,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [Git Patch] arch/um/os-Linux/: varied improvements and fixes
Message-ID: <20071029165529.GA6055@c2.user-mode-linux.org>
References: <20071028073843.GD2502@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028073843.GD2502@hacking>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 03:38:43PM +0800, WANG Cong wrote:
> This patch contains varied fixes and improvements for some files under
> arch/um/os-Linux/, such as a typo fix in a perror message, a missing
> argument fix for a printf, some constifying for pointers and so on.

Generally looks good, thanks.


>  		printf("failed to install handler for signal %d - errno = %d\n",
> -		       errno);
> +		       sig, errno);

Nice spotting - I wonder why gcc didn't complain about this.

> -	sigprocmask(on ? SIG_UNBLOCK : SIG_BLOCK, &sigset, &old);
> +	if (sigprocmask(on ? SIG_UNBLOCK : SIG_BLOCK, &sigset, &old) < 0)
> +		return -1;

In cases like this, I return -errno, not -1.  I'll fix this up.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
