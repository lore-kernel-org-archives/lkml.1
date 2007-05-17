Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbXEQMK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbXEQMK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 08:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbXEQMKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 08:10:49 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54090 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338AbXEQMKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 08:10:47 -0400
Subject: Re: [PATCH 1/5][TAKE3] fallocate() implementation on i86, x86_64
	and powerpc
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: David Chinner <dgc@sgi.com>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
In-Reply-To: <20070516234036.GQ85884050@sgi.com>
References: <20070418130600.GW5967@schatzie.adilger.int>
	 <20070420135146.GA21352@amitarora.in.ibm.com>
	 <20070420145918.GY355@devserv.devel.redhat.com>
	 <20070424121632.GA10136@amitarora.in.ibm.com>
	 <20070426175056.GA25321@amitarora.in.ibm.com>
	 <20070515193722.GA3487@amitarora.in.ibm.com>
	 <20070515195421.GA2948@amitarora.in.ibm.com>
	 <20070515200359.GA5834@amitarora.in.ibm.com>
	 <20070516031626.GM85884050@sgi.com>
	 <1179318076.10313.6.camel@kleikamp.austin.ibm.com>
	 <20070516234036.GQ85884050@sgi.com>
Content-Type: text/plain
Date: Thu, 17 May 2007 07:10:44 -0500
Message-Id: <1179403844.13965.2.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 09:40 +1000, David Chinner wrote:
> On Wed, May 16, 2007 at 07:21:16AM -0500, Dave Kleikamp wrote:
> > On Wed, 2007-05-16 at 13:16 +1000, David Chinner wrote:

> > > Please don't make this always happen. c/mtime updates should be dependent
> > > on the mode being used and whether there is visible change to the file. If no
> > > userspace visible changes to the file occurred, then timestamps should not
> > > be changed.
> > 
> > i_blocks will be updated, so it seems reasonable to update ctime.  mtime
> > shouldn't be changed, though, since the contents of the file will be
> > unchanged.
> 
> That's assuming blocks were actually allocated - if the prealloc range already
> has underlying blocks there is no change and so we should not be changing
> mtime either. Only the filesystem will know if it has changed the file, so I
> think that timestamp updates need to be driven down to that level, not done
> blindy at the highest layer....

Yes, I agree.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

