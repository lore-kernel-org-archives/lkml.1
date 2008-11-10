Return-Path: <linux-kernel-owner+w=401wt.eu-S1753744AbYKJXz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbYKJXz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 18:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbYKJXyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 18:54:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753531AbYKJXyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 18:54:54 -0500
Date: Mon, 10 Nov 2008 15:54:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: adobriyan@gmail.com, kenchen@google.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
Message-Id: <20081110155410.be7552e3.akpm@linux-foundation.org>
In-Reply-To: <20081107092902.GB7787@elte.hu>
References: <20081107003021.GA18666@google.com>
	<20081107004824.GA28780@x200.localdomain>
	<20081107074147.GA26607@elte.hu>
	<20081107075925.GA1825@elte.hu>
	<20081107082003.GA15800@x200.localdomain>
	<20081107083249.GD4435@elte.hu>
	<20081107084943.GA16147@x200.localdomain>
	<20081107085352.GA27245@elte.hu>
	<20081107090304.GA30540@elte.hu>
	<20081107011659.98d3788a.akpm@linux-foundation.org>
	<20081107092902.GB7787@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008 10:29:02 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> > I guess the 0400 mode on that file will suffice...
> 
> correct, 0400 is used already in the present patch:
> 
>  phoenix:~> cat /proc/1/stack
>  cat: /proc/1/stack: Permission denied
> 
> but that is _not_ enough, it should be narrowed even more, to the 
> boundaries that i pointed out in my first review feedback mail, and 
> which is not implemented yet:
> 
>  1) only root should be allowed to do this - i.e. file needs to be 
>     root-owned.
> 
>  2) there also needs to be a .config entry for folks to be able to
>     turn it off altogether - just like folks can turn off sysrq-t 
>     dumping via the .config.

Doing the above is desirable for another reason: given our rather
erratic history with the stack backtracer, this /proc file is possibly
a convenient way of oopsing the kernel, sending of off into la-la-land, etc.

