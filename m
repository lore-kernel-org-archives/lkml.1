Return-Path: <linux-kernel-owner+w=401wt.eu-S1761335AbZJMVDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761335AbZJMVDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 17:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761326AbZJMVDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 17:03:24 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:5510 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761320AbZJMVDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 17:03:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lsg0Jpw7F6d0WP1AUEYDA6qcBk/36yGlmpkADavT+CW1zEc+2y4BVmZl6Lht0gbp1t
         dKpCJRXBlxx6R0k0vyaHuBqxRUWIXt8T0SUmb6/D3snlfHRJNXZEtkYcSCZI6ON1V0iC
         UDkxVS8MIurbRMBiOAvMHCqgu3SVdV1fcy168=
Date: Tue, 13 Oct 2009 23:02:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 1/5] [PATCH 1/5] function-graph/x86: replace unbalanced
	ret with jmp
Message-ID: <20091013210208.GB5135@nowhere>
References: <20091013203349.814936710@goodmis.org> <20091013203425.042034383@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013203425.042034383@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 04:33:50PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The function graph tracer replaces the return address with a hook to
> trace the exit of the function call. This hook will finish by returning
> to the real location the function should return to.
> 
> But the current implementation uses a ret to jump to the real return
> location. This causes a imbalance between calls and ret. That is
> the original function does a call, the ret goes to the handler
> and then the handler does a ret without a matching call.
> 
> Although the function graph tracer itself still breaks the branch
> predictor by replacing the original ret, by using a second ret and
> causing an imbalance, it breaks the predictor even more.



I have troubles to understand by it breaks the predictor, especially
since there is not conditional branch in return_to_handler.
But still I don't understand why a ret would break more the branch
prediction than a jmp.

