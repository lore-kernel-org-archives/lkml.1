Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbXIQLFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbXIQLFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 07:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbXIQLEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 07:04:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52436 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110AbXIQLEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 07:04:53 -0400
Date: Mon, 17 Sep 2007 04:03:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, kwc@citi.umich.edu,
       Trond.Myklebust@netapp.com, linux-kernel@vger.kernel.org,
       smfrench@gmail.com, nfsv4@linux-nfs.org
Subject: Re: [PATCH] KEYS: Make request_key() and co fundamentally
 asynchronous
Message-Id: <20070917040353.ac8dee7b.akpm@linux-foundation.org>
In-Reply-To: <16559.1190026560@redhat.com>
References: <20070914165938.9a429e02.akpm@linux-foundation.org>
	<20070912142508.19311.45995.stgit@warthog.procyon.org.uk>
	<16559.1190026560@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007 11:56:00 +0100 David Howells <dhowells@redhat.com> wrote:

> > checkpatch generates a pile of warnings, all of which afacit are legit.
> 
> For this warning:
> 
> ERROR: need space after that ',' (ctx:WxV)
> #627: FILE: security/keys/internal.h:28:
> +#define kenter(FMT, ...) no_printk("==> %s("FMT")\n",__FUNCTION__ ,##__VA_ARGS__)
> 
>                                                                    ^
> 
> This is with good reason.  Some versions of cpp get the ## resolution "wrong"
> if __VA_ARGS__ is empty (ie: there are no arguments to the macro that
> correspond to the "...").  This can be worked around by abutting the "," the
> "##" and the "__VA_ARGS__" with no spaces, and inserting a space before the
> comma.

Tell me about it - I fixed that about 10000000000 times.  Then we upped the
minimum required gcc version so it is no longer a problem.
