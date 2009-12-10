Return-Path: <linux-kernel-owner+w=401wt.eu-S1761349AbZLJSNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761349AbZLJSNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 13:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761215AbZLJSNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 13:13:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761206AbZLJSNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 13:13:07 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] Fix a CFQ crash in "for-2.6.33" branch of block tree
References: <20091210170845.GA8327@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 10 Dec 2009 13:13:07 -0500
In-Reply-To: <20091210170845.GA8327@redhat.com> (Vivek Goyal's message of
	"Thu, 10 Dec 2009 12:08:45 -0500")
Message-ID: <x49ljhalmto.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> I think I have hit following BUG_ON() in cfq_dispatch_request().
>
> BUG_ON(RB_EMPTY_ROOT(&cfqq->sort_list));
>
> Please find attached the patch to fix it. I have done some stress testing
> with it and have not seen it happening again.
>
>
> o We should wait on a queue even after slice expiry only if it is empty. If
>   queue is not empty then continue to expire it.
>
> o If we decide to keep the queue then make cfqq=NULL. Otherwise select_queue()
>   will return a valid cfqq and cfq_dispatch_request() can hit following
>   BUG_ON().
>
>   BUG_ON(RB_EMPTY_ROOT(&cfqq->sort_list))
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
