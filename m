Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984AbZI1NWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbZI1NWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 09:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbZI1NWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 09:22:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46119 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbZI1NWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 09:22:14 -0400
Subject: Re: [patch 03/33] fs: scale files_lock
From: Peter Zijlstra <peterz@infradead.org>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090904065534.303326352@nick.local0.net>
References: <20090904065142.114706411@nick.local0.net>
	 <20090904065534.303326352@nick.local0.net>
Content-Type: text/plain
Date: Mon, 28 Sep 2009 15:22:19 +0200
Message-Id: <1254144139.15795.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-04 at 16:51 +1000, npiggin@suse.de wrote:
> +static void file_list_lock_all(void)
> +{
> +       int i;
> +       int nr = 0;
> +
> +       for_each_possible_cpu(i) {
> +               spinlock_t *lock;
> +
> +               lock = &per_cpu(files_cpulock, i);
> +               spin_lock_nested(lock, nr);
> +               nr++;
> +       }
> +}

Same here, this'll make lockdep explode on >8-way. And create large spin
times on large smp boxen.

