Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbZEDXTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbZEDXTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 19:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbZEDXTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 19:19:39 -0400
Received: from kroah.org ([198.145.64.141]:51790 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953AbZEDXTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 19:19:38 -0400
Date: Mon, 4 May 2009 16:16:26 -0700
From: Greg KH <greg@kroah.com>
To: David Rientjes <rientjes@google.com>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, San Mehat <san@android.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: [patch 1/5] oom: cleanup android low memory killer
Message-ID: <20090504231626.GA27123@kroah.com>
References: <alpine.DEB.2.00.0905031305130.18426@chino.kir.corp.google.com> <d6200be20905041448p1ca2d068r5ba8348488842b5c@mail.gmail.com> <20090504220905.GA29402@kroah.com> <alpine.DEB.2.00.0905041529570.2310@chino.kir.corp.google.com> <20090504225936.GA9876@kroah.com> <alpine.DEB.2.00.0905041607170.6073@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905041607170.6073@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 04:12:57PM -0700, David Rientjes wrote:
> On Mon, 4 May 2009, Greg KH wrote:
> 
> > > This patch in the series is really more of a convenience than anything 
> > > else since it doesn't change anything functionally.  I had to modify the 
> > > lowmemorykiller later because there's a potential for a NULL pointer from 
> > > dereferencing p->mm without holding task_lock(p) and also because I moved 
> > > oomkilladj from struct task_struct to struct mm_struct.
> > 
> > Is this still the case on top of Arve's changes?
> > 
> 
> Yeah, the first of two patches Arve just sent is broken:

Ok, care to work with Arve to come up with a series that both of you
agree will work properly?

> > Right now, people are still arguing that the android low memory driver
> > is not needed, but something is, yet no one has proposed a viable
> > solution for all parties :(
> > 
> 
> There was an interest in a low mem userspace notifier that applications 
> can poll() on at configurable low mem levels to react accordingly.  This 
> would probably address the problem that the Android team is trying to fix.

Yes, I think it would.

> Regardless, my patchset includes two fixes for current bugs in the oom 
> killer: a possible NULL pointer when /proc/sys/vm/oom_dump_tasks is 
> enabled and a possible livelock when killing a task that shares memory 
> with an OOM_DISABLE task.  I'm not really interested in seeing who can get 
> their patches into the staging tree first, I'm more concerned about fixing 
> the oom killer.

Agreed, working with Arve on this would be most appreciated.

thanks,

greg k-h
