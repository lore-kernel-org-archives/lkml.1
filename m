Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbYJOUkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbYJOUkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 16:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbYJOUkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 16:40:03 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:43946 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbYJOUkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 16:40:00 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Trond.Myklebust@netapp.com
Subject: Re: [PATCH 3/6] vfs: add __d_instantiate() helper
References: <fcaad2cb3e848f5f6f1126623.ps@mail.parknet.co.jp>
	<e015bca83e848f5f6f2226623.ps@mail.parknet.co.jp>
	<7754d3f83e848f5f6f2326623.ps@mail.parknet.co.jp>
	<20081015194119.GA24892@infradead.org>
Date: Thu, 16 Oct 2008 05:39:56 +0900
In-Reply-To: <20081015194119.GA24892@infradead.org> (Christoph Hellwig's
	message of "Wed, 15 Oct 2008 15:41:19 -0400")
Message-ID: <87wsg9oan7.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Wed, Oct 15, 2008 at 10:58:10PM +0900, OGAWA Hirofumi wrote:
>> 
>> This adds __d_instantiate() for users which is already taking
>> dcache_lock, and replace with it.
>> 
>> The part of d_add_ci() isn't equivalent. But it should be needed
>> fsnotify_d_instantiate() actually, because the path is to add the
>> inode to negative dentry.  fsnotify_d_instantiate() should be called
>> after change from negative to positive.
>> 
>> __d_instantiate_unique() and d_materialise_unique() does opencoded
>> optimized version. From history, it seems a intent, so just add comment.
>
> Looks good, but I think those "optimized' version should also be
> converted, a single if shouldn't matter with todays branch predictors.

Me too.

Trond, do you care the following convert? E.g.

in d_materialise_unique():

from
		dentry->d_inode = NULL;
		goto found_lock;
to
		__d_instantiate(dentry, NULL);
		goto found_lock;
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
