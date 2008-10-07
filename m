Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbYJGGYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbYJGGYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 02:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYJGGYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 02:24:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245AbYJGGYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 02:24:24 -0400
Date: Mon, 6 Oct 2008 23:23:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH, RFC] percpu_counters: make fbc->count read atomic on 32
 bit architecture
Message-Id: <20081006232322.c383fac5.akpm@linux-foundation.org>
In-Reply-To: <E1KmetO-00053M-5u@closure.thunk.org>
References: <E1KmetO-00053M-5u@closure.thunk.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 Oct 2008 21:28:10 -0400 "Theodore Ts'o" <tytso@mit.edu> wrote:

> The following patch has been sitting in the ext4 patch queue for about
> six weeks.  It was there it was a suspected cause for block allocation
> bug.  As I recall, it we found the true root cause since then, but this
> has stuck around since it's a potential problem.  Andrew has expressed
> concerns that this patch might have performance impacts.

Performace impacts I guess we'll just have to put up with.  iirc I was
thinking that this implementation should be pushed down to a kernel-wide
atomic64_t and then the percpu_counters would just use that type.

