Return-Path: <linux-kernel-owner+w=401wt.eu-S1750916AbXCLRdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750916AbXCLRdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 13:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbXCLRdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 13:33:19 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:54466 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbXCLRdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 13:33:19 -0400
Subject: Re: [RFC][PATCH 4/7] RSS accounting hooks over the code
From: Dave Hansen <hansendc@us.ibm.com>
To: Kirill Korotaev <dev@sw.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       Paul Menage <menage@google.com>, Pavel Emelianov <xemul@sw.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <45F588DE.3000309@sw.ru>
References: <45ED7DEC.7010403@sw.ru> <45ED81F2.80402@sw.ru>
	 <m14porwq1c.fsf@ebiederm.dsl.xmission.com>  <45F57E7D.6080604@sw.ru>
	 <1173718208.11945.54.camel@localhost.localdomain>  <45F588DE.3000309@sw.ru>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 10:33:16 -0700
Message-Id: <1173720796.11945.80.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 20:07 +0300, Kirill Korotaev wrote:
> > On Mon, 2007-03-12 at 19:23 +0300, Kirill Korotaev wrote:
> >>For these you essentially need per-container page->_mapcount counter,
> >>otherwise you can't detect whether rss group still has the page in question being mapped
> >>in its processes' address spaces or not. 
> > 
> > What do you mean by this?  You can always tell whether a process has a
> > particular page mapped.  Could you explain the issue a bit more.  I'm
> > not sure I get it.
> When we do charge/uncharge we have to answer on another question:
> "whether *any* task from the *container* has this page mapped", not the
> "whether *this* task has this page mapped".

That's a bit more clear. ;)

OK, just so I make sure I'm getting your argument here.  It would be too
expensive to go looking through all of the rmap data for _any_ other
task that might be sharing the charge (in the same container) with the
current task that is doing the unmapping.  

The requirements you're presenting so far appear to be:

1. The first user of a page in a container must be charged
2. The second user of a page in a container must not be charged
3. A container using a page must take a diminished charge when 
   another container is already using the page.
4. Additional fields in data structures (including 'struct page') are
   permitted

What have I missed?  What are your requirements for performance?

I'm not quite sure how the page->container stuff fits in here, though.
page->container would appear to be strictly assigning one page to one
container, but I know that beancounters can do partial page charges.
Care to fill me in?

-- Dave

