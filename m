Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbXKTJNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbXKTJNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 04:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755740AbXKTJNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 04:13:12 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39488 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755603AbXKTJNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 04:13:10 -0500
Date: Tue, 20 Nov 2007 01:12:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, devel@openvz.org
Subject: Re: [PATCH 4/4] proc: fix PDE refcounting
Message-Id: <20071120011226.7167445b.akpm@linux-foundation.org>
In-Reply-To: <20071116151241.GF19517@localhost.sw.ru>
References: <20071116151241.GF19517@localhost.sw.ru>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007 18:12:41 +0300 Alexey Dobriyan <adobriyan@sw.ru> wrote:

> Creating PDEs with refcount 0 and ->deleted flag has problems (see below).
> Switch to usual scheme:
> * PDE is created with refcount 1
> * every de_get does +1
> * every de_put() and remove_proc_entry() do -1
> * once refcnt reaches 0, PDE is freed.
> 
> This elegantly fixes at least two followint races (both observed) without new
> locks, without abusing old locks, without spreading lock_kernel():

fs/reiserfs/procfs.c: In function 'r_start':
fs/reiserfs/procfs.c:424: error: 'struct proc_dir_entry' has no member named 'deleted'
