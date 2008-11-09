Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbYKISF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbYKISF3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 13:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbYKISFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 13:05:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:38752 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbYKISFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 13:05:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BVdIwuJZNhD4ErUFH39M5BcZIqzQdTvCO15ZBU1WwJP22y5h6GHj3jPt+VR/Oxohl4
         MEax/NQvErl5SIoI/36wd3psYV2cvYrasVV2vENQjYtfmLUWS4b1loFxf+jg8R2e6qKy
         N59r7+tl/MmqTnRKQgrWSdMnPV01TUN3X3FEI=
Date: Sun, 9 Nov 2008 21:08:41 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ken Chen <kenchen@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
Message-ID: <20081109180841.GB3127@x200.localdomain>
References: <20081106203520.GD3578@elte.hu> <20081107003021.GA18666@google.com> <20081107004824.GA28780@x200.localdomain> <20081107074147.GA26607@elte.hu> <20081107075925.GA1825@elte.hu> <20081107082003.GA15800@x200.localdomain> <20081107083249.GD4435@elte.hu> <b040c32a0811071038g5e6faba6n55b22e52e1d2ea98@mail.gmail.com> <20081108121054.GG8354@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081108121054.GG8354@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2008 at 01:10:54PM +0100, Ingo Molnar wrote:
> Sidenote: it would still be nice if the procfs folks converted the 
> old-style code there to the new seqfile APIs, before requiring 
> everyone _else_ to follow those guidelines?

For every existing non seqfile /proc file, there may be (and was demonstrated)
some userspace which is doing pread(2) on it and seqfiles don't support pread
currently. Obviously, no such userspace exist for /proc/*/stack.
