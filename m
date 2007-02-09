Return-Path: <linux-kernel-owner+w=401wt.eu-S1946267AbXBIJfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946267AbXBIJfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 04:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946268AbXBIJfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 04:35:40 -0500
Received: from smtp.osdl.org ([65.172.181.24]:39298 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946267AbXBIJfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 04:35:39 -0500
Date: Fri, 9 Feb 2007 01:35:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@muc.de>, virtualization <virtualization@lists.osdl.org>,
       Paul Mackerras <paulus@samba.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 6/10] lguest code: the little linux hypervisor.
Message-Id: <20070209013518.e75d5036.akpm@linux-foundation.org>
In-Reply-To: <1171012827.2718.42.camel@localhost.localdomain>
References: <1171012296.2718.26.camel@localhost.localdomain>
	<1171012458.2718.30.camel@localhost.localdomain>
	<1171012693.2718.37.camel@localhost.localdomain>
	<1171012761.2718.40.camel@localhost.localdomain>
	<1171012827.2718.42.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Feb 2007 20:20:27 +1100 Rusty Russell <rusty@rustcorp.com.au> wrote:

> +#define log(...)					\
> +	do {						\
> +		mm_segment_t oldfs = get_fs();		\
> +		char buf[100];				\
> +		sprintf(buf, "lguest:" __VA_ARGS__);	\
> +		set_fs(KERNEL_DS);			\
> +		sys_write(1, buf, strlen(buf));		\
> +		set_fs(oldfs);				\
> +	} while(0)

Due to gcc shortcomings, each instance of this will chew an additional 100
bytes of stack.  Unless they fixed it recently.  Is a bit of a timebomb.  I
guess ksaprintf() could be used.

It also looks a bit, umm, innovative.
