Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbYKEXMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbYKEXMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 18:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYKEXMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 18:12:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752611AbYKEXMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 18:12:18 -0500
Date: Wed, 5 Nov 2008 15:12:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: haradats@nttdata.co.jp, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, takedakn@nttdata.co.jp,
       penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [TOMOYO #12 (2.6.28-rc2-mm1) 04/11] Introduce d_realpath().
Message-Id: <20081105151212.9c6053eb.akpm@linux-foundation.org>
In-Reply-To: <20081104060948.233911964@nttdata.co.jp>
References: <20081104060847.086543472@nttdata.co.jp>
	<20081104060948.233911964@nttdata.co.jp>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov 2008 15:08:51 +0900
Kentaro Takeda <takedakn@nttdata.co.jp> wrote:

> +		/*
> +		 * Exception: Use /proc/self/ rather than /proc/\$/
> +		 * for current process.
> +		 */
> +		name = dentry->d_name.name;
> +		name_len = dentry->d_name.len;
> +		if (IS_ROOT(parent) &&
> +		    parent->d_sb->s_magic == PROC_SUPER_MAGIC &&
> +		    !strict_strtoul(name, 10, &pid)) {

Well that looks like rather a hack.

It would still be a hack, but a better implementation might be to save
the procfs superblock's address in a global then do


#ifdef CONFIG_PROCFS
static inline bool is_procfs_sb(struct super_block *sb)
{
	return sb == saved_procfs_sb;
}
#else
static inline bool is_procfs_sb(struct super_block *sb)
{
	return false;
}
#endif

