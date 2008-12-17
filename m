Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759440AbYLQIe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbYLQIe1 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 03:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYLQIeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 03:34:16 -0500
Received: from viefep13-int.chello.at ([62.179.121.33]:10039 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751745AbYLQIeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 03:34:16 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [patch] sched: fix uneven per-cpu task_group share distribution
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ken Chen <kenchen@google.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <b040c32a0812170020x1dae7e11taec8e2f4ff9f06f1@mail.gmail.com>
References: <b040c32a0812152337r4c708d59q7d71ebbcda8fe05a@mail.gmail.com>
	 <b040c32a0812170020x1dae7e11taec8e2f4ff9f06f1@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 17 Dec 2008 09:34:11 +0100
Message-Id: <1229502851.9487.43.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-17 at 00:20 -0800, Ken Chen wrote:
> On Mon, Dec 15, 2008 at 11:37 PM, Ken Chen <kenchen@google.com> wrote:
> > While testing CFS scheduler on linux-2.6-tip tree
> > git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
> >
> > We found that task which is pinned to a CPU could be starved relative to its
> > allocated fair share.
> 
> I just want to poke you two to see if you have time to look over this
> patch.  There is a real bug in linux-2.6-tip tree.
> 
> If I create a CFS cgroup under directory .../parent/cgdir, put one
> task under 'parent' with CFS weight 1024, and one task under 'cgdir'
> (cgdir has group weight of 1024 also), pin both tasks onto same CPU.
> The CPU cycle allocation on these two tasks will be N:1 where N is
> number of CPUs in the system.  The expected allocation should be 1:1.

right - it was on the todo list, let me stare at it a little..

