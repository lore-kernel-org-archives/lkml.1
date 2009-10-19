Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbZJSF1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbZJSF1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 01:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbZJSF1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 01:27:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752674AbZJSF1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 01:27:38 -0400
Date: Sun, 18 Oct 2009 22:25:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: npiggin@suse.de
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Ian Kent <raven@themaw.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 4/6] brlock: introduce special brlocks
Message-Id: <20091018222512.683973f7.akpm@linux-foundation.org>
In-Reply-To: <20091015050048.777261867@suse.de>
References: <20091015044026.319860788@suse.de>
	<20091015050048.777261867@suse.de>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009 15:40:30 +1100 npiggin@suse.de wrote:

> +#define DECLARE_BRLOCK(name)						\

This:

> + DECLARE_PER_CPU(spinlock_t, name##_lock);				\
> + static inline void name##_lock_init(void) {				\
> +	int i;								\
> +	for_each_possible_cpu(i) {					\
> +		spinlock_t *lock;					\
> +		lock = &per_cpu(name##_lock, i);			\
> +		spin_lock_init(lock);					\
> +	}								\
> + }									\
> + static inline void name##_rlock(void) {				\
> +	spinlock_t *lock;						\
> +	lock = &get_cpu_var(name##_lock);				\
> +	spin_lock(lock);						\
> + }									\

generates a definition, not a declaration.  Hence DEFINE_BRLOCK.

</petpeeve #29>
