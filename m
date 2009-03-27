Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbZC0S0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbZC0S0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 14:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZC0S0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 14:26:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752287AbZC0S0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 14:26:39 -0400
Date: Fri, 27 Mar 2009 11:22:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0903271110500.3994@localhost.localdomain>
References: <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk>
 <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org>
 <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Mar 2009, Linus Torvalds wrote:
> 
> Yes, some editors (vi, emacs) do it, but even there it's configurable. 

.. and looking at history, it's even pretty modern. From the vim logs:

	Patch 6.2.499
	Problem:   When writing a file and halting the system, the file might be lost
	           when using a journalling file system.
	Solution:  Use fsync() to flush the file data to disk after writing a file.
	           (Radim Kolar)
	Files:     src/fileio.c

so it looks (assuming those patch numbers mean what they would seem to 
mean) that 'fsync()' in vim is from after 6.2 was released. Some time in 
2004.

So traditionally, even solid "good" programs like major editors never 
tried to fsync() their files.

Btw, googling for that 6.2.499 patch also shows that people were rather 
unhappy with it. Why? It causes disk spinups in laptop mode etc. Which is 
very much not what you want to see for power reasons.

So there are other, really fundamental, reasons why applications that 
don't have the "mailspool must not be lost" kind of critical issues to 
absolutely NOT use fsync(). Those applications would be much better off 
with some softer hint that can take things like laptop mode into account.

		Linus
