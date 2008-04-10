Return-Path: <linux-kernel-owner+w=401wt.eu-S1759228AbYDJWS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759228AbYDJWS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 18:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYDJWSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 18:18:50 -0400
Received: from tim.rpsys.net ([194.106.48.114]:40398 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbYDJWSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 18:18:49 -0400
Subject: Re: [PATCH] lzo: fix possible typo in decompresor
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.00.0804101346240.3143@woody.linux-foundation.org>
References: <1207859903.22001.36.camel@brick>
	 <alpine.LFD.1.00.0804101346240.3143@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 10 Apr 2008 23:18:08 +0100
Message-Id: <1207865888.4969.103.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-10 at 13:49 -0700, Linus Torvalds wrote:
> On Thu, 10 Apr 2008, Harvey Harrison wrote:
> >
> > Shift of a le value seems strange, probably meant to shift the cpu-order
> > variable as in the prvious section of the switch statement.
> 
> Hmm. This patch looks ObviouslyCorrect(tm), but it worries me that 
> apparently the old broken code has been around since last July, and afaik 
> it can never have worked on big-endian machines.
> 
> So did nobody ever use it, or why hasn't this ever triggered? How did you 
> find this? A sparse warning?

The heaviest users of the lzo code I know of are little-endian ARM
devices through jffs2. When the code was merged there was a lot of
discussion about the best way to handle the endian issues and unaligned
accesses and whilst I seem to remember someone posting big-endian test
results it could have been before some of the later changes were made.

So yes its possible its not been run on BE until now or that isn't a
common code path. I've checked this against the external LZO library its
based on and the patch is correct

Acked-by: Richard Purdie <rpurdie@rpsys.net>

-- 
Richard


