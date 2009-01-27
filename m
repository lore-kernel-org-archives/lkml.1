Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbZA0Qe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbZA0Qe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 11:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZA0QeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 11:34:20 -0500
Received: from styx.suse.cz ([82.119.242.94]:42001 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752571AbZA0QeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 11:34:19 -0500
Date: Tue, 27 Jan 2009 17:34:18 +0100
From: Jan Kara <jack@suse.cz>
To: Adrian Bunk <bunk@kernel.org>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org
Subject: Re: Checkpatch false positive?
Message-ID: <20090127163418.GE8289@duck.suse.cz>
References: <20090127154904.GC8289@duck.suse.cz> <20090127160601.GA20342@localhost.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127160601.GA20342@localhost.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 27-01-09 18:06:01, Adrian Bunk wrote:
> On Tue, Jan 27, 2009 at 04:49:05PM +0100, Jan Kara wrote:
> >   Hi,
> > 
> >   I've used checkpatch.pl to verify one of my patches. It complains:
> > 
> > ERROR: trailing statements should be on next line
> > #167: FILE: fs/quota/quota_tree.c:249:
> > +       for (i = 0, ddquot = buf + sizeof(struct qt_disk_dqdbheader);
> > [...]
> >              i++, ddquot += info->dqi_entry_size);
> > 
> >   But the code looks like:
> >         for (i = 0, ddquot = buf + sizeof(struct qt_disk_dqdbheader);
> >              i < qtree_dqstr_in_blk(info) && !qtree_entry_unused(info, ddquot);
> >              i++, ddquot += info->dqi_entry_size);
> > 
> >   Which is IMHO correct. Maybe it's because the for has actually empty body
> > and the ; is at the end of the line with for. But I didn't find anything in
> > CodingStyle that would forbid
> > 	for (...);
> > and
> > 	for (...)
> > 		;
> > Looks a bit strange.
> 
> for (...); is a common C programming error, usually it's some kind of:
> 
> 	for(........);
> 		do_something();
> 
> This code does something different than intended.
> And yes, we had such bugs in the kernel.
> 
> 
> 	for(........)
> 		;
> 
> is correct. The "looks a bit strange" is what actually tells readers 
> what the code is doing (and that the author did it intentionally).
  OK, makes some sence. Thanks for explanation.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
