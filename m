Return-Path: <linux-kernel-owner+w=401wt.eu-S1762809AbZCYPWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762809AbZCYPWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 11:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757036AbZCYPWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 11:22:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40183 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbZCYPWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:22:38 -0400
Date: Wed, 25 Mar 2009 16:22:35 +0100
From: Jan Kara <jack@suse.cz>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: next-20090310: ext4 hangs
Message-ID: <20090325152234.GN23439@duck.suse.cz>
References: <a4423d670903100517y42f342d4pd73c4c36f5c64dd7@mail.gmail.com> <20090310124658.GE8840@mit.edu> <a4423d670903100718w1a532143he767782ae598d0fb@mail.gmail.com> <20090310154745.GF23075@mit.edu> <a4423d670903110907o7041f4eof92278835aa0c71c@mail.gmail.com> <20090325151122.GA14881@atrey.karlin.mff.cuni.cz> <20090325151516.GB14881@atrey.karlin.mff.cuni.cz> <a4423d670903250818n512b1c67ja1b38db6d09ac7c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4423d670903250818n512b1c67ja1b38db6d09ac7c@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 25-03-09 18:18:43, Alexander Beregalov wrote:
> 2009/3/25 Jan Kara <jack@suse.cz>:
> >> > So, I think I need to try it on 2.6.29-rc7 again.
> >>   I've looked into this. Obviously, what's happenning is that we delete
> >> an inode and jbd2_journal_release_jbd_inode() finds inode is just under
> >> writeout in transaction commit and thus it waits. But it gets never woken
> >> up and because it has a handle from the transaction, every one eventually
> >> blocks on waiting for a transaction to finish.
> >>   But I don't really see how that can happen. The code is really
> >> straightforward and everything happens under j_list_lock... Strange.
> >  BTW: Is the system SMP?
> No, it is UP system.
  Even stranger. And do you have CONFIG_PREEMPT set?

> The bug exists even in 2.6.29, I posted it with a new topic.
  OK, I've sort-of expected this.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
