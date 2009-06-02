Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbZFBOhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbZFBOhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754868AbZFBOhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:37:06 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:59824 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbZFBOhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:37:05 -0400
Date: Tue, 2 Jun 2009 08:59:23 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Move sleeping operations to outside the semaphore.
Message-ID: <20090602135923.GA10208@us.ibm.com>
References: <200906020141.n521faqb003256@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906020141.n521faqb003256@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@i-love.sakura.ne.jp):
> TOMOYO is using rw_semaphore for protecting list elements.
> But TOMOYO is doing operations which might sleep inside down_write().
> This patch makes TOMOYO's sleeping operations go outside down_write().
> 
> Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>

The overall approach (repeated in each stanza) seems safe enough.
Since there are 3 signed-off-by's, I'll assume you've each studied
each one to make sure there are no little little oopses (i.e.
kfreeing the wrong thing or leaking).  So how about for now I'll
give

Acked-by: Serge Hallyn <serue@us.ibm.com>

and when you send a patch with more documentation on Tomoyo, I
will start looking through the locking in more detail and try
to send some patches to standardize it.

Part of why I want to ack this one is it switches to at least
normal kmallocs.  Frankly I'd prefer to skip the rest of the
patchset for now.  Patch 2's been nacked, patch 3 is a lot of
churn for little gain - when a far better patch woudl be one
switching to seq_files.  Patch 4 could in fact be a useful step,
I think.  Patch 5 adds a whole slew of lists that I still don't
like - I'd rather just see a simple patch that adds refcounting
and doesn't do GC yet.

I personally think trying to add GC before standardizing the
locking and refcounting is a bad bad idea.

thanks,
-serge
