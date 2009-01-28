Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbZA1Jfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbZA1Jfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 04:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbZA1Jfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 04:35:30 -0500
Received: from adelie.canonical.com ([91.189.90.139]:44024 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbZA1Jfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 04:35:30 -0500
Date: Wed, 28 Jan 2009 09:35:25 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: Checkpatch false positive?
Message-ID: <20090128093525.GB10291@shadowen.org>
References: <20090127154904.GC8289@duck.suse.cz> <20090127160601.GA20342@localhost.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127160601.GA20342@localhost.pp.htv.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 06:06:01PM +0200, Adrian Bunk wrote:
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

Yeah its about being explicit that you intended there to be an empty
statement in this construct.  We tend to get bitten even more by if form
of this:

	if (foo);
		something();

But we catch them all.  And always remember if you really think it looks
better or makes more sense one way and checkpatch is upset you can
ignore checkpatch.  It is advice on what will be accepted not
necessarily the final arbiter.  That is the maintainers role, checkpatch
is a tool to help you.

-apw
