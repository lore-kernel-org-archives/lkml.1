Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbXKSH4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbXKSH4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 02:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbXKSH4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 02:56:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56671 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbXKSH4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 02:56:41 -0500
Date: Mon, 19 Nov 2007 08:56:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc2-mm1: kcryptd vs lockdep
Message-ID: <20071119075627.GB28432@elte.hu>
References: <64bb37e0711182323v1e2a1341tfc7f20df771b988@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0711182323v1e2a1341tfc7f20df771b988@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Torsten Kaiser <just.for.lkml@googlemail.com> wrote:

> Trying the last NFSv4 patch (but that patch is only the cause, why I
> had lockdep enabled) I got this:
> [   64.550203]
> [   64.550205] =========================
> [   64.552213] [ BUG: held lock freed! ]
> [   64.553633] -------------------------
> [   64.555055] kcryptd/1022 is freeing memory
> FFFF81011EBEFB00-FFFF81011EBEFB3F, with a lock still held there!

so kcryptd frees a live, still in use bio? That could be a receipe for 
data corruption. Does SLUB_DEBUG (or SLAB_DEBUG) catch anything?

	Ingo
