Return-Path: <linux-kernel-owner+w=401wt.eu-S1757811AbYHMURV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbYHMURV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYHMURN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:17:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43895 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750973AbYHMURM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:17:12 -0400
Date: Wed, 13 Aug 2008 20:59:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       andi@firstfloor.org, riel@redhat.com, greg@kroah.com, tytso@mit.edu,
       viro@ZenIV.linux.org.uk, arjan@infradead.org, peterz@infradead.org,
       hch@infradead.org
Subject: Re: TALPA - a threat model?  well sorta.
Message-ID: <20080813205906.559d3f37@lxorguk.ukuu.org.uk>
In-Reply-To: <1218646833.3540.82.camel@localhost.localdomain>
References: <1218645375.3540.71.camel@localhost.localdomain>
	<20080813172437.3ed90b0d@lxorguk.ukuu.org.uk>
	<1218646065.3540.75.camel@localhost.localdomain>
	<20080813173722.13c9c306@lxorguk.ukuu.org.uk>
	<1218646833.3540.82.camel@localhost.localdomain>
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

> > I don't think you need to be blocking if you passed up a file handle ?
> 
> Without blocking and waiting how do you deny access?  Maybe I needed
> another thing they do.  "They do file scanning and deny access to bad
> files."

Denying access is easy enough - chmod it or set an SELinux label on it.

There are a limited number of useful arrangements I can see here

'opened for write deny [some set of] access until verified'

Thats an selinux state transition on open for write, and one from the
user space end on the other

'run around after things'

Which is simply a notifier and a relabel as 'contaminated' or similar (or
a chmod or mv ...) by the daemon end of things.

Now I can see why you might want a 'has been open for a write and dirty
for a while' notifier - again for indexing as well as virus scanners and
the like.

What other semantic do you have in mind given that you have to deal with
open by me, open by writer, content modified.. after I have it open
anyway ? It seems the rest is a discussion about time intervals ?
