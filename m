Return-Path: <linux-kernel-owner+w=401wt.eu-S1762231AbYDSSrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762231AbYDSSrj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 14:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbYDSSrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 14:47:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:59332 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054AbYDSSrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 14:47:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B7Ug13St72pPLXqx1LyiJ3O6Q6nWHl8pgFthKso55A1WRiPK2zvRfUNw65h6JuTND3tMoX87sjGpBn+gDWuWn/FRJe7QtLcXh4l4gggMeQseKRspodgUzE/E/5cd2lj62DPFTlfK3V+nYEq44M7ykIogl1bBYviAJIw0ZjSkCK0=
Message-ID: <3d8471ca0804191147q3af7f01ei86b23b75bd0eb559@mail.gmail.com>
Date: Sat, 19 Apr 2008 20:47:21 +0200
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [git pull] scheduler changes for v2.6.26
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080419181304.GB21353@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080419181304.GB21353@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/08, Ingo Molnar <mingo@elte.hu> wrote:
>  Guillaume Chazarain (1):
>       sched: fix rq->clock overflows detection with CONFIG_NO_HZ

This one should have been dropped (per http://lkml.org/lkml/2008/1/25/413)
I don't like rq->clock relying on jiffies, and you already fixed the
original manifestation of the problem in:

commit 2997c8c4a0b179e8b834a7f30ba4323f2c60ccf4
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Jan 11 13:35:54 2008 +0100

    block: fix blktrace timestamps

    David Dillow reported broken blktrace timestamps. The reason
    is cpu_clock() which is not a global time source.

    Fix bkltrace timestamps by using ktime_get() like the networking
    code does for packet timestamps. This also removes a whole lot
    of complexity from bkltrace.c and shrinks the code by 500 bytes:

       text    data     bss     dec     hex filename
       2888     124      44    3056     bf0 blktrace.o.before
       2390     116      44    2550     9f6 blktrace.o.after

    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>


-- 
Guillaume
