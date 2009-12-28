Return-Path: <linux-kernel-owner+w=401wt.eu-S1751735AbZL1LBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbZL1LBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 06:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbZL1LBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 06:01:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38119 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbZL1LBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 06:01:47 -0500
Subject: Re: [PATCH] perf lock: Implement basic sorting function of perf
 lock
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1261277805-27023-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1261277805-27023-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Dec 2009 12:01:04 +0100
Message-ID: <1261998064.7135.74.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 11:56 +0900, Hitoshi Mitake wrote:
> +static struct lock_stat *lock_stat_findnew(void *addr, const char *name)
> +{
> +       struct list_head *entry = lockhashentry(addr);
> +       struct lock_stat *ret, *new;


Right, so you use a hash table to match lock instances, I suppose that's
faster than an rb-tree?

Do you also remove instances after a match to keep the hash relatively
small?

