Return-Path: <linux-kernel-owner+w=401wt.eu-S1760855AbYARBQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855AbYARBQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760554AbYARBQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:16:14 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760500AbYARBQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:16:08 -0500
Date: Thu, 17 Jan 2008 17:15:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Schwartz <davids@webmaster.com>
cc: Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       clameter@sgi.com, penberg@cs.helsinki.fi
Subject: RE: Why is the kfree() argument const?
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKOEIPJJAC.davids@webmaster.com>
Message-ID: <alpine.LFD.1.00.0801171710160.2957@woody.linux-foundation.org>
References: <MDEHLPKNGKAHNMBLJOLKOEIPJJAC.davids@webmaster.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Jan 2008, David Schwartz wrote:
> 
> > "const" has nothing to do with "logical state".  It has one meaning, and
> > one meaning only: the compiler should complain if that particular type is
> > used to do a write access.
> 
> Right, exactly.

So why do you complain? 

kfree() literally doesn't write to the object.

> You are the only one who has suggested it has anything to do with changes
> through other pointers or in other ways. So you are arguing against only
> yourself here.

No, I'm saying that "const" has absolutely *zero* meaning on writes to an 
object through _other_ pointers (or direct access) to the object.

And you're seemingly not understanding that *lack* of meaning.

kfree() doesn't do *squat* to the object pointed to by the pointer it is 
passed. It only uses it to look up its own data structures, of which the 
pointer is but a small detail.

And those other data structures aren't constant.

> Nobody has said it has anything to do with anything but operations through
> that pointer.

.. and I'm telling you: kfree() does *nothing* conceptually through that 
pointer. No writes, and not even any reads! Which is exactly why it's 
const.

The only thing kfree does through that pointer is to update its own 
concept of what memory it has free.

Now, what it does to its own free memory is just an implementation detail, 
and has nothing what-so-ever to do with the pointer you passed it.

See?

		Linus
