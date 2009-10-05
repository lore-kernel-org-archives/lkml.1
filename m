Return-Path: <linux-kernel-owner+w=401wt.eu-S932619AbZJEKul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619AbZJEKul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 06:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932554AbZJEKul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 06:50:41 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:42800 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932537AbZJEKuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 06:50:40 -0400
Date: Mon, 5 Oct 2009 16:19:55 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip] x86: hw-breakpoints: Actually flush thread
	breakpoints in flush_thread().
Message-ID: <20091005104955.GA14852@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20091005102306.GA7889@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091005102306.GA7889@linux-sh.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05, 2009 at 07:23:06PM +0900, Paul Mundt wrote:
> [ I noticed this whilst hacking up SH support, applies to the current
>   tracing/hw-breakpoints topic branch. ]
> 
> flush_thread() tries to do a TIF_DEBUG check before calling in to
> flush_thread_hw_breakpoint() (which subsequently clears the thread flag),
> but for some reason, the x86 code is manually clearing TIF_DEBUG
> immediately before the test, so this path will never be taken.
> 
> This kills off the erroneous clear_tsk_thread_flag() and lets
> flush_thread_hw_breakpoint() actually get invoked.
> 

Yes, this is wrong and we missed it. Thanks for fixing!

> Presumably folks were getting lucky with testing and the
> free_thread_info() -> free_thread_xstate() path was taking care of the
> flush there.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

Acked-by: K.Prasad <prasad@linux.vnet.ibm.com>


