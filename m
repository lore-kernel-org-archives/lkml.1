Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbYLPAWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbYLPAWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 19:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbYLPAWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 19:22:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753145AbYLPAWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 19:22:14 -0500
Date: Mon, 15 Dec 2008 16:21:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: balbir@linux.vnet.ibm.com, hugh@veritas.com, jlan@sgi.com,
       jpirko@redhat.com, jlim@sgi.com, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RESEND] introduce get_mm_hiwater_xxx(), fix
 taskstats->hiwater_xxx accounting
Message-Id: <20081215162148.87fd38a5.akpm@linux-foundation.org>
In-Reply-To: <20081212140524.GA29488@redhat.com>
References: <20081212140524.GA29488@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2008 15:05:24 +0100
Oleg Nesterov <oleg@redhat.com> wrote:
>

> --- K-28/include/linux/sched.h~HIWATER	2008-12-02 17:12:40.000000000 +0100
> +++ K-28/include/linux/sched.h	2008-12-03 18:17:18.000000000 +0100

grumble

> +#define get_mm_hiwater_rss(mm)	max((mm)->hiwater_rss, get_mm_rss(mm))

This evaluates its argument thrice.

> +#define get_mm_hiwater_vm(mm)	max((mm)->hiwater_vm, (mm)->total_vm)

This evaluates its argument twice.


was sched.h the appropriate header in which to implement these?  Maybe...

But they're only ever _used_ in kernel/tsacct.c, so do they actually
need to be implemented in any .h file?

