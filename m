Return-Path: <linux-kernel-owner+w=401wt.eu-S934601AbXHAPOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934601AbXHAPOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933650AbXHAPOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:14:40 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:21462 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270AbXHAPOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:14:39 -0400
Date: Wed, 1 Aug 2007 16:13:46 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Jan Blunck <jblunck@suse.de>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC 11/26] tmpfs white-out support
In-Reply-To: <20070730161324.160845468@weierstrass.suse.de>
Message-ID: <Pine.LNX.4.64.0708011559340.19454@blonde.wat.veritas.com>
References: <20070730161323.100048969@weierstrass.suse.de>
 <20070730161324.160845468@weierstrass.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABGluYm94AGxpbnV4LWZzZGV2ZWxAdmdlci5rZXJuZWwub3JnAGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAamJsdW5ja0BzdXNlLmRlAGJoYXJhdGFAbGludXgudm5ldC5pYm0uY29tAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2007, Jan Blunck wrote:

> Introduce white-out support to tmpfs.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> ---
>  include/linux/shmem_fs.h |    1 
>  mm/shmem.c               |   54 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 55 insertions(+)

I see there's debate about whether this (and its fellows) give the
right semantic to whiteouts; and I've not begun to think about that.

But as a patch to tmpfs for what you're trying to do, it looks just
about fine.  I say "just about" because the reference counting looks
right, but I wouldn't dare say that it _is_ right without testing.

And I'd probably want to add a minor adjustment, so that a mount with
nr_inodes=1000 could still support exactly 1000 inodes, despite your
allocating one for the whiteout (usually never used) at mount time.
But that can follow along later, no problem.

Hugh
