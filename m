Return-Path: <linux-kernel-owner+w=401wt.eu-S933419AbXHFTj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933419AbXHFTj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758620AbXHFTiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:38:52 -0400
Received: from pat.uio.no ([129.240.10.15]:33040 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765718AbXHFTiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:38:50 -0400
Subject: Re: 2.6.22.1 Oops in put_nfs_open_context
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@fieldses.org>, stable@kernel.org
In-Reply-To: <20070806114534.a69644cc.akpm@linux-foundation.org>
References: <20070806100813.GA30370@gallifrey>
	 <20070806110107.0d0a2c2b.akpm@linux-foundation.org>
	 <1186424394.6616.44.camel@localhost>
	 <20070806114534.a69644cc.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 06 Aug 2007 15:38:44 -0400
Message-Id: <1186429124.6616.72.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.052)
X-UiO-Scanned: 7CF46F98C074E6942E38EDCA651A4158F09DCA07
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 688 total 3122345 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 11:45 -0700, Andrew Morton wrote:
> On Mon, 06 Aug 2007 14:19:54 -0400 Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> 
> > On Mon, 2007-08-06 at 11:01 -0700, Andrew Morton wrote:
> > > On Mon, 6 Aug 2007 11:08:13 +0100 "Dr. David Alan Gilbert" <linux@treblig.org> wrote:
> > > 
> > > >   The oops below is from one of a pair of machines that run compiles;
> > > > they're not managing to stay up for more than a day or two at a time
> > > > this is the first time I've actually managed to capture an oops from one.
> > > > They lock to the point where they still ping, and they won't toggle
> > > > capslock.  A top left running on them showed it sitting with pdflush
> > > > using 99% CPU.
> > > > 
> > > >   Config at the bottom.  The hardware are supermicro X7DVA boards with
> > > > 2x Xeon 5140's. (These Supermicro bios don't appear to have the PCI-Express
> > > > coalesce option being discussed in another thread).
> > > > 
> > 
> > ...
> >
> > I believe this fix should address it.
> 
> Neat, and that's already in 2.6.23-rc2.  Please consider sending something
> to stable@kernel.org when the dust has settled.  David, it would be great if
> we could get confirmation, please..

I haven't pushed it to Linus yet, but it might already be in -mm? I'm
planning a merge of a half-dozen fixes as soon as I get the last couple
of confirmations from the people testing them.

> > From: Trond Myklebust <Trond.Myklebust@netapp.com>
> > Subject: No Subject
> > Date: Thu, 26 Jul 2007 12:06:17 -0400
> > 
> > We need to grab the inode->i_lock atomically with the last reference put in
> > order to remove the open context that is being freed from the
> > nfsi->open_files list.
> 
> Your patches have lost their titles btw.

Sorry about that. Evolution appears to "recognise" the patches as
emails, and gets confused...

Cheers
   Trond

