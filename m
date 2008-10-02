Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbYJBUuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbYJBUuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 16:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbYJBUt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 16:49:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57987 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754084AbYJBUt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 16:49:58 -0400
Date: Thu, 2 Oct 2008 21:48:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       arjan@infradead.org, bunk@kernel.org, tytso@mit.edu,
       tvrtko.ursulin@sophos.com, david@lang.hm, hch@infradead.org,
       andi@firstfloor.org, viro@ZenIV.linux.org.uk, peterz@infradead.org,
       Jonathan.Press@ca.com, riel@redhat.com, greg@kroah.com
Subject: Re: [RFC] 0/11 fanotify: fscking all notifiction and file access
 system (intended for antivirus scanning and file indexers)
Message-ID: <20081002214846.60560cae@lxorguk.ukuu.org.uk>
In-Reply-To: <1222975491.28251.202.camel@localhost.localdomain>
References: <1222463220.2872.193.camel@localhost.localdomain>
	<20080926223404.7c4894df@lxorguk.ukuu.org.uk>
	<1222975491.28251.202.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> struct fan_sockaddr {
> 	int version;
> 	unsigned int mask;
> 	pid_t pid;
> 	pid_t tgid;
> 	int f_flags;
> }
> 
> so this will be a binary interface for metadata.  Sending the metadata
> about the open fd up the sockaddrs is very slick, but not easily
> extended that I can see.  Guess we need to get the metadata right the
> first time.

Usual way socket stuff covers for that is to stick

	unsigned int __unused[8];

or similar on the end...

> PF_FAN system.  This new fd from connect can then take commands using
> either sendmsg() or setsockopt() or really anything since it doesn't
> have a 'real file' on the backend.

That is the normal socket approach. Eg in traditional BSD interfaces for
IP routing you created an AF_INET socket and frobbed with it.

> So the alternative would be that I could make ALL listener->kernel
> communication go over the fd that came from connect().  Setting a

Probably a lot saner

> includes types and lens.  Is is it bad to have a fd whose only
> implemented function is setsockopt?

Not really. Lots of socket types have operations that are essentially

	fd = socket(...)
	ioctl(fd, ....);
	close(fd);

or similar. Traditionally ioctl is used for system changing stuff but
that is just tradition.

