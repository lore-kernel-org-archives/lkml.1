Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbZAMVlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbZAMVlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 16:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbZAMVlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 16:41:10 -0500
Received: from smtp-out.google.com ([216.239.45.13]:53458 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbZAMVlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 16:41:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=HsHpxf3Q53jcRWjNRYzuO86UGcRcn/gUGUq0kEVol6kwqHsrw2tn94+OWCpJVIeHZ
	bbxgULhpVBGHKBDDTg2CA==
Date: Tue, 13 Jan 2009 13:39:01 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [why oom_adj does not work] Re: Linux killed Kenny, bastard!
In-Reply-To: <20090113213316.GB27227@ioremap.net>
Message-ID: <alpine.DEB.2.00.0901131336040.17683@chino.kir.corp.google.com>
References: <20090112153304.GA19995@ioremap.net> <20090112154456.GA27269@redhat.com> <20090112154827.GB20743@ioremap.net> <20090112155108.2646b3ae@lxorguk.ukuu.org.uk> <20090113135246.GA29251@ioremap.net> <20090113140627.507f15e1@lxorguk.ukuu.org.uk>
 <20090113142423.GA30710@ioremap.net> <661de9470901130700m34c4938cm6feeb6fc561d605a@mail.gmail.com> <20090113152106.GA1134@ioremap.net> <alpine.DEB.2.00.0901131140340.8522@chino.kir.corp.google.com> <20090113213316.GB27227@ioremap.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.28.16.141
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009, Evgeniy Polyakov wrote:

> I really did not investigate why it happend, but oom'ed machine had
> killed cgi daemons and parent process itself. And ssh to the heap.
> While it should be enough just to kill appropriate daemon. Apparently
> things are not that shine as should be.
> 

As previously mentioned, you have all the diagnostic tools at your 
disposal already:

	echo 1 > /proc/sys/vm/oom_dump_tasks

The badness scoring is straight-forward given that information, so you can 
diagnose why a specific task was not killed and another was chosen.  You 
can also use that information to appropriately tune the oom_adj scores to 
identify your oom killer target preferences.
