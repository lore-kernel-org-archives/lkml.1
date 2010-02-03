Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833Ab0BCULE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 15:11:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757796Ab0BCULA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 15:11:00 -0500
Date: Wed, 3 Feb 2010 21:09:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jmoskovc@redhat.com, mingo@redhat.com, drbd-dev@lists.linbit.com,
       benh@kernel.crashing.org, t.sailer@alumni.ethz.ch, abelay@mit.edu,
       gregkh@suse.de, spock@gentoo.org, viro@zeniv.linux.org.uk,
       neilb@suse.de, mfasheh@suse.com, menage@google.com,
       shemminger@linux-foundation.org, takedakn@nttdata.co.jp
Subject: Re: [PATCH 1/2] exec: refactor how call_usermodehelper works, and
	update the sense of the core_pipe recursion check (v3)
Message-ID: <20100203200954.GA15000@redhat.com>
References: <20100121200806.GA29801@shamino.rdu.redhat.com> <20100202191940.GB12697@hmsreliant.think-freely.org> <20100202192059.GC12697@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202192059.GC12697@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02, Neil Horman wrote:
>
> +void call_usermodehelper_setfns(struct subprocess_info *info,
> +		    int (*init)(struct subprocess_info *info),
> +		    void (*cleanup)(struct subprocess_info *info),
> +		    void *data);
> ...
> +call_usermodehelper_fns(char *path, char **argv, char **envp,
> +		    enum umh_wait wait,
> +		    int (*init)(struct subprocess_info *info),
> +		    void (*cleanup)(struct subprocess_info *), void *data)
> ...
> +	call_usermodehelper_setfns(info, init, cleanup, data);
>  	return call_usermodehelper_exec(info, wait);
>  }

Unless I misread the patch, this is the only caller of _setfns(), and
this helper is really trivial and probably deserves to be inline. But
this is very minor.

Personally I think these patches are nice. Not only this series adds
the new functionality, in my opinion it also cleanups and simplifies
the code.

Oleg.

