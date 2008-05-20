Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbYETChl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbYETChl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 22:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756602AbYETChc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 22:37:32 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62243 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756595AbYETChb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 22:37:31 -0400
Date: Mon, 19 May 2008 22:34:55 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 4/4] ext4: call blkdev_issue_flush on fsync
Message-ID: <20080520023454.GM15035@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jamie Lokier <jamie@shareable.org>
References: <482DDA56.6000301@redhat.com> <482DDC04.7020706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482DDC04.7020706@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 02:09:56PM -0500, Eric Sandeen wrote:
> To ensure that bits are truly on-disk after an fsync,
> we should call blkdev_issue_flush if barriers are supported.

This patch isn't necessary, and in fact will cause a double flush.
When you call fsync(), it calls ext4_force_commit(), and we do a the
equivalent of a blkdev_issue_flush() today (which is what happenes
when you do a submit_bh(WRITE_BARRIER, bh), which is what setting
set_ordered_mode(bh) ends up causing.

						- Ted
