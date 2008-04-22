Return-Path: <linux-kernel-owner+w=401wt.eu-S1759245AbYDVUGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245AbYDVUGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYDVUGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:06:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:51014 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbYDVUGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:06:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=rXe/Qu+LJBC7l0txaejeqeT8o5qOF8kp82HjB64dhzYm2jJfNCnfoxriluZ7YaSTYESyGZUQGxWdRRq80mPBPg9eWnAO8PdM/rqBZpQQiaT7nseVp5I2TX+GFwhS1//2t4JTTFtvgXxaDkmiWlJxMHEB2SPV4F+lcvNIzDUODc4=
Date: Wed, 23 Apr 2008 01:01:30 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Nadia.Derbey@bull.net, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, orenl@cs.columbia.edu,
       nick@nick-andrew.net
Subject: Re: Checkpoint/restart (was Re: [PATCH 0/4] - v2 -  Object
	creation with a specified id)
Message-ID: <20080422210130.GA15937@martell.zuzino.mipt.ru>
References: <20080418054459.891481000@bull.net> <20080422193612.GA15835@martell.zuzino.mipt.ru> <1208890580.17117.14.camel@nimitz.home.sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208890580.17117.14.camel@nimitz.home.sr71.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 11:56:20AM -0700, Dave Hansen wrote:
> On Tue, 2008-04-22 at 23:36 +0400, Alexey Dobriyan wrote:
> > On Fri, Apr 18, 2008 at 07:44:59AM +0200, Nadia.Derbey@bull.net wrote:
> > >    . echo "LONG XX" > /proc/self/task/<my_tid>/next_id
> > >      next object to be created will have an id set to XX
> > >    . echo "LONG<n> X0 ... X<n-1>" > /proc/self/task/<my_tid>/next_id
> > >      next object to be created will have its ids set to XX0, ... X<n-1>
> > >      This is particularly useful for processes that may have several ids if
> > >      they belong to nested namespaces.
> > 
> > Can we answer the following questions before merging this patch:
> > 
> > a) should mainline kernel have checkpoint/restart feature at all
> > b) if yes, should it be done from kernel- or userspace?
> > 
> > Until agreement will be "yes/from userspace" such patches don't make
> > sense in mainline.
> 
> What do you mean by "from kernel" or "from userspace"?

By "from userspace" I mean proposed interfaces and similar: usespace by
special system calls puts some state of future object and then does
normal system call which creates aforementioned object.

This can be used for PIDs, OK.

This can be used for SystemV shmem ids. But SystemV shmem also has
(let's choose) uid/gid, atimes and actual content. How would restoration
look like?

How to restore struct task_struct::did_exec ? Do execve(2)?

A was ptracing B at checkpoint moment...

Netdevices: stats, name, all sorts of flags, hw addresses, MTU

iptables rules.

These next ids are suitable, well, only for ids which is very, very small
part of kernel state needed to restore group of processes.

> Userspace has to be involved somewhere, right?  It at least need to open()
> the checkpoint file and pass it into the kernel.  		

Sure, but opening dumpfile is not an interesting part.

