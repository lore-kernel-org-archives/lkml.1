Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab0CKNYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 08:24:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57166 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757856Ab0CKNYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 08:24:11 -0500
Date: Thu, 11 Mar 2010 14:23:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Rientjes <rientjes@google.com>, Greg KH <gregkh@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: increase CONFIG_NODES_SHIFT max to 10
Message-ID: <20100311132354.GA26600@elte.hu>
References: <alpine.DEB.2.00.1003101537330.30724@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003101537330.30724@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Rientjes <rientjes@google.com> wrote:

> Some larger systems require more than 512 nodes, so increase the maximum 
> CONFIG_NODES_SHIFT to 10 for a new max of 1024 nodes.
> 
> This was tested with numa=fake=64M on systems with more than 64GB of RAM. A 
> total of 1022 nodes were initialized.
> 
> Successfully builds with no additional warnings on x86_64 allyesconfig.

Not so here:

drivers/base/node.c:169: error: negative width in bit-field ?<anonymous>?

>  Greg KH has queued up numa-fix-BUILD_BUG_ON-for-node_read_distance.patch
>  for 2.6.35 to fix the build error when CONFIG_NODES_SHIFT is set to 10.
>  See http://lkml.org/lkml/2010/3/10/390

erm. Alas I cannot merge it in the x86 tree without that fix being upstream. 
Why for v2.6.35 - shouldnt that be v2.6.34?

	Ingo
