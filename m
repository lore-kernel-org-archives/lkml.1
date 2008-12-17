Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759352AbYLQIUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbYLQIUe (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 03:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYLQIUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 03:20:24 -0500
Received: from smtp-out.google.com ([216.239.45.13]:30762 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbYLQIUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 03:20:23 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=RUbaGAkHvCOrHW4GQWgjS7XJQ384foAqhZRDhPkaZYhHZ2G26vJlZJAt9fYK1V4+x
	8CSLVnHdbjS5cEiqtvg1g==
MIME-Version: 1.0
In-Reply-To: <b040c32a0812152337r4c708d59q7d71ebbcda8fe05a@mail.gmail.com>
References: <b040c32a0812152337r4c708d59q7d71ebbcda8fe05a@mail.gmail.com>
Date: Wed, 17 Dec 2008 00:20:19 -0800
Message-ID: <b040c32a0812170020x1dae7e11taec8e2f4ff9f06f1@mail.gmail.com>
Subject: Re: [patch] sched: fix uneven per-cpu task_group share distribution
From: Ken Chen <kenchen@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 11:37 PM, Ken Chen <kenchen@google.com> wrote:
> While testing CFS scheduler on linux-2.6-tip tree
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
>
> We found that task which is pinned to a CPU could be starved relative to its
> allocated fair share.

I just want to poke you two to see if you have time to look over this
patch.  There is a real bug in linux-2.6-tip tree.

If I create a CFS cgroup under directory .../parent/cgdir, put one
task under 'parent' with CFS weight 1024, and one task under 'cgdir'
(cgdir has group weight of 1024 also), pin both tasks onto same CPU.
The CPU cycle allocation on these two tasks will be N:1 where N is
number of CPUs in the system.  The expected allocation should be 1:1.

- Ken
