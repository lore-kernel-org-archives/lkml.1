Return-Path: <linux-kernel-owner+w=401wt.eu-S1756955AbYKTUXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955AbYKTUXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbYKTUXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:23:44 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55964 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921AbYKTUXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:23:43 -0500
Date: Thu, 20 Nov 2008 22:24:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] protect /sbin/init from unwanted signals more
Message-ID: <20081120212418.GA29345@redhat.com>
References: <20081118175901.GA17134@redhat.com> <20081119185148.DC1D31544EB@magilla.localdomain> <20081120152039.GB3325@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120152039.GB3325@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20, Oleg Nesterov wrote:
>
> On 11/19, Roland McGrath wrote:
> >
> > The effect is fine, but that seems like a kludgey way to do it.
>
> Agreed, that is why I did the next patch to kill the ugliness.
>
> > I really don't think the sigaction case matters--certainly it will never
> > come up with SIGKILL.
>
> Yes. This patch doesn't affect sigaction, the next one adds a very

(this one, not the next one)

> minor side effect: init drops pending !sig_kernel_ignore() signals
> if it does sigaction(SIG_IGN). But this has nothing to do with SIGKILL
> of course.

Ah sorry, now I see I misunderstood you...

You mean, we shouldn't touch the sigaction() path. Now I am wondering
if it is really OK to drop signals if init does sigaction(SIG_DFL),
perhaps you are right.

Oleg.

