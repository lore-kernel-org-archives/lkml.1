Return-Path: <linux-kernel-owner+w=401wt.eu-S1760530AbYCFDoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760530AbYCFDoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 22:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbYCFDn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 22:43:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753619AbYCFDn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 22:43:57 -0500
Date: Wed, 5 Mar 2008 19:42:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Duane Griffin" <duaneg@dghda.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>, sct@redhat.com, adilger@clusterfs.com
Subject: Re: [RFC, PATCH 0/6] ext3: do not modify data on-disk when mounting
 read-only filesystem
Message-Id: <20080305194220.f9cce55e.akpm@linux-foundation.org>
In-Reply-To: <1204768754-29655-1-git-send-email-duaneg@dghda.com>
References: <1204768754-29655-1-git-send-email-duaneg@dghda.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 Mar 2008 01:59:08 +0000 "Duane Griffin" <duaneg@dghda.com> wrote:

> At present, as discussed in this LKML thread,
> http://marc.info/?l=linux-kernel&m=117607695406580, when a dirty ext3
> filesystem is mounted read-only it writes to the disk while replaying the
> journal log and cleaning up the orphan list. This behaviour may surprise users
> and can potentially cause data corruption/loss (e.g. if a system is suspended,
> booted into a different OS, then resumed).
> 
> This patch series attempts to address this by using a block translation table
> instead of replaying the journal on a read-only filesystem.
> 
> Patches 1-3 are independent cleanups/bug-fixes for things I came across while
> working on this. They could be submitted separately and are not required for
> following patches.
> 
> Patch 4 is a refactoring change that simplifies the code prior to later
> substantive changes.
> 
> Patch 5 introduces the translation table and support for a truly read-only
> journal into jbd.
> 
> Patch 6 uses the facility introduced in patch 5 to add support for true
> read-only ext3.

I'll grab the first three for now, thanks.

Someone(tm) should do the jbd2 versions..
