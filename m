Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259AbYECEwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbYECEwc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 00:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbYECEwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 00:52:24 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:32846 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbYECEwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 00:52:23 -0400
Message-ID: <481BEF7A.1060300@garzik.org>
Date: Sat, 03 May 2008 00:52:10 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-next@vger.kernel.org,
       sfrench@us.ibm.com, swhiteho@redhat.com, ralf@linux-mips.org,
       drzeus-list@drzeus.cx, jack@ucw.cz, cbou@mail.ru, jens.axboe@oracle.com,
       ericvh@gmail.com, wim@iguana.be, chris@zankel.net, nico@cam.org,
       penberg@cs.helsinki.fi, clameter@sgi.com, ezk@cs.sunysb.edu,
       linux-kernel@vger.kernel.org
Subject: Re: git trees which are not yet in linux-next
References: <20080502151206.b40f77ea.akpm@linux-foundation.org>	<20080502154200.a6d8c43a.akpm@linux-foundation.org>	<481BBD84.10904@s5r6.in-berlin.de> <20080502183403.3d9f2d9f.akpm@linux-foundation.org>
In-Reply-To: <20080502183403.3d9f2d9f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 03 May 2008 03:19:00 +0200 Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> 
>> Andrew Morton wrote:
>>> On Fri, 2 May 2008 15:12:06 -0700
>>> Andrew Morton <akpm@linux-foundation.org> wrote:
>>>
>>>> The first
>>>> problem is working out "how the heck did that patch get into linux-next"? 
>>>> That would be much easier if the signoff trail was complete for git-based
>>>> patches, but it often is not.
>>> doh.  I'm pulling linux-next's constituent trees independently, so if I
>>> spot a turd in linux-next I can just grep the various git trees to find out
>>> where it came from.
>>>
>>> It seems wrong though...
>> What about the committer info?  Well, I suppose a nobody@localhost slips 
>> in, but more often I expect it to be something more telling than that.
> 
> Beats me.  To pick one example:
> 
> commit 1a72963d3af38eb17a939fc19b322735da1c0aad
> Author: Matthew Wilcox <matthew@wil.cx>
> Date:   Fri Apr 25 12:38:41 2008 -0400
> 
>     Convert board-nokia770 from semaphore to spinlock
>     
>     None of the operations done under the semaphore could sleep, so a spinlock
>     is more appropriate to this case.
>     
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> 
> There's no sign how that got there.  A bit of forensics shows up:

Poke through the man pages, particularly git-log, and tell it to spit 
out the committer info, then.  It's in there.

For example,

	git log --pretty=full

produces

	commit c4d0f8cbca3a97900f85b082064a63c7a5928bd7
	Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
	Commit: Greg Kroah-Hartman <gregkh@suse.de>

	    usb_serial: some coding style fixes

	    Signed-off-by: Alan Cox <alan@redhat.com>
	    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Regards,

	Jeff



