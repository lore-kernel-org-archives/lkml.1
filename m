Return-Path: <linux-kernel-owner+w=401wt.eu-S1752070AbXFDBDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbXFDBDx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 21:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbXFDBDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 21:03:47 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57421 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbXFDBDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 21:03:46 -0400
Subject: Re: [RFC 0/4] CONFIG_STABLE to switch off development checks
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org
In-Reply-To: <46619AB6.5060606@goop.org>
References: <20070531002047.702473071@sgi.com> <46603371.50808@goop.org>
	 <Pine.LNX.4.64.0706011126030.2284@schroedinger.engr.sgi.com>
	 <46606C71.9010008@goop.org>
	 <1180797790.18535.6.camel@kleikamp.austin.ibm.com>
	 <46619AB6.5060606@goop.org>
Content-Type: text/plain
Date: Sun, 03 Jun 2007 20:03:41 -0500
Message-Id: <1180919021.8897.19.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-02 at 09:28 -0700, Jeremy Fitzhardinge wrote:
> Dave Kleikamp wrote:
> > I'm on Christoph's side here.  I don't think it makes sense for any code
> > to ask to allocate zero bytes of memory and expect valid memory to be
> > returned.
> >   
> 
> Yes, everyone agrees on that.  If you do kmalloc(0), its never OK to
> dereference the result.  The question is whether kmalloc(0) should complain.

Yeah, I see that you aren't necessarily asking for valid memory, just
something that appears valid.  I'm still of the mind that if code is
asking for a zero-length allocation, it's raising a flag that it's not
taking some corner case into account.  But I think I'm just
regurgitating what Christoph is arguing.

> > Would a compromise be to return a pointer to some known invalid region?
> > This way the kmalloc(0) call would appear successful to the caller, but
> > any access to the memory would result in an exception.
> >   
> 
> Yes, that's what Christoph has posted.

Oh.  I went back and re-read the thread and it looks like you proposed
this already.  I don't see where Christoph did, or agreed, but maybe I
missed something.

> I'm slightly concerned about
> kmalloc() returning the same non-NULL address multiple times, but it
> seems sound otherwise.

If the caller is asking for 0 bytes, it shouldn't be doing anything with
the returned address except checking for a NULL return.  But then, it's
hard to predict everything that calling code might be doing, such as
allocating buffers and creating a hash based on their addresses.  Of
course, if there's code that would have a problem with it, I think it's
a further argument that it would be better off avoiding the calling
kmalloc(0) in the first place.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

