Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbZKDSxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbZKDSxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 13:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZKDSxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 13:53:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbZKDSxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 13:53:50 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 11/20] blkio: Some CFQ debugging Aid
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
	<1257291837-6246-12-git-send-email-vgoyal@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 04 Nov 2009 13:52:51 -0500
In-Reply-To: <1257291837-6246-12-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Tue, 3 Nov 2009 18:43:48 -0500")
Message-ID: <x49hbtat94s.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> o Some CFQ debugging Aid.

Some CFQ debugging aids.  Sorry, I couldn't help myself.

> +config DEBUG_BLK_CGROUP
> +	bool
> +	depends on BLK_CGROUP
> +	default n
> +	---help---
> +	Enable some debugging help. Currently it stores the cgroup path
> +	in the blk group which can be used by cfq for tracing various
> +	group related activity.
> +
>  endif # BLOCK
>  

> +config DEBUG_CFQ_IOSCHED
> +	bool "Debug CFQ Scheduling"
> +	depends on CFQ_GROUP_IOSCHED
> +	select DEBUG_BLK_CGROUP

This seems wrong.  DEBUG_CFQ_IOSCHED sounds like it enables debugging of
CFQ.  In your implementation, though, it only enables this in tandem
with the blkio cgroup infrastructure.  Please decouple these things.

> +#ifdef CONFIG_DEBUG_BLK_CGROUP
> +	/* Store cgroup path */
> +	char path[128];
> +#endif

Where does 128 come from?  What's wrong with PATH_MAX?

Cheers,
Jeff
