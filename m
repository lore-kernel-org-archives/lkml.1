Return-Path: <linux-kernel-owner+w=401wt.eu-S1751079AbXBNE2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751079AbXBNE2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 23:28:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbXBNE2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 23:28:53 -0500
Received: from ns2.suse.de ([195.135.220.15]:55289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbXBNE2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 23:28:53 -0500
Date: Wed, 14 Feb 2007 05:28:43 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [patch] mm: NUMA replicated pagecache
Message-ID: <20070214042843.GD7125@wotan.suse.de>
References: <20070213060924.GB20644@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213060924.GB20644@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 07:09:24AM +0100, Nick Piggin wrote:
> 
> Issues:
> - Not commented. I want to change the interfaces around anyway.
> - Breaks filesystems that use filemap_nopage, but don't call filemap_mkwrite
>   (eg. XFS). Fix is trivial for most cases.
> - Haven't tested NUMA yet (only tested via a hack to do per-CPU replication)
> - Would like to be able to control replication via userspace, and maybe
>   even internally to the kernel.
> - Ideally, reclaim might reclaim replicated pages preferentially, however
>   I aim to be _minimally_ intrusive.
> - Would like to replicate PagePrivate, but filesystem may dirty page via
>   buffers. Any solutions? (currently should mount with 'nobh').

Hmm, I guess we should be able to do this for pagecache of regular files,
as filesystems should not have any business dirtying that.
