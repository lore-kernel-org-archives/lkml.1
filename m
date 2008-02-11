Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbYBKQlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbYBKQlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbYBKQlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:41:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbYBKQlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:41:03 -0500
Date: Mon, 11 Feb 2008 11:38:32 -0500
From: Jason Baron <jbaron@redhat.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Joe Perches <joe@perches.com>, mathieu.desnoyers@polymtl.ca,
       akpm@linux-foundation.org, mingo@elte.hu, fche@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] make pr_debug() dynamic
Message-ID: <20080211163832.GA10777@redhat.com>
References: <20080207210320.GA14732@redhat.com> <1202424134.27394.42.camel@localhost> <20080208155204.GB13650@redhat.com> <Pine.LNX.4.64.0802092320380.6917@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802092320380.6917@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 11:21:58PM +0100, Jan Engelhardt wrote:
> >> 
> >> What's wrong with klogd -c 8 or equivalent?
> >
> >Setting the loglevel higher, will not make pr_debug() calls visible. The only
> >way to make them visible right now, is by re-compiling the kernel.
> 
> pr_debug() was IMHO meant to be a compile-time optimization
> to throw out debug messages most people do not want.
> 
> If you want to switch on/off debugging messages, use
> printk(KERN_DEBUG) [with klogd -c something] and not pr_debug!

true, we could turn pr_debug() calls into printk(KERN_DEBUG) calls, but there
is an overhead to all these extra printk functions calls. The way I have
implemented pr_debug(), there is no function call at all, in the off case.
To me pr_debug() is currently a compile option, b/c there is often a lot of
overhead to having it on. Being able to turn pr_debug() calls off/on in a
production environment, to get debugging data seems very valuable.

thanks,

-Jason
