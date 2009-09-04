Return-Path: <linux-kernel-owner+w=401wt.eu-S934271AbZIDVS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934271AbZIDVS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 17:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934025AbZIDVSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 17:18:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933855AbZIDVSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 17:18:55 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH for-2.6.31] virtio_blk: revert QUEUE_FLAG_VIRT addition
References: <20090904204442.GA30941@lst.de>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 04 Sep 2009 17:18:51 -0400
In-Reply-To: <20090904204442.GA30941@lst.de> (Christoph Hellwig's message of
	"Fri, 4 Sep 2009 22:44:42 +0200")
Message-ID: <x49ab1as91g.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> It seems like the addition of QUEUE_FLAG_VIRT caueses major performance
> regressions for Fedora users:
>
> 	https://bugzilla.redhat.com/show_bug.cgi?id=509383
> 	https://bugzilla.redhat.com/show_bug.cgi?id=505695
>
> while I can't reproduce those extreme regressions myself I think the flag
> is wrong.
>
> Rationale:
>
>   QUEUE_FLAG_VIRT expands to QUEUE_FLAG_NONROT which casus the queue
>   unplugged immediately.  This is not a good behaviour for at least
>   qemu and kvm where we do have significant overhead for every
>   I/O operations.  Even with all the latested speeups (native AIO,
>   MSI support, zero copy) we can only get native speed for up to 128kb
>   I/O requests we already are down to 66% of native performance for 4kb
>   requests even on my laptop running the Intel X25-M SSD for which the
>   QUEUE_FLAG_NONROT was designed.
>   If we ever get virtio-blk overhead low enough that this flag makes
>   sense it should only be set based on a feature flag set by the host.

I agree with that rationale.

Acked-by: Jeff Moyer <jmoyer@redhat.com>
