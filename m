Return-Path: <linux-kernel-owner+w=401wt.eu-S1762938AbZAOH4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762938AbZAOH4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 02:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbZAOH4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 02:56:33 -0500
Received: from smtp-out.google.com ([216.239.33.17]:60953 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546AbZAOH4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 02:56:32 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=LQO9eIjnbUpStzlntwuEKvlO4o9IFLfdYAeMqsIFaZZCNDsuaM2KmFEgfzsxQkife
	emRwyIG3w7vEkX2j/d+GA==
Date: Wed, 14 Jan 2009 23:55:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Pavel Machek <pavel@suse.cz>, Greg KH <greg@kroah.com>,
       Arve Hj?nnev?g <arve@android.com>, Brian Swetland <swetland@google.com>,
       arve@google.com, San Mehat <san@android.com>,
       Robert Love <rlove@google.com>, linux-kernel@vger.kernel.org
Subject: Re: lowmemory android driver not needed?
In-Reply-To: <20090114104834.18387fca@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.2.00.0901142345330.12065@chino.kir.corp.google.com>
References: <20090114010223.GA21380@kroah.com> <20090114021801.GA14759@bulgaria.corp.google.com> <d6200be20901131830r7103ff8eoe0314f9faf89d89b@mail.gmail.com> <20090114035237.GB16442@kroah.com> <20090114104307.GA20451@elf.ucw.cz>
 <20090114104834.18387fca@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.25.146.36
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009, Alan Cox wrote:

> I was thinking that, and it would integrate better with the OLPC work
> (which IMHO is a nicer interface for some stuff)
> 
> You'd want two thresholds
> 
> The 'arghhhh....' point where you start killing stuff
> The 'uh oh...' point where an OLPC style low memory notifier kicks in
> 
> (OLPC's model is a handle you can select/poll for 'memory getting low' so
> apps can respond to pressure by doing stuff like dumping caches)
> 
> The rest ought to follow naturally IFF you can find a clean efficient way
> to measure that pressure and quantify it as a number. Our default would
> be like now, the Android default might be to trigger earlier..

The /dev/mem_notify patch allowed polling on a system-wide scale for low 
memory conditions so that userspace could respond appropriately: either by 
droping caches, as you mentioned, or sending a signal.  That signal could 
quite possibily be SIGKILL for no better reason than preempting what the 
kernel oom killer would do.

I think this should be completely seperate from the oom killer, which has 
always been a "last resort" to situations where the kernel is completely 
out of memory for a task.

If /dev/mem_notify existed in a cgroup form so that different handlers 
could be responsible for an aggregate of tasks, I think this addresses 
your concerns.  That might require some cleverness in the cgroup 
filesystem code if this would introduce device files, but there are 
probably future use cases for that, as well.
