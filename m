Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbZEDWfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbZEDWfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 18:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbZEDWfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 18:35:18 -0400
Received: from smtp-out.google.com ([216.239.33.17]:54932 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbZEDWfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 18:35:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=wN+nPj3j4/slTCsGt/F491PhNZscMey0sfYf+Mx+PMWMacXFDLiB7bcYx4oWh2WN+
	ajVhUtkphQ7I2M8G3PWNg==
Date: Mon, 4 May 2009 15:35:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg KH <greg@kroah.com>
cc: =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, San Mehat <san@android.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: [patch 1/5] oom: cleanup android low memory killer
In-Reply-To: <20090504220905.GA29402@kroah.com>
Message-ID: <alpine.DEB.2.00.0905041529570.2310@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905031305130.18426@chino.kir.corp.google.com> <d6200be20905041448p1ca2d068r5ba8348488842b5c@mail.gmail.com> <20090504220905.GA29402@kroah.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009, Greg KH wrote:

> Are these the patches already in my tree?
> 
> If so, David, just respin your patches against the linux-next tree and
> resend them, that should be sufficient.
> 

This patch in the series is really more of a convenience than anything 
else since it doesn't change anything functionally.  I had to modify the 
lowmemorykiller later because there's a potential for a NULL pointer from 
dereferencing p->mm without holding task_lock(p) and also because I moved 
oomkilladj from struct task_struct to struct mm_struct.

The entire patchset is really based on the move of p->oomkilladj since it 
allows us to prevent an oom killer livelock when killing a task that 
shares memory with an OOM_DISABLE task.  That change obviously has to go 
through Andrew but lowmemorykiller.c must be also be changed accordingly.

I'd be fine with dropping my lowmemorykiller changes if they'd like to fix 
this up themselves.  Otherwise, I need to know the path to which these get 
into the kernel.

> If not, Arve, can you send me your patches first?
> 
> David, in the future, can you cc: me anything under drivers/staging/ so
> that I know to pick the patches up?
> 

Sure.
