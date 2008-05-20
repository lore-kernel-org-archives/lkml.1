Return-Path: <linux-kernel-owner+w=401wt.eu-S935023AbYETPoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935023AbYETPoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934348AbYETPne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:43:34 -0400
Received: from mail2.shareable.org ([80.68.89.115]:52857 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934338AbYETPnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:43:31 -0400
Date: Tue, 20 May 2008 16:43:14 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
       ext4 development <linux-ext4@vger.kernel.org>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] ext4: call blkdev_issue_flush on fsync
Message-ID: <20080520154313.GI16676@shareable.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <482DDA56.6000301@redhat.com> <482DDC04.7020706@redhat.com> <20080520023454.GM15035@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520023454.GM15035@mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Fri, May 16, 2008 at 02:09:56PM -0500, Eric Sandeen wrote:
> > To ensure that bits are truly on-disk after an fsync,
> > we should call blkdev_issue_flush if barriers are supported.
> 
> This patch isn't necessary, and in fact will cause a double flush.
> When you call fsync(), it calls ext4_force_commit(), and we do a the
> equivalent of a blkdev_issue_flush() today (which is what happenes
> when you do a submit_bh(WRITE_BARRIER, bh), which is what setting
> set_ordered_mode(bh) ends up causing.

ISTR fsync() on ext3 did not always force a commit, if in-place data
writes did not change any metadata.  Has this been fixed in ext4 but
not ext3 then?

Does WRITE_BARRIER always cause a flush?  It does not have to
according to Documentation/block/barrier.txt.  There are caveats about
tagged queuing "not yet implemented" in the text, but can we rely on
that?  The documentation is older than the current implementation;
those caveats might no longer apply.

-- Jamie
