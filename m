Return-Path: <linux-kernel-owner+w=401wt.eu-S933271AbYETPxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271AbYETPxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbYETPxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:53:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039AbYETPxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:53:03 -0400
Message-ID: <4832F3C6.1050601@redhat.com>
Date: Tue, 20 May 2008 10:52:38 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
       ext4 development <linux-ext4@vger.kernel.org>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] ext4: call blkdev_issue_flush on fsync
References: <482DDA56.6000301@redhat.com> <482DDC04.7020706@redhat.com> <20080520023454.GM15035@mit.edu> <20080520154313.GI16676@shareable.org>
In-Reply-To: <20080520154313.GI16676@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> Theodore Tso wrote:
>> On Fri, May 16, 2008 at 02:09:56PM -0500, Eric Sandeen wrote:
>>> To ensure that bits are truly on-disk after an fsync,
>>> we should call blkdev_issue_flush if barriers are supported.
>> This patch isn't necessary, and in fact will cause a double flush.
>> When you call fsync(), it calls ext4_force_commit(), and we do a the
>> equivalent of a blkdev_issue_flush() today (which is what happenes
>> when you do a submit_bh(WRITE_BARRIER, bh), which is what setting
>> set_ordered_mode(bh) ends up causing.
> 
> ISTR fsync() on ext3 did not always force a commit, if in-place data
> writes did not change any metadata.

I think that might still be true, but I'm still looking through it (in
the background...)

I tried blktrace to see what was going on but I'm not sure what an "NB"
in the RWBS field means, anyone know?

-Eric

