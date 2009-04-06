Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbZDFS4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbZDFS4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 14:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbZDFS4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 14:56:16 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:51431 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbZDFS4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 14:56:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qZYDreX9pbaIUPJf0irlWo8vHpFicITlDX1p6UtM1QoO8IL6CdPcb1bHSzvNGW87Xp
         /QsrapExCft28gJrO9O1XQZBCfpFHSVkyOjYP6oh5xntyP++TNb4CWQB/q6eYvbm8NVA
         4BN1svajkPAfKOb5R2hy/+iIU5Oe0qLNsYvOs=
MIME-Version: 1.0
In-Reply-To: <20090118182042.GD30821@kernel.dk>
References: <20090118153221.GA20980@localhost.localdomain>
	 <20090118182042.GD30821@kernel.dk>
Date: Mon, 6 Apr 2009 21:56:12 +0300
X-Google-Sender-Auth: 60b5a7087c029f94
Message-ID: <84144f020904061156t13ad34d7tf579a3c150c16b40@mail.gmail.com>
Subject: Re: [RFC][PATCH] splice: fix deadlock
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Jens Axboe <axboe@suse.de>,
       Eric Dumazet <dada1@cosmosbay.com>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

On Sun, Jan 18 2009, Vegard Nossum wrote:
>> From 8e1d58b03b47d937bc5e53d902bac6e690709034 Mon Sep 17 00:00:00 2001
>> From: Vegard Nossum <vegard.nossum@gmail.com>
>> Date: Sun, 18 Jan 2009 16:07:29 +0100
>> Subject: [PATCH] splice: fix deadlock
>>
>> splice from a file or socket needs to lock both the file/socket and the
>> pipe inodes. pipe_wait() unlocks only the pipe lock, regardless of the
>> order in which they were taken.
>>
>> This patch adds an additional (optional) argument to pipe_wait(); if
>> specified, pipe_wait() will unlock and reacquire both inode locks.
>>
>> It fixes the lockup that occurs with the test-case below, but please
>> review carefully. Consider this patch a proposal rather than a fix.

On Sun, Jan 18, 2009 at 9:20 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> Thanks for the bug report and test case, it is indeed buggy! Good
> spotting. I'll review your patch thoroughly and test it, and then
> integrate your patch.

What's the status of this patch? I don't think it ever got merged to mainline.

                          Pekka
