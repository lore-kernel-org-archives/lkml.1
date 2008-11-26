Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbYKZOjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbYKZOjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 09:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbYKZOjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 09:39:43 -0500
Received: from flusers.ccur.com ([12.192.68.2]:41448 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751276AbYKZOjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 09:39:42 -0500
Date: Wed, 26 Nov 2008 09:39:28 -0500
From: Joe Korty <joe.korty@ccur.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add per-cpu indexing to /proc/timer_list
Message-ID: <20081126143928.GA16576@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20081125224439.GA24042@tsunami.ccur.com> <20081125231445.GA24326@tsunami.ccur.com> <20081126045004.GA3278@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126045004.GA3278@x200.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 07:50:04AM +0300, Alexey Dobriyan wrote:
> On Tue, Nov 25, 2008 at 06:14:45PM -0500, Joe Korty wrote:
> > Per-cpu indexing of /proc/timer_list.
> > 
> > /proc/timer_list, potentially a very large file, is in
> > danger of overflowing its seq_file buffer.  So 'split up'
> > the buffering on cpu ID boundaries.  This should make this
> > file more likely to be useful on largish SMP systems.
> 
> What do you mean?
> 
> You can't overflow seq_file buffer unless kmalloc() will fail large
> allocation. And changing internals doesn't change amount of stuff
> to be shown, which is the only thing which can lead to large buffer
> need.

You're right, I missed the re-malloc part.

Joe
