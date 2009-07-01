Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbZGAHiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbZGAHiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZGAHiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:38:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48395 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbZGAHiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:38:05 -0400
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
From: Andi Kleen <andi@firstfloor.org>
References: <20090701.152115.706994265076015808.mitake@dcl.info.waseda.ac.jp>
Date: Wed, 01 Jul 2009 09:38:04 +0200
In-Reply-To: <20090701.152115.706994265076015808.mitake@dcl.info.waseda.ac.jp> (Hitoshi Mitake's message of "Wed, 01 Jul 2009 15:21:15 +0900 (JST)")
Message-ID: <87hbxwj1k3.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> writes:

> Hi,
>
> I wrote a test patch which add information of counts processes acquired how many spinlocks to schedstat.
> After applied this patch, /proc/<PID>/sched will change like this,

The problem is that spinlocks are very common and schedstats is enabled commonly
in production kernels. You would need to demonstrate that such a change doesn't
have significant performance impact. For me it looks like it has.

Also I'm not sure exactly what good such a metric is. Do you have 
a concrete use case?

The normal way to check for lock contention or lock bouncingis to
simply profile cycles or time and see if there is a lot of CPU time in
locks.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
