Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249AbYJGKOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbYJGKOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbYJGKOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:14:21 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:57871 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbYJGKOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:14:20 -0400
Message-Id: <6.0.0.20.2.20081007183452.0f052210@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Tue, 07 Oct 2008 19:11:26 +0900
To: Andi Kleen <andi@firstfloor.org>
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on
  32bit arch
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <87hc7onbvo.fsf@basil.nowhere.org>
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2>
 <87hc7onbvo.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


At 15:43 08/10/07, Andi Kleen wrote:
>Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> writes:
>
>> Hi Andrew.
>>
>> Currently reading or writing file->f_pos is not atomic on 32bit environment,
>> so two or more simultaneous access can corrupt file->f_pos value.
>> There are some past discussions about this issue, but this is not fixed yet.
>> http://marc.info/?l=linux-kernel&m=120764199819899&w=2
>> http://marc.info/?l=linux-kernel&m=114490379102476&w=2
>
>Have you benchmarked if cmpxchg is cheaper than the seqlock?  It's not
>clear to me a seqlock is really the right locking primitive for
>this. Normally seqlocks should be used when reading is much more
>frequent than writing, but it's doubtful that this is actually the
>case for f_pos.

Maybe cmpxchg8b is good for i486 or later x86, but i386 or other architectures
that do not have similar instruction needs some locking primitive. I think lazy
seqlock is one option for making file->f_pos access atomic.

