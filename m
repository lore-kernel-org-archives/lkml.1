Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbZJAAuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbZJAAuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 20:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbZJAAue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 20:50:34 -0400
Received: from mail.perches.com ([173.55.12.10]:1562 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210AbZJAAud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 20:50:33 -0400
Subject: Re: [PATCH 1/2] net/netfilter/ipvs: Move #define KMSG_COMPONENT to
 Makefile
From: Joe Perches <joe@perches.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
       Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
       netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       lvs-devel@vger.kernel.org
In-Reply-To: <alpine.LSU.2.00.0910010219100.7559@obet.zrqbmnf.qr>
References: <cover.1254349374.git.joe@perches.com>
	 <0026bcf5aad9ae5036e68fc2dcda9c778d30dc47.1254349375.git.joe@perches.com>
	 <alpine.LSU.2.00.0910010042540.782@obet.zrqbmnf.qr>
	 <1254352160.2960.119.camel@Joe-Laptop.home>
	 <alpine.LSU.2.00.0910010219100.7559@obet.zrqbmnf.qr>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Sep 2009 17:50:35 -0700
Message-Id: <1254358235.2960.145.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 02:31 +0200, Jan Engelhardt wrote:
> KBUILD_MODNAME is special in that it is derived from the actual
> source filename.

Kind of.  It's derived from the module name, not the filename.

> Of course you could put #define KBUILD_MODNAME "foo"
> in your source file, but that is like putting changelogs there
> when they belong into the git log.

I agree with that.

> Well I personally prefer the #include instead of hiding such in 
> Makefiles. You know, when newcomers could start doing `grep 
> KMSG_COMPONENT *.[ch]`. Perhaps GCC's -include flag in a Makefile
> to avoid #includes in .c files?

I imagine an eventual goal of standardizing the default
pr_fmt define in kernel.h to

	#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

so that all pr_<level> calls get this unless otherwise
specified.

Or perhaps better, to get rid of pr_fmt(fmt) altogether and
have printk emit the filename/modulename, function and/or
code offset by using something like %pS after the level.

I see the Makefile use, which I don't really like too much
because of the information hiding, as an intermediate step
until that's possible.


