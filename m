Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYHMVb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYHMVb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 17:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYHMVbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 17:31:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34159 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752202AbYHMVbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 17:31:51 -0400
Date: Wed, 13 Aug 2008 22:13:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: "Eric Paris" <eparis@redhat.com>, <peterz@infradead.org>,
       <linux-kernel@vger.kernel.org>, <malware-list@lists.printk.net>,
       <hch@infradead.org>, <andi@firstfloor.org>, <viro@ZenIV.linux.org.uk>,
       <arjan@infradead.org>
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
Message-ID: <20080813221348.7198434c@lxorguk.ukuu.org.uk>
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4BC2@USILMS12.ca.com>
References: <1218645375.3540.71.camel@localhost.localdomain>
	<20080813172437.3ed90b0d@lxorguk.ukuu.org.uk>
	<1218646065.3540.75.camel@localhost.localdomain>
	<20080813173722.13c9c306@lxorguk.ukuu.org.uk>
	<1218646833.3540.82.camel@localhost.localdomain>
	<20080813205906.559d3f37@lxorguk.ukuu.org.uk>
	<2629CC4E1D22A64593B02C43E855530304AE4BC2@USILMS12.ca.com>
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

> I may be missing something about your suggestion, but I don't see how
> this would work.  Who does the chmod?
> 
> Here's a sequence:
> 
> - Application opens file
> - AV scanner notified in some way without blocking
> - Application reads file into memory

The discussion has been about scanning on write. 

> - AV scanner determines file is infected.
> - AV scanner chmod's file -- oops, too late.
> - Application sends file over the wire to another machine with a more
> vulnerable OS
> 
> How would this be prevented?

I don't think you can. In your case how does your AV scanner deal with
the case where the application opens the file while another user has it
open and the other user (or even other task with the same handle) changes
the content possibly via mmap.

Content may also directly be shared between users of a file using the
mmap interfaces so your scan on read model is rather dysfunctional.

