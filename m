Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbZBDLVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbZBDLVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 06:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZBDLVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 06:21:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33527 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbZBDLVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 06:21:32 -0500
Subject: Re: [PATCH 2/2] posix-cpu-timers: use ->sighand instead of
 ->signal to check the task is alive
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Lin Ming <ming.m.lin@intel.com>, Roland McGrath <roland@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090203231717.GA5028@redhat.com>
References: <20090203231717.GA5028@redhat.com>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 12:21:19 +0100
Message-Id: <1233746479.5076.6.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 00:17 +0100, Oleg Nesterov wrote:
> Sadly, it is not trivial to audit kernel/posix-cpu-timers.c, but it really
> abuses tasklist_lock. I believe it doesn't need this lock at all, but the
> changes are not easy to test.

It uses that to hold of task reaping so ->signal doesn't go away.

If we make ->signal refcountable, and rcu freed along with the tasks I
think we can get away without tasklist_lock.

