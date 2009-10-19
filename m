Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbZJSIZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbZJSIZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 04:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755743AbZJSIZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 04:25:53 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40345 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572AbZJSIZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 04:25:52 -0400
Date: Mon, 19 Oct 2009 10:25:56 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PATCH: sendfile() checks f_op.sendpage() instead of
	f_op.splice_write()  wrongly
Message-ID: <20091019082556.GV20961@kernel.dk>
References: <4ADC1BAE.9060508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADC1BAE.9060508@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19 2009, Changli Gao wrote:
> sendfile(2) checks f_op.sendpage() instead of f_op.splice_write() wrongly.
> 
> sendfile(2) was reworked with the splice infrastructure, but it still
> checks f_op.sendpage() instead of f_op.splice_write() wrongly. Although
> if f_op.sendpage() exists, f_op.splice_write() always exists at the same
> time currently, the assumption will be broken in future silently. This
> patch also brings a side effect: sendfile(2) can work with any output
> file, which supports splice_write() not only mmap(2).

Question is, if the check should just be dropped completely, since we
use fallback default handlers if the fs doesn't have
->splice_read/->splice_write().

-- 
Jens Axboe

