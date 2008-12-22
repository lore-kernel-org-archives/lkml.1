Return-Path: <linux-kernel-owner+w=401wt.eu-S1752665AbYLVATy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbYLVATy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 19:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbYLVATr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 19:19:47 -0500
Received: from ozlabs.org ([203.10.76.45]:33337 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbYLVATq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 19:19:46 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: per-cpu stats in block device: overkill?
Date: Mon, 22 Dec 2008 10:49:43 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812221049.43884.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens, Tejun, Jerome,

  I've been auditing alloc_per_cpu users, and got to genhd.  The code is fairly complex, but I can't help wondering if per-cpu counters are overkill.  After all, we have a single queue lock.

  The reason I care is that I'm changing alloc_per_cpu to use the static per-cpu area: at 40/80 bytes (32/64 bit) per stat, we'd be restricted to a few hundred disks unless the percpu area is enlarged (in current patches, a cmdline param).  Or, I can change genhd to use big_percpu_alloc which will use the current inefficient dynamic per-cpu system until we get dynamic per-cpu regions (if ever).

Cheers,
Rusty.
