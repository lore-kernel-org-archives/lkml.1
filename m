Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbYKTOUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbYKTOUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbYKTOUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:20:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60446 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828AbYKTOUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:20:32 -0500
Date: Thu, 20 Nov 2008 16:20:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] protect /sbin/init from unwanted signals more
Message-ID: <20081120152039.GB3325@redhat.com>
References: <20081118175901.GA17134@redhat.com> <20081119185148.DC1D31544EB@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081119185148.DC1D31544EB@magilla.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19, Roland McGrath wrote:
>
> The effect is fine, but that seems like a kludgey way to do it.

Agreed, that is why I did the next patch to kill the ugliness.

> I really don't think the sigaction case matters--certainly it will never
> come up with SIGKILL.

Yes. This patch doesn't affect sigaction, the next one adds a very
minor side effect: init drops pending !sig_kernel_ignore() signals
if it does sigaction(SIG_IGN). But this has nothing to do with SIGKILL
of course.

> What about just this instead?
>
> +	if (unlikely(signal->flags & SIGNAL_UNKILLABLE) &&
> +	    (handler == SIG_IGN || handler == SIG_DFL))
> +		return 1;
> +
>  	if (!sig_handler_ignored(handler, sig))
>  		return 0;

Yes, this is the same, but anyway this is killed by the next patch.



> For consistency, change tracehook_consider_fatal_signal to match.

Yes, will do.

Oleg.

