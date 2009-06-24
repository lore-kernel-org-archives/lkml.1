Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbZFXKJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbZFXKJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 06:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZFXKJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 06:09:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:39144 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbZFXKJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 06:09:04 -0400
Subject: Re: [PATCH] [JFFS2] jffs2_start_garbage_collect_thread() return
 value cleanup
From: David Woodhouse <dwmw2@infradead.org>
To: Gerard Lledo <gerard.lledo@gmail.com>
Cc: akpm@linux-foundation.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1243944686-7039-2-git-send-email-gerard.lledo@gmail.com>
References: <20090602113216.GA3513@tank>
	 <1243944686-7039-1-git-send-email-gerard.lledo@gmail.com>
	 <1243944686-7039-2-git-send-email-gerard.lledo@gmail.com>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 11:09:01 +0100
Message-Id: <1245838141.25547.5207.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-02 at 15:11 +0300, Gerard Lledo wrote:
> There is no user of this return value in the kernel.  Change it to return void
> instead.

NAK. I hate this type of patch.

A function _should_ return an error value indicating success or failure,
if there's _any_ chance that it (or a future rewrite of it) may fail.

It's up to the _callers_ to act on that result, or not, as they see fit.

If you don't do that, you end up with whole stacks of functions which
neither handle nor propagate errors -- and it's a _complete_ pain when
you later find that you _do_ have to make one of the innermost functions
return an error.

Gerard, if you persist in sending this kind of patch, please could I ask
you to send me a cloth doll of yourself? I would like to stick pins in
it next time I have to retrofit error handling to a stack of functions
that lack it.

It's not even as if this patch is going to give any real performance
improvement. It's a single register load in a once-per-mount code path.

There _may_ be some places where this kind of patch is reasonable -- but
the commit comment should have a clear explanation of why the return
value will _never_ be needed, rather than merely observing that it is
not _currently_ used. Or show that there is a _significant_ improvement
obtained by doing so, perhaps.

Andrew, may I suggest that you look for such justification in future
patches of this type?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


