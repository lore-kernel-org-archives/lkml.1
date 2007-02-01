Return-Path: <linux-kernel-owner+w=401wt.eu-S1423006AbXBAVNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423006AbXBAVNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 16:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423019AbXBAVNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 16:13:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423006AbXBAVNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 16:13:30 -0500
To: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Cc: "'Andrew Morton'" <akpm@osdl.org>, "'Benjamin LaHaise'" <bcrl@kvack.org>,
       <zach.brown@oracle.com>, <linux-aio@kvack.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [patch] aio: fix buggy put_ioctx call in aio_complete - v2
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
References: <000101c72bb2$a47bfa70$d634030a@amr.corp.intel.com>
From: Jeff Moyer <jmoyer@redhat.com>
Date: Thu, 01 Feb 2007 16:13:11 -0500
In-Reply-To: <000101c72bb2$a47bfa70$d634030a@amr.corp.intel.com> (Kenneth W. Chen's message of "Fri, 29 Dec 2006 17:34:26 -0800")
Message-ID: <x49lkjhy42g.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.5-b27 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

==> On Fri, 29 Dec 2006 17:34:26 -0800, "Chen, Kenneth W" <kenneth.w.chen@intel.com> said:

Kenneth> An AIO bug was reported that sleeping function is being called in softirq
Kenneth> context:

Kenneth> The real problem is that the condition check of ctx->reqs_active in
Kenneth> wait_for_all_aios() is incorrect that access to reqs_active is not
Kenneth> being properly protected by spin lock.

Kenneth> This patch adds that protective spin lock, and at the same time removes
Kenneth> all duplicate ref counting for each kiocb as reqs_active is already used
Kenneth> as a ref count for each active ioctx.  This also ensures that buggy call
Kenneth> to flush_workqueue() in softirq context is eliminated.

I was finally able to wrap my head around this, and testing has
confirmed that this patch fixes the problem.  So,

Acked-by: Jeff Moyer <jmoyer@redhat.com>

Better late than never.

-Jeff
