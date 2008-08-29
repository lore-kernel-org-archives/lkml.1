Return-Path: <linux-kernel-owner+w=401wt.eu-S1759235AbYH2WVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbYH2WVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 18:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbYH2WVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 18:21:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752093AbYH2WVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 18:21:38 -0400
Date: Fri, 29 Aug 2008 15:20:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com
Subject: Re: [PATCH] dyn_array: using %pF instead of
 print_fn_descriptor_symbol
Message-Id: <20080829152053.92fa6fd4.akpm@linux-foundation.org>
In-Reply-To: <1220047669-15029-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220047669-15029-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 15:07:49 -0700
Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> +		printk(KERN_DEBUG "per_cpu_dyn_array %pF ==> [%#lx - %#lx]\n",
> +			da->name, phys, phys + size);

This:

struct dyn_array {
	void **name;

is a bit confusing.  One normally expects a variable called "name" to
point at a character string.

What _does_ this thing point at?  There are no code comments which I
can find, it's unobvious from the source code, the type is the
information-free void** and the identifier is misleading.

I find that documenting the data structures is the best way of making
code understandable (and hence maintainable).

