Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbZEEUlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbZEEUlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 16:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbZEEUl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 16:41:28 -0400
Received: from smtp-out.google.com ([216.239.45.13]:3890 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbZEEUl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 16:41:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=GBEPxZ22HvF/mDIqPzvJUK/LQeiYH4UJeG7WB6giZ4qUkFrMh3ybMBLBp7RMHsVv5
	M5CDGouG8Q5hE6PRFpVNw==
Date: Tue, 5 May 2009 13:41:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jack Steiner <steiner@sgi.com>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, alex.shi@intel.com,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Fix early panic issue on machines with memless node
In-Reply-To: <20090505202730.GA9831@sgi.com>
Message-ID: <alpine.DEB.2.00.0905051336110.22577@chino.kir.corp.google.com>
References: <1241493327.27664.17.camel@ymzhang> <alpine.DEB.2.00.0905042026010.29856@chino.kir.corp.google.com> <20090505163608.GA20385@sgi.com> <alpine.DEB.2.00.0905051250510.20021@chino.kir.corp.google.com> <20090505202730.GA9831@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 May 2009, Jack Steiner wrote:

> I suspect I mislead you when I mentioned "configurations". I did not mean
> the .config file. I use a more-or-less standard .config file.
> 

Your .config would still let me build a kernel with debugging symbols so 
that your offsets actually made sense to my gdb.

> I do much of my testing on a system simulator. Using a simulator config file,
> I specify the system configuration such as number of nodes, sockets per node,
> cpus per socket, memory per socket, address map, boot options, etc. This
> makes it easy to quickly test a lot of strange (but real) configurations.
> 
> The configuration above that is failing is a 2-socket Nehelem blade that has no
> memory on socket 0. All memory is located on socket 1.  The panic is caused by a
> null dereference of NODE_DATA(0).
> 

A NULL dereference of NODE_DATA(0) should never happen even with 
!CONFIG_NEED_MULTIPLE_NODES.  So when you say the panic is caused by that 
(and I'm speculating since all I've seen is a call trace and not the 
entire panic), I'm assuming it's because NODE_DATA(0)->node_zones + offset 
is NULL because node 0 has no memory?
