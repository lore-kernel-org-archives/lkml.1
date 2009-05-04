Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbZEDXDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbZEDXDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 19:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZEDXDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 19:03:15 -0400
Received: from kroah.org ([198.145.64.141]:42275 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117AbZEDXDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 19:03:14 -0400
Date: Mon, 4 May 2009 15:59:36 -0700
From: Greg KH <greg@kroah.com>
To: David Rientjes <rientjes@google.com>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, San Mehat <san@android.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: [patch 1/5] oom: cleanup android low memory killer
Message-ID: <20090504225936.GA9876@kroah.com>
References: <alpine.DEB.2.00.0905031305130.18426@chino.kir.corp.google.com> <d6200be20905041448p1ca2d068r5ba8348488842b5c@mail.gmail.com> <20090504220905.GA29402@kroah.com> <alpine.DEB.2.00.0905041529570.2310@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905041529570.2310@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 03:35:08PM -0700, David Rientjes wrote:
> On Mon, 4 May 2009, Greg KH wrote:
> 
> > Are these the patches already in my tree?
> > 
> > If so, David, just respin your patches against the linux-next tree and
> > resend them, that should be sufficient.
> > 
> 
> This patch in the series is really more of a convenience than anything 
> else since it doesn't change anything functionally.  I had to modify the 
> lowmemorykiller later because there's a potential for a NULL pointer from 
> dereferencing p->mm without holding task_lock(p) and also because I moved 
> oomkilladj from struct task_struct to struct mm_struct.

Is this still the case on top of Arve's changes?

> The entire patchset is really based on the move of p->oomkilladj since it 
> allows us to prevent an oom killer livelock when killing a task that 
> shares memory with an OOM_DISABLE task.  That change obviously has to go 
> through Andrew but lowmemorykiller.c must be also be changed accordingly.
> 
> I'd be fine with dropping my lowmemorykiller changes if they'd like to fix 
> this up themselves.  Otherwise, I need to know the path to which these get 
> into the kernel.

Right now, people are still arguing that the android low memory driver
is not needed, but something is, yet no one has proposed a viable
solution for all parties :(

thanks,

greg k-h
