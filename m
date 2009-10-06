Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbZJFHMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbZJFHMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 03:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbZJFHMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 03:12:39 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47698 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbZJFHMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 03:12:39 -0400
Date: Tue, 6 Oct 2009 09:12:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: bug in elevator/cfq regarding start_time?
Message-ID: <20091006071202.GC5216@kernel.dk>
References: <4e5e476b0910041354o54c95626g974264976adaf53c@mail.gmail.com> <20091004205955.GM26573@kernel.dk> <4e5e476b0910050808k3a26aad8r19a145fc60e1da6b@mail.gmail.com> <4e5e476b0910051326g559bf135ma3cf82219ade497@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0910051326g559bf135ma3cf82219ade497@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05 2009, Corrado Zoccolo wrote:
> On Mon, Oct 5, 2009 at 5:08 PM, Corrado Zoccolo <czoccolo@gmail.com> wrote:
> > On Sun, Oct 4, 2009 at 10:59 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> >> Good spotting! So we can either add the same copy in cfq, or we can just
> >> move the ->start_time check and assignment in attempt_merge() to post
> >> the elv_merge_requests() call. I think the latter would work fine, but
> >> I'll check and fix tomorrow.
> >
> > I think there is still something buggy regarding those timestamps.
> False alarm. I just found that the list was not yet filled at that
> place in the code.

OK, it did look a bit puzzling. FWIW, this is what I committed
yesterday:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=30996f40bffe73f05abb92a4cec254befa8cecf7

-- 
Jens Axboe

