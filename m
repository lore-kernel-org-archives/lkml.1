Return-Path: <linux-kernel-owner+w=401wt.eu-S1756968AbZD1RPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbZD1RPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbZD1ROt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:14:49 -0400
Received: from THUNK.ORG ([69.25.196.29]:48229 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566AbZD1ROs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:14:48 -0400
Date: Tue, 28 Apr 2009 13:14:45 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/5] ext4: Avoid races caused by on-line resizing and
	SMP memory reordering
Message-ID: <20090428171445.GD24043@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
References: <1240717765-16572-1-git-send-email-tytso@mit.edu> <1240717765-16572-2-git-send-email-tytso@mit.edu> <20090428162359.GK21950@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428162359.GK21950@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 06:23:59PM +0200, Jan Kara wrote:
>   Ouch... Hmm, smp_rmb() isn't completely free and mainly it's a bit
> ugly and prone to errors (I'm afraid next time someone changes the
> allocation code, we miss some barriers again)... so.. Maybe a stupid
> idea but wouldn't it be easier to solve the online resize like: freeze
> the filesystem, do all the changes required for extend, unfreeze the
> filesystem?

Eric suggested a helper function when reading from s_groups_count.
That would take care of the code maintenance headache.  One problem
with using freeze/thaw is it won't work without a journal, and we do
support filesystems without journals in ext4.  (Probably the best
solution for netbooks with crapola SSD's.)

As far as smb_rmb() not being free, it's essentially free for
x86/x86_64 platforms.  Is it really that costly on other
architectures?

						- Ted
