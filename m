Return-Path: <linux-kernel-owner+w=401wt.eu-S964865AbXCAKO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964865AbXCAKO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 05:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964868AbXCAKO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 05:14:57 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:52101 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964865AbXCAKO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 05:14:56 -0500
Date: Thu, 1 Mar 2007 11:14:47 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <compudj@google.com>, linux-kernel@vger.kernel.org
Subject: Re: Thread flags modified without set_thread_flag() (non
 atomically)
Message-ID: <20070301111447.37ae08f5@dhcp-252-105.norway.atmel.com>
In-Reply-To: <20070301014523.e45c3cc5.akpm@linux-foundation.org>
References: <45E33EBD.6020603@google.com>
	<20070228220349.b42bf571.akpm@linux-foundation.org>
	<20070301103451.2618cc35@dhcp-252-105.norway.atmel.com>
	<20070301014523.e45c3cc5.akpm@linux-foundation.org>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2007 01:45:23 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> If there's a lesson here, it is "don't provide #defines in the header for
> both versions".

Yes, that's true. It looks like all the other arches do the same thing
with the _TIF flags, however, so just ripping it out probably won't
work. Maybe I'll give it a try just to see how much trouble it is.

> > I don't think either of those need to be atomic though, since both of
> > them happen in monitor mode with interrupts disabled.
> 
> That's true until you implement SMP ;)

True. I'm not sure what it can race against though...perhaps something
in kernel/signal.c?

Haavard
