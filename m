Return-Path: <linux-kernel-owner+w=401wt.eu-S1755062AbYJBOeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbYJBOeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 10:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbYJBOdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 10:33:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:46547 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbYJBOdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 10:33:52 -0400
Date: Thu, 2 Oct 2008 07:33:04 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081002073304.7f027f52@infradead.org>
In-Reply-To: <20081002134659.GC25164@mit.edu>
References: <20081001200034.65eb67d6@infradead.org>
	<20081001215638.3a65134c.akpm@linux-foundation.org>
	<20081002062736.GR19428@kernel.dk>
	<20081001235501.2b7f50fe.akpm@linux-foundation.org>
	<20081002074523.GW19428@kernel.dk>
	<20081002010315.1cda8147.akpm@linux-foundation.org>
	<20081002120444.GA25164@mit.edu>
	<20081002061629.39d5e115@infradead.org>
	<20081002134659.GC25164@mit.edu>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 09:46:59 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Thu, Oct 02, 2008 at 06:16:29AM -0700, Arjan van de Ven wrote:
> > On Thu, 2 Oct 2008 08:04:44 -0400
> > Theodore Tso <tytso@mit.edu> wrote:
> > 
> > > 
> > > > But sometimes that doesn't work (including the place where I
> > > > knowingly broke it).  If we can find and fix the offending
> > > > piece of jbd logic (a big if) then all is peachy.
> > > 
> > > Do we have workloads that can easily demonstrate this problem?
> > > If so, we can add some tracing code which will allow us to see
> > > which theory is correct, and what is actually happening.
> > 
> > I can very easily reproduce it; my mail client (claws) stalls due to
> > this several seconds at least once every 5 to 10 minutes...
> > (usually when I'm typing an email.. grumble)
> 
> Are you running with noatime or relatime?

yes; I have

mount -o remount,relatime / &
for i in `pidof kjournald` ; do ionice -c1 -p $i ; done

in my /etc/rc.local 


> One quick thing to try that might show what is going on is to run
> debugfs on the device where your mail directory is located, while
> claws is running, and then use the debugfs command "logdump -a" to
> dump out the contents of the journal.  You can then use ncheck and
> icheck to take the FS block numbers from logdump and translate them to
> inode numbers, and then from inode numbers to pathnames.  That might
> give us some insight as to what is going on.

I'll try (sadly I'm in a training session all day today so I might not
get to it quickly)
 
> I can whip up a patch which adds some markers which we could use to
> find out more information about what is happening.

interesting testcase of the markers concept.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
