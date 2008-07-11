Return-Path: <linux-kernel-owner+w=401wt.eu-S1759931AbYGKTX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931AbYGKTX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757122AbYGKTUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:20:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757395AbYGKTU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:20:29 -0400
Date: Fri, 11 Jul 2008 12:19:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [patch 2/17] Add a WARN() macro that acts like WARN_ON()+printk
Message-Id: <20080711121949.ec5db301.akpm@linux-foundation.org>
In-Reply-To: <20080708094023.260a31bb@infradead.org>
References: <20080708093800.274504ba@infradead.org>
	<20080708094023.260a31bb@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2008 09:40:23 -0700 Arjan van de Ven <arjan@infradead.org> wrote:

> From: Arjan van de Ven <arjan@linux.intel.com>
> 
> Add a WARN() macro that acts like WARN_ON(), with the added feature that it
> takes a printk like argument that is printed as part of the warning message.
> 

Apart from a little whitespace tweak, this is identical to what I already had.

> +#define WARN_ONCE(condition, format...)	({			\
> +	static int __warned;					\
> +	int __ret_warn_once = !!(condition);			\
> +								\
> +	if (unlikely(__ret_warn_once))				\
> +		if (WARN(!__warned, format)) 			\
> +			__warned = 1;				\
> +	unlikely(__ret_warn_once);				\
> +})

Except it adds this operation, without describing it at all in the
changelog.

Is this some brainfart, or am I missing something?  I can see some sense in
a WARN_ONCE(format...), but not in a WARN_ONCE() which takes a `condition'
and should be called WARN_ON_ONCE(), which we already have.

As it appears that you didn't add any users of WARN_ONCE(), I shall
delicately step away from this patch.

More care, please?
