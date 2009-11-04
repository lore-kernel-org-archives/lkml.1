Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbZKDQCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbZKDQCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:02:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbZKDQCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:02:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756657AbZKDQCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:02:08 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 08/20] blkio: Add support for dynamic creation of cfq_groups
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
	<1257291837-6246-9-git-send-email-vgoyal@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 04 Nov 2009 11:01:51 -0500
In-Reply-To: <1257291837-6246-9-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Tue, 3 Nov 2009 18:43:45 -0500")
Message-ID: <x49vdhqth1s.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> +	/* Do we need to take this reference */
> +	if (!css_tryget(&blkcg->css))
> +		return NULL;;

Interesting question.  It seems like, so long as you want to reference
that cgroup, you need a reference on it.  ->alloc will only give you
one, so as long as we have pointers to these squirreled away, we need to
bump the reference count.  Please take a look at this before your next
posting.

> +
> +	cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
> +	if (cfqg || !create)
> +		goto done;
> +
> +	cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC |  __GFP_ZERO,
> +					cfqd->queue->node);
Do you really have to OR in __GFP_ZERO for kzalloc?

> +	cfqg = cfq_find_alloc_cfqg(cfqd, cgroup, create);
> +	if (!cfqg && create)
> +		cfqg = &cfqd->root_group;

Hmm, is that really the behaviour you want?

Cheers,
Jeff
