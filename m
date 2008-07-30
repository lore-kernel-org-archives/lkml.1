Return-Path: <linux-kernel-owner+w=401wt.eu-S1757876AbYG3Idb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbYG3Idb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 04:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbYG3IdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 04:33:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751559AbYG3IdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 04:33:21 -0400
Date: Wed, 30 Jul 2008 01:30:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Michael Holzheu <holzheu@de.ibm.com>
Subject: Re: [patch 01/15] kmsg: Kernel message catalog macros.
Message-Id: <20080730013059.4d411750.akpm@linux-foundation.org>
In-Reply-To: <20080728175511.023246676@de.ibm.com>
References: <20080728175355.734299984@de.ibm.com>
	<20080728175511.023246676@de.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 19:53:56 +0200 Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> Introduce a new family of printk macros which prefixes each kmsg message
> with a component name and allows to tag the printk with a message id.
> 
> The kmsg component name is defined per source file with the KMSG_COMPONENT
> macro. The first argument of each kmsg printk is the message id. The
> message id "0" is special as it will suppress the message id prefix.
> 
> If the message id will be printed to the console / syslog at all depends
> on CONFIG_MSG_IDS. If it is "n" then a kmsg_xxx call is just another
> printk wrapper. These macros are intended to be used uniformly in the
> s390 architecture and the s390 device drivers.
> 
> Signed-off-by: Michael Holzheu <holzheu@de.ibm.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
> 
>  arch/s390/Kconfig       |    9 +++
>  include/asm-s390/kmsg.h |  124 ++++++++++++++++++++++++++++++++++++++++++++++++

Numerous people want a facility like this for other-than-s390 use. 
Progress has been intermittent and appears to have stopped.  The
apparently-dead mailing list is archived here:
https://lists.linux-foundation.org/pipermail/lf_kernel_messages/.

I don't know what the future holds for that development effort, but the
requirement won't go away.  So one day someone is going to go and yank
your implementation out of arch/s390 and into generic code.

So I'd suggest that you start out that way.
