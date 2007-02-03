Return-Path: <linux-kernel-owner+w=401wt.eu-S1946421AbXBCJjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946421AbXBCJjN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 04:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946422AbXBCJjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 04:39:13 -0500
Received: from waste.org ([66.93.16.53]:43450 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946421AbXBCJjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 04:39:12 -0500
Date: Sat, 3 Feb 2007 03:25:40 -0600
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070203092540.GH16722@waste.org>
References: <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org> <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org> <20070202222110.GA1212@elte.hu> <Pine.LNX.4.64.0702021445410.15057@woody.linux-foundation.org> <20070202235531.GA18904@elte.hu> <Pine.LNX.4.64.0702021636410.15057@woody.linux-foundation.org> <20070203082308.GA6748@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070203082308.GA6748@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 03, 2007 at 09:23:08AM +0100, Ingo Molnar wrote:
> The normal and most optimal workflow should be a user-space ring-buffer 
> of these constant-size struct async_syscall entries:
> 
>   struct async_syscall ringbuffer[1024];
> 
>   LIST_HEAD(submitted);
>   LIST_HEAD(pending);
>   LIST_HEAD(completed);

It's wrong to call this a ring buffer as things won't be completed in
any particular order. So you'll need a fourth list head for which
buffer elements are free. At which point, you might as well leave it
entirely up to the application to manage the allocation of
async_syscall structs. It may know it only needs two, or ten thousand,
or five per client...

-- 
Mathematics is the supreme nostalgia of our time.
