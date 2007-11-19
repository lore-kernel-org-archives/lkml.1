Return-Path: <linux-kernel-owner+w=401wt.eu-S1754368AbXKSVBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbXKSVBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 16:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbXKSVBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 16:01:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbXKSVBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 16:01:34 -0500
Message-ID: <4741F97D.6090808@redhat.com>
Date: Mon, 19 Nov 2007 22:00:45 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Alasdair G Kergon <agk@redhat.com>
Subject: Re: 2.6.24-rc2-mm1: kcryptd vs lockdep
References: <64bb37e0711182323v1e2a1341tfc7f20df771b988@mail.gmail.com>	 <20071119075627.GB28432@elte.hu> <64bb37e0711191134l6dac07a2ie3b4258c43e1f1f0@mail.gmail.com>
In-Reply-To: <64bb37e0711191134l6dac07a2ie3b4258c43e1f1f0@mail.gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Torsten Kaiser wrote:
> On Nov 19, 2007 8:56 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> * Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
...
> Above this acquire/release sequence is the following comment:
> #ifdef CONFIG_LOCKDEP
>                 /*
>                  * It is permissible to free the struct work_struct
>                  * from inside the function that is called from it,
>                  * this we need to take into account for lockdep too.
>                  * To avoid bogus "held lock freed" warnings as well
>                  * as problems when looking into work->lockdep_map,
>                  * make a copy and use that here.
>                  */
>                 struct lockdep_map lockdep_map = work->lockdep_map;
> #endif
> 
> Did something trigger this anyway?
> 
> Anything I could try, apart from more boots with slub_debug=F?

Please could you try which patch from the dm-crypt series cause this ?
(agk-dm-dm-crypt* names.)

I suspect agk-dm-dm-crypt-move-bio-submission-to-thread.patch because
there is one work struct used subsequently in two threads...
(io thread already started while crypt thread is processing lockdep_map
after calling f(work)...)

(btw these patches prepare dm-crypt for next patchset introducing 
async cryptoapi, so there should be no functional changes yet.)

Milan
--
mbroz@redhat.com


