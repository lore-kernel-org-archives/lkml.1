Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbYHMQz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbYHMQz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbYHMQzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:55:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57275 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752560AbYHMQzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:55:12 -0400
Date: Wed, 13 Aug 2008 17:37:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       andi@firstfloor.org, riel@redhat.com, greg@kroah.com, tytso@mit.edu,
       viro@ZenIV.linux.org.uk, arjan@infradead.org, peterz@infradead.org,
       hch@infradead.org
Subject: Re: TALPA - a threat model?  well sorta.
Message-ID: <20080813173722.13c9c306@lxorguk.ukuu.org.uk>
In-Reply-To: <1218646065.3540.75.camel@localhost.localdomain>
References: <1218645375.3540.71.camel@localhost.localdomain>
	<20080813172437.3ed90b0d@lxorguk.ukuu.org.uk>
	<1218646065.3540.75.camel@localhost.localdomain>
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

On Wed, 13 Aug 2008 12:47:45 -0400
Eric Paris <eparis@redhat.com> wrote:

> On Wed, 2008-08-13 at 17:24 +0100, Alan Cox wrote:
> > > So, what is it that anti-malware companies do?  They scan files.  That's
> > > it. 
> > 
> > Good so lets instead have a discussion about making the file event
> > notification more scalable. That is the same thing I want for content
> > indexing. It is the same thing you want for certain kinds of smart
> > archiving, for on-line asynchronous backup and other stuff.
> > 
> > It ought to be a simple clean syscall interface.
> 
> Are you willing to make it blocking?  I'm not sure how to make what we
> have capable of assuring that the object you got a notification about is
> actually the object you are acting on.  Thoughts on how to accomplish
> that?  I'm here to code and I'm willing to throw all my work in the
> garbage if someone can show me how to actually do it better.

I don't think you need to be blocking if you passed up a file handle ?

	fd = fileeventmumble(somestuff);
	do_stuff
	close(fd);

[taking care not to end up recursing as a result]
