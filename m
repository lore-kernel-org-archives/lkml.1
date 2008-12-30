Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbYL3IOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbYL3IOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 03:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbYL3IO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 03:14:27 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:60832 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbYL3IOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 03:14:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BuKizrB6j3A1POne/eFRZgaZ+Y+26/XwyNfsPb1S4wio7e3ctkCo4JgVW0RSsP+PP9
         L2bripRejJ6X1N7pRmmgvHT2+HKz/F9W4gfQcab0xUN/fNbmj9o4TRa2F5sXjyPyKoSP
         1454wA7xHpLJK42r12OyqHt+QFZVt05f+Kxpg=
Date: Tue, 30 Dec 2008 10:14:45 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] RCU: Don't include unnecessary headers, allow
	kmemtrace w/ tracepoints.
Message-ID: <20081230081445.GC10635@localhost>
References: <cover.1230622068.git.eduard.munteanu@linux360.ro> <86493e5e7b0a47e8acf0350a87ab3f22633a5789.1230622069.git.eduard.munteanu@linux360.ro> <20081230074952.GA5482@elte.hu> <20081230075337.GA9594@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081230075337.GA9594@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 08:53:37AM +0100, Ingo Molnar wrote:
> hm, there are quite a few such dependencies it appears, for example:
> 
> In file included from init/do_mounts_initrd.c:4:
> include/linux/fs.h: In function 'alloc_secdata':
> include/linux/fs.h:2214: error: implicit declaration of function 'get_zeroed_page'
> include/linux/fs.h:2214: error: 'GFP_KERNEL' undeclared (first use in this function)
> include/linux/fs.h:2214: error: (Each undeclared identifier is reported only once
> include/linux/fs.h:2214: error: for each function it appears in.)
> include/linux/fs.h: In function 'free_secdata':
> include/linux/fs.h:2219: error: implicit declaration of function 
> 'free_page'
> In file included from include/linux/slab.h:13,
>                  from include/linux/percpu.h:6,
>                  from include/linux/percpu_counter.h:14,
>                  from include/linux/ext2_fs_sb.h:21,
>                  from include/linux/ext2_fs.h:70,
>                  from init/do_mounts_initrd.c:6:
> 
> config attached.
> 
> 	Ingo

Hm, that's weird, I was also testing on a 2.6.28-based tree. And I don't
see any reference to RCU headers in this error message. My guess is some
code assumes a certain header provides some definitions it isn't
required to.

I'll checkout your tree and have a look.


	Eduard

