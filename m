Return-Path: <linux-kernel-owner+w=401wt.eu-S1757847AbXHUKac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847AbXHUKac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 06:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbXHUKaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 06:30:22 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:44566 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbXHUKaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 06:30:21 -0400
Date: Tue, 21 Aug 2007 14:30:02 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: sukadev@us.ibm.com
Cc: Daniel Pittman <daniel@rimspace.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Kirill Korotaev <dev@sw.ru>,
       Pavel Emelyanov <xemul@sw.ru>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH] fix /sbin/init signal handling
Message-ID: <20070821103002.GA164@tv-sign.ru>
References: <20070819150822.GA7772@tv-sign.ru> <20070821071019.GA8641@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070821071019.GA8641@us.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, sukadev@us.ibm.com wrote:
> 
> I am still reviewing this patch and will try to plug in the multiple
> pid ns code and play with it some more in the next couple of days.

Thanks!

> But am curious why we need the in_interrupt() check and that too only
> for the container-init process.

For example, send_sigio(). We shouldn't send this signal to /sbin/init.
But what if the interrupted process is from the parent namespace?

> Also, maybe a dumb que, are the checks for SIG_IGN and SIG_DFL required
> both on sender side and the receiver side (get_signal_to_deliver())

get_signal_to_deliver() checks SIG_IGN/SIG_DFL, but I guess you meant
a special check for init.

Unless the patch is wrong, this is not needed. And, in fact we can't do
this anyway. Because get_signal_to_deliver() can't know if the signal
comes from parent namespace or not.

Oleg.

