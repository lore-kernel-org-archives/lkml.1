Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbYJBNrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbYJBNrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 09:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYJBNrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 09:47:19 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:52076 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754197AbYJBNrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 09:47:19 -0400
Date: Thu, 2 Oct 2008 09:46:59 -0400
From: Theodore Tso <tytso@mit.edu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081002134659.GC25164@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20081001200034.65eb67d6@infradead.org> <20081001215638.3a65134c.akpm@linux-foundation.org> <20081002062736.GR19428@kernel.dk> <20081001235501.2b7f50fe.akpm@linux-foundation.org> <20081002074523.GW19428@kernel.dk> <20081002010315.1cda8147.akpm@linux-foundation.org> <20081002120444.GA25164@mit.edu> <20081002061629.39d5e115@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002061629.39d5e115@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 06:16:29AM -0700, Arjan van de Ven wrote:
> On Thu, 2 Oct 2008 08:04:44 -0400
> Theodore Tso <tytso@mit.edu> wrote:
> 
> > 
> > > But sometimes that doesn't work (including the place where I
> > > knowingly broke it).  If we can find and fix the offending piece of
> > > jbd logic (a big if) then all is peachy.
> > 
> > Do we have workloads that can easily demonstrate this problem?  If so,
> > we can add some tracing code which will allow us to see which theory
> > is correct, and what is actually happening.
> 
> I can very easily reproduce it; my mail client (claws) stalls due to
> this several seconds at least once every 5 to 10 minutes...
> (usually when I'm typing an email.. grumble)

Are you running with noatime or relatime?

One quick thing to try that might show what is going on is to run
debugfs on the device where your mail directory is located, while
claws is running, and then use the debugfs command "logdump -a" to
dump out the contents of the journal.  You can then use ncheck and
icheck to take the FS block numbers from logdump and translate them to
inode numbers, and then from inode numbers to pathnames.  That might
give us some insight as to what is going on.

I can whip up a patch which adds some markers which we could use to
find out more information about what is happening.

     	      		  	     	- Ted
