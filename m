Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbZC3DCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbZC3DCY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 23:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758034AbZC3DB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 23:01:58 -0400
Received: from rtr.ca ([76.10.145.34]:43773 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758105AbZC3DB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 23:01:57 -0400
Message-ID: <49D03621.5080501@rtr.ca>
Date: Sun, 29 Mar 2009 23:01:53 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <49CD4DDF.3000001@garzik.org> <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed>
In-Reply-To: <20090329231451.GR26138@disturbed>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> On Sat, Mar 28, 2009 at 11:17:08AM -0400, Mark Lord wrote:
>> The better solution seems to be the rather obvious one:
>>
>>   the filesystem should commit data to disk before altering metadata.
> 
> Generalities are bad. For example:
> 
> write();
> unlink();
> <do more stuff>
> close();
> 
> This is a clear case where you want metadata changed before data is
> committed to disk. In many cases, you don't even want the data to
> hit the disk here.
..

Err, no actually.  I want a consistent disk state,
either all old or all new data after a crash.

Not loss of BOTH new and old data.

And the example above is trying to show, what??
Looks like a temporary file case, except the code
is buggy and should be doing the unlink() before
the write() call.

But thanks for looking at this stuff!
