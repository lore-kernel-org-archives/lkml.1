Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbYJGGnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbYJGGnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 02:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbYJGGnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 02:43:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59517 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbYJGGnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 02:43:42 -0400
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit arch
From: Andi Kleen <andi@firstfloor.org>
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2>
Date: Tue, 07 Oct 2008 08:43:39 +0200
In-Reply-To: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2> (Hisashi Hifumi's message of "Tue, 07 Oct 2008 14:07:23 +0900")
Message-ID: <87hc7onbvo.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> writes:

> Hi Andrew.
>
> Currently reading or writing file->f_pos is not atomic on 32bit environment,
> so two or more simultaneous access can corrupt file->f_pos value.
> There are some past discussions about this issue, but this is not fixed yet.
> http://marc.info/?l=linux-kernel&m=120764199819899&w=2
> http://marc.info/?l=linux-kernel&m=114490379102476&w=2

Have you benchmarked if cmpxchg is cheaper than the seqlock?  It's not
clear to me a seqlock is really the right locking primitive for
this. Normally seqlocks should be used when reading is much more
frequent than writing, but it's doubtful that this is actually the
case for f_pos.

-Andi

-- 
ak@linux.intel.com
