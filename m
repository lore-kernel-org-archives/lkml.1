Return-Path: <linux-kernel-owner+w=401wt.eu-S1761240AbYA1ReU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240AbYA1ReU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 12:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbYA1ReI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 12:34:08 -0500
Received: from styx.suse.cz ([82.119.242.94]:44244 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752120AbYA1ReG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 12:34:06 -0500
Date: Mon, 28 Jan 2008 18:34:05 +0100
From: Jan Kara <jack@suse.cz>
To: Al Boldi <a1426z@gawab.com>
Cc: Diego Calleja <diegocg@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
Message-ID: <20080128173405.GH14038@duck.suse.cz>
References: <200801242336.00340.a1426z@gawab.com> <20080124225026.55fc6c20.diegocg@gmail.com> <200801260827.43284.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801260827.43284.a1426z@gawab.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 26-01-08 08:27:43, Al Boldi wrote:
> Diego Calleja wrote:
> > El Thu, 24 Jan 2008 23:36:00 +0300, Al Boldi <a1426z@gawab.com> escribió:
> > > Greetings!
> > >
> > > data=ordered mode has proven reliable over the years, and it does this
> > > by ordering filedata flushes before metadata flushes.  But this
> > > sometimes causes contention in the order of a 10x slowdown for certain
> > > apps, either due to the misuse of fsync or due to inherent behaviour
> > > like db's, as well as inherent starvation issues exposed by the
> > > data=ordered mode.
> >
> > There's a related bug in bugzilla:
> > http://bugzilla.kernel.org/show_bug.cgi?id=9546
> >
> > The diagnostic from Jan Kara is different though, but I think it may be
> > the same problem...
> >
> > "One process does data-intensive load. Thus in the ordered mode the
> > transaction is tiny but has tons of data buffers attached. If commit
> > happens, it takes a long time to sync all the data before the commit
> > can proceed... In the writeback mode, we don't wait for data buffers, in
> > the journal mode amount of data to be written is really limited by the
> > maximum size of a transaction and so we write by much smaller chunks
> > and better latency is thus ensured."
> >
> >
> > I'm hitting this bug too...it's surprising that there's not many people
> > reporting more bugs about this, because it's really annoying.
> >
> >
> > There's a patch by Jan Kara (that I'm including here because bugzilla
> > didn't include it and took me a while to find it) which I don't know if
> > it's supposed to fix the problem , but it'd be interesting to try:
> 
> Thanks a lot, but it doesn't fix it.
  Hmm, if you're willing to test patches, then you could try a debug patch:
http://bugzilla.kernel.org/attachment.cgi?id=14574
  and send me the output. What kind of load do you observe problems with
and which problems exactly?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
