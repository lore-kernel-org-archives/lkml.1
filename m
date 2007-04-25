Return-Path: <linux-kernel-owner+w=401wt.eu-S2992557AbXDYKE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992557AbXDYKE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992561AbXDYKE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:04:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992557AbXDYKE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:04:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070424215034.GA5985@tv-sign.ru> 
References: <20070424215034.GA5985@tv-sign.ru> 
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Jarek Poplawski <jarkao2@o2.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cancel_delayed_work: use del_timer() instead of del_timer_sync() 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 25 Apr 2007 11:04:03 +0100
Message-ID: <23525.1177495443@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> wrote:

> del_timer_sync() buys nothing for cancel_delayed_work(), but it is less
> efficient since it locks the timer unconditionally, and may wait for the
> completion of the delayed_work_timer_fn().

Okay, this patch seems to work for me, though I'm not using any of the other
related patches that are in the -mm tree (I modified this patch to compile
directly on top of Linus's vanilla tree).

Acked-By: David Howells <dhowells@redhat.com>
