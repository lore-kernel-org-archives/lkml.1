Return-Path: <linux-kernel-owner+w=401wt.eu-S1762320AbYCFHS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762320AbYCFHS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 02:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757759AbYCFHSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 02:18:17 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:51284 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207AbYCFHSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 02:18:15 -0500
Date: Thu, 06 Mar 2008 00:17:34 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC, PATCH 6/6] ext3: do not write to the disk when mounting	a
 dirty read-only filesystem
In-reply-to: <f4577a0cc4262de0fbff02cae3858d2e2edfaaea.1204685366.git.duaneg@dghda.com>
To: Duane Griffin <duaneg@dghda.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>, sct@redhat.com, akpm@linux-foundation.org
Message-id: <20080306071734.GN3616@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com>
 <f4577a0cc4262de0fbff02cae3858d2e2edfaaea.1204685366.git.duaneg@dghda.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 06, 2008  01:59 +0000, Duane Griffin wrote:
> NOTE: For now I'm simply preventing filesystems requiring recovery from being
> remounted read-write. This breaks booting with an uncleanly mounted root
> filesystem!

I was going to ask about this - not being able to remount rw is a serious
problem because many users have only the root filesystem and this
limitation basically prevents this patch from being landable.

I'd suggest if the filesystem is going to be remounted read/write that
the journal mapping be discarded and the journal replayed.  Depending
on how you do the mapping it may be necessary to invalidate all of the
pages in the cache so that they don't reference the blocks in the journal.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

