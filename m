Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415AbYLEMzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbYLEMzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 07:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbYLEMza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 07:55:30 -0500
Received: from ozlabs.org ([203.10.76.45]:57328 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbYLEMz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 07:55:29 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/3] param: Adapt MN10300 to the new parameter handling regime
Date: Fri, 5 Dec 2008 23:25:22 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <200812051855.07203.rusty@rustcorp.com.au> <20081203163207.13965.56517.stgit@warthog.procyon.org.uk> <2204.1228478296@redhat.com>
In-Reply-To: <2204.1228478296@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812052325.22974.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 December 2008 22:28:16 David Howells wrote:
> I think you're missing:
> 
> 	#define param_mem_keeps_reference 0
> 
> from the stuff you added.

Ah thanks, I didn't actually *cough* test it.

> With that, the core_param stuff does work for mem=...  But I object to
> mem_override not being __initdata.  I also don't think the parameter should
> appear in sysfs - that's just a waste of resources.

If you set the perm to 0, then it won't appear in sys, and hence can be
__initdata.

> It should, perhaps,
> appear in /proc/cmdline, but for some reason it does not.

Hmm, that's more concering.  I'll dig into this in the morning.

> I can live without
> that, though, since its effect appears in /proc/meminfo.
> 
> Also, something else to consider: If CONFIG_MODULES=n and CONFIG_SYSFS=n,
> should the contents of kernel/params.c be discarded along with the __init
> sections?

Yes, I think so.  YA __init variant, but it can be local to kernel/params.c
I think.

Cheers,
Rusty.
