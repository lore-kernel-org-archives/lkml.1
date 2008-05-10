Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbYEJVvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbYEJVvZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 17:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbYEJVvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 17:51:18 -0400
Received: from smtp2.sssup.it ([193.205.80.100]:50015 "EHLO smtp2.sssup.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbYEJVvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 17:51:17 -0400
Date: Sat, 10 May 2008 23:56:18 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: Matthew <jackdachef@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jens.axboe@oracle.com
Subject: Re: performance "regression" in cfq compared to anticipatory, deadline and noop
Message-ID: <20080510215618.GB78758@gandalf.sssup.it>
References: <e85b9d30805101218u4b8f0c2bw47af2384133a5c77@mail.gmail.com> <20080510200053.GA78555@gandalf.sssup.it> <e85b9d30805101339je48a55dnd2fbd5601c27a3be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e85b9d30805101339je48a55dnd2fbd5601c27a3be@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Matthew <jackdachef@gmail.com>
> Date: Sat, May 10, 2008 10:39:50PM +0200
>
> > 2) Does using a bigger value of slice_idle increase the throughput?
> >
> 
> Hi,
> 
> 2) a bigger value even made it worse, setting it to "0" however
> seemingly "fixed" it, I however don't know how the overall
> effect/impact is, this will need some more real-world testing ;)
> 

Well, it's not a fix... the overall effect is that you should end
up with more seeks (and so reduced throughput) on loads consisting
of more than one process, and at least one of those processes is a
synchronous sequential reader.


> one side-node / question:
> 
> will this cause more wakeups on the cpu and/or decrease battery
> runtime on, e.g. laptops ?
> 

I don't know the overall effect on battery life, btw with no idling
you have one less timer active in the system (that however, depending
on the load, does not fire frequently) and more continuous disk
activity.
