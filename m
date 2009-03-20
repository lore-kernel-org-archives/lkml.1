Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbZCTVNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbZCTVNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 17:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbZCTVNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 17:13:32 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:40864 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbZCTVNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 17:13:31 -0400
Subject: Re: [RFC][PATCH 5/8] add f_op for checkpointability
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: containers <containers@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20090303131528.GB10931@infradead.org>
References: <20090227203425.F3B51176@kernel>
	 <20090227203431.D1E697CB@kernel> <20090228205329.GB4254@infradead.org>
	 <1236013556.26788.466.camel@nimitz>  <20090303131528.GB10931@infradead.org>
Content-Type: text/plain
Date: Fri, 20 Mar 2009 14:13:24 -0700
Message-Id: <1237583604.8286.294.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-03 at 08:15 -0500, Christoph Hellwig wrote:
> On Mon, Mar 02, 2009 at 09:05:56AM -0800, Dave Hansen wrote:
> > On Sat, 2009-02-28 at 15:53 -0500, Christoph Hellwig wrote:
> > > Also the double-use of the op seem not very nice to me.  Is there any
> > > real life use case were you would have the operation on a file but
> > > sometimes not allow checkpoiting?
> > 
> > I'm still reaching here...
> > 
> > I was thinking of /proc.  Opening your own /proc/$$/* would certainly be
> > considered OK.  But, doing it for some other process not in your pid
> > namespace would not be OK and would not be checkpointable.
> > 
> > I know we're not quite in real-life territory here, yet, but I'm still
> > thinking.
> 
> That mighr be a good enough excuse, I was just wondering what the use
> case was.

I just thought of another one: unlinked files and directories.  They're
a pain to checkpoint and won't be supported for a while.  Holding open
an unlinked file would make a process uncheckpointable for a bit.

-- Dave

