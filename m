Return-Path: <linux-kernel-owner+w=401wt.eu-S933368AbXBXEIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368AbXBXEIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 23:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933369AbXBXEIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 23:08:09 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46409 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933368AbXBXEII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 23:08:08 -0500
Date: Sat, 24 Feb 2007 13:07:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [rfc][patch] dynamic resizing dentry hash using RCU
Message-Id: <20070224130723.01f3c429.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070223153743.GA26141@wotan.suse.de>
References: <20070223153743.GA26141@wotan.suse.de>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Feb 2007 16:37:43 +0100
Nick Piggin <npiggin@suse.de> wrote:

> +static void dcache_hash_resize(unsigned int new_shift);
> +static void mod_nr_dentry(int mod)
> +{
> +	unsigned long dentry_size;
> +
> +	dentry_stat.nr_dentry += mod;
> +
> +	dentry_size = 1 << dentry_hash->shift;
> +	if (unlikely(dentry_stat.nr_dentry > dentry_size+(dentry_size>>1)))
> +		dcache_hash_resize(dentry_hash->shift+1);
> +	else if (unlikely(dentry_stat.nr_dentry < (dentry_size>>1)))
> +		dcache_hash_resize(dentry_hash->shift-1);
> +}
> +

Do we need to do this kind of resizing in implicit automatic way ?
I think it's good to show contention rate by /proc and add sysctl for
resize this.

-Kame

