Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbYCPXua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbYCPXua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 19:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbYCPXuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 19:50:20 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:39180 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbYCPXuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:50:20 -0400
Date: Mon, 17 Mar 2008 02:49:29 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Laurent Riffard <laurent.riffard@free.fr>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] don't panic if /sbin/init exits or killed
Message-ID: <20080316234929.GA456@tv-sign.ru>
References: <20080316155453.GA20845@tv-sign.ru> <20080316221938.D217026F995@magilla.localdomain> <20080316230346.GA379@tv-sign.ru> <20080316233242.DC9E226F995@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080316233242.DC9E226F995@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16, Roland McGrath wrote:
>
> > But panic() isn't better? It doesn't provide any useful info.
> 
> It is not misleading in the same way.  It's clear that going to look at the
> kernel source is not the place to find the root of the problem.
> 
> > Well, I think the generic "if we have a chance to survive, we should try
> > to survive" rule is good.
> > 
> > If the boot init dies, at least the admin has a chance to figure out what
> > has happened, and -o remount,ro /.
> 
> For me and you, I agree.  I think the common case is that there is no admin
> prepared to do any such thing, but just someone expecting a reboot to fix
> things and preferring that a failing system reboot itself in the middle of
> the night rather than wedge.

Agreed,

> > Every BUG/BUG_ON in fact means the system is not useable, but still it does
> > not panic(), but tries to proceed.
> 
> Many production systems probably set panic_on_oops.  Having the init panic
> behavior keyed on that seems fine to me.  I just don't like the "kernel bug
> at this source line" output when it's not true.

Ah, OK. We can change this to dump_stack() without BUG().

(but again! panic() isn't better, it also looks like a kernel bug).

Oleg.

