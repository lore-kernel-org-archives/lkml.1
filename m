Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbZCPAc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbZCPAc3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 20:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbZCPAcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 20:32:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35934 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbZCPAcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 20:32:20 -0400
Date: Mon, 16 Mar 2009 01:28:33 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: =?iso-8859-1?Q?G=E1bor?= Melis <mega@retes.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Signal delivery order
Message-ID: <20090316002833.GA17615@redhat.com>
References: <200903141750.37238.mega@retes.hu> <200903151540.00542.mega@retes.hu> <20090315172926.GA21095@redhat.com> <200903152306.53031.mega@retes.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903152306.53031.mega@retes.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15, Gábor Melis wrote:
>
> On Domingo 15 Marzo 2009, Oleg Nesterov wrote:
> > >
> > Now, since there are no more pending signals, we return to the user
> > space, and start sig_2().
>
> I see. I guess in addition to changing the ip, the stack frobbing magic
> arranges that sig_2 returns to sig_1 or some code that calls sig_1.

yes. "some code" == rt_sigreturn,

> The revised signal-delivery-order.c (also attached) outputs:
>
> test_handler=8048727
> sigsegv_handler=804872c
> eip: 8048727
> esp: b7d94cb8
>
> which shows that sigsegv_handler also has incorrect eip in the context.

Why do you think it is not correct?

I didn't try your test-case, but I can't see where "esp: b7d94cb8"
comes from. But "eip: 8048727" looks exactly right, this is the
address of test_handler.

Oleg.

