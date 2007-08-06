Return-Path: <linux-kernel-owner+w=401wt.eu-S933637AbXHFSqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637AbXHFSqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759461AbXHFSqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:46:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42424 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759180AbXHFSqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:46:09 -0400
Date: Mon, 6 Aug 2007 11:45:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@fieldses.org>, stable@kernel.org
Subject: Re: 2.6.22.1 Oops in put_nfs_open_context
Message-Id: <20070806114534.a69644cc.akpm@linux-foundation.org>
In-Reply-To: <1186424394.6616.44.camel@localhost>
References: <20070806100813.GA30370@gallifrey>
	<20070806110107.0d0a2c2b.akpm@linux-foundation.org>
	<1186424394.6616.44.camel@localhost>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Aug 2007 14:19:54 -0400 Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> On Mon, 2007-08-06 at 11:01 -0700, Andrew Morton wrote:
> > On Mon, 6 Aug 2007 11:08:13 +0100 "Dr. David Alan Gilbert" <linux@treblig.org> wrote:
> > 
> > >   The oops below is from one of a pair of machines that run compiles;
> > > they're not managing to stay up for more than a day or two at a time
> > > this is the first time I've actually managed to capture an oops from one.
> > > They lock to the point where they still ping, and they won't toggle
> > > capslock.  A top left running on them showed it sitting with pdflush
> > > using 99% CPU.
> > > 
> > >   Config at the bottom.  The hardware are supermicro X7DVA boards with
> > > 2x Xeon 5140's. (These Supermicro bios don't appear to have the PCI-Express
> > > coalesce option being discussed in another thread).
> > > 
> 
> ...
>
> I believe this fix should address it.

Neat, and that's already in 2.6.23-rc2.  Please consider sending something
to stable@kernel.org when the dust has settled.  David, it would be great if
we could get confirmation, please..

> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> Subject: No Subject
> Date: Thu, 26 Jul 2007 12:06:17 -0400
> 
> We need to grab the inode->i_lock atomically with the last reference put in
> order to remove the open context that is being freed from the
> nfsi->open_files list.

Your patches have lost their titles btw.
