Return-Path: <linux-kernel-owner+w=401wt.eu-S1756491AbZCBQTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbZCBQTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 11:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbZCBQTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 11:19:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:46602 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbZCBQTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 11:19:35 -0500
Date: Mon, 2 Mar 2009 08:20:03 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andreas Robinson <andr345@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Rusty Russell <rusty@rustcorp.com.au>,
       sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
Message-ID: <20090302082003.1bb7bdc5@infradead.org>
In-Reply-To: <1236004353.10055.49.camel@andreas-laptop>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
	<cc43514a0902170242m5af7e511ne00f424f06a5da22@mail.gmail.com>
	<ac3eb2510902170353ia62a630nbe5cf059ca7d616e@mail.gmail.com>
	<200902181528.29697.rusty@rustcorp.com.au>
	<ac3eb2510902180115o4690a335n129e4df695540de0@mail.gmail.com>
	<1234952753.10531.48.camel@andreas-laptop>
	<cc43514a0902191637h5a9680c5id95f7d6c32cca472@mail.gmail.com>
	<ac3eb2510902191755i391d4defnc5a514f4525ec6cf@mail.gmail.com>
	<1235216636.7025.1023.camel@andreas-laptop>
	<1236004353.10055.49.camel@andreas-laptop>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A monolithic kernel with parallelized initcalls is better - about 200
> ms faster than parallel insmods on my test system. However, it comes
> with a fairly large set of changes:
> 
> * First, you need a 200-line patch in init/main.c (do_initcalls() and
> friends)

why?
We already have async function calls; and those speed up my boot (when
enabled) significantly, by doing much of the kernel/driver init in
parallel.

My server box boots the whole kernel (including all drivers; I build
verything in) in 0.56 seconds, and my net books do it in around 1.0
seconds.

> 
> * Then the built-in module dependencies must be calculated properly,
> eg with a modified depmod, and added to the build process.

nope not if done right

> So, what do you think, should I keep going? IMHO, the slower userspace
> implementation is acceptable since it's so much simpler.

I would strongly suggest that you turn on the async function calls and
look at the boot graph of the resulting kernel boot... if you send
that to me I can also take a look and make suggestions....

