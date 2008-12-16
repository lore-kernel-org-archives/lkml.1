Return-Path: <linux-kernel-owner+w=401wt.eu-S1756308AbYLPLQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbYLPLQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbYLPLQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:16:03 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:65481 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931AbYLPLQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:16:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=DuIYH0P94z0ylxGrVVSjtgRYnc+G05zigqZXXp/IAb6CbLIoT1ckIhErVrkke5fULG
         65sDyPpcN59UDTN2yE3dNKJzC0hX5GGZ89dvaUzEeLFAZ5/vU3xSpl2M1vvPw0dhuBFn
         rQb3NI014IwH6Chp+BSnt4ciNZLc3c/Xs1mG8=
Message-ID: <2f11576a0812160315g3dea988ayfadba2117e172a2c@mail.gmail.com>
Date: Tue, 16 Dec 2008 20:15:58 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [mmotm and linux-next][PATCH] irq: enclose irq_desc_lock_class in CONFIG_LOCKDEP
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>
In-Reply-To: <20081216102340.GA1003@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081216170635.DBB8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081216003428.43d37b6b.akpm@linux-foundation.org>
	 <20081216101827.GB27481@elte.hu> <20081216102340.GA1003@elte.hu>
X-Google-Sender-Auth: 86cc52a5ed563563
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>> > No, lockdep.h (which we forgot to include) already handles that:
>> >
>> > # define lockdep_set_class(lock, key)               do { (void)(key); } while (0)
>> >
>> > the problem is that the code which references irq_desc_lock_class is
>> > inside #ifdef CONFIG_SPARSE_IRQ, so this is a better fix:
>>
>> agreed that this is the better fix - applied to tip/irq/sparseirq,
>> thanks!
>
> actually, this breaks the build on !SPARSEIRQ because we will use that
> class in the non-sparseirq case. So we've converted a build warning to a
> build failure ;-)

Please give me your .config and tell me your arch.
my ia64 box (ia64 is !SPARSEIRQ) can build the akpm patch.
