Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbZDLRby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbZDLRby (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 13:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbZDLRbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 13:31:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128AbZDLRbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 13:31:41 -0400
Date: Sun, 12 Apr 2009 10:29:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] radix-tree: add radix_tree_prev_hole()
Message-Id: <20090412102952.0dd377d6.akpm@linux-foundation.org>
In-Reply-To: <20090412072052.457214378@intel.com>
References: <20090412071950.166891982@intel.com>
	<20090412072052.457214378@intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Apr 2009 15:19:51 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:

> +unsigned long radix_tree_prev_hole(struct radix_tree_root *root,
> +				   unsigned long index, unsigned long max_scan)
> +{
> +	unsigned long i;
> +
> +	for (i = 0; i < max_scan; i++) {
> +		if (!radix_tree_lookup(root, index))
> +			break;
> +		index--;
> +		if (index == LONG_MAX)
> +			break;
> +	}
> +
> +	return index;
> +}

argh.  This is about as inefficient as we could possibly make it :(

Really, this function should dive into radix-tree internals and walk
individual radix_tree_node.slots[] arrays.  And heck, it can peek at
radix_tree_node.count and _bypass_ entire nodes, too.

