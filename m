Return-Path: <linux-kernel-owner+w=401wt.eu-S1763692AbYHEUgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763692AbYHEUgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756532AbYHEUgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:36:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48695 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753707AbYHEUgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:36:35 -0400
Date: Tue, 5 Aug 2008 21:17:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: "Press, Jonathan" <Jonathan.Press@ca.com>,
       Arjan van de Ven <arjan@infradead.org>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux
 interfaceforon access scanning
Message-ID: <20080805211732.1bb4346e@lxorguk.ukuu.org.uk>
In-Reply-To: <20080805181141.GA10700@kroah.com>
References: <20080805103840.1aaa64a5@infradead.org>
	<2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
	<20080805181141.GA10700@kroah.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > However, I want to point out that scanning on close is still an integral
> > part of AV protection, even if intercepting opens and execs
> > theoretically catches everything.
> 
> Great, then put a hook in glibc and catch all closes and then kick off
> your scanning.

kill -9
deferred close via mmap
etc etc etc

You can't just armwave it into glibc, that doesn't hold water. You also
have shared state between processes (index on last close of a handle
shared by several threads or processes).

Same problem you have in the indexing business (which also wants the
close hook) - aside from all the practical issues that LD_PRELOAD tends
to turn up.

I'm not actually interested in the AV stuff, but content indexing I do
care about and we do need a way to get notification up to user space.

Alan
