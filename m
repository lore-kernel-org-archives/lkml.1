Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbXLRWYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbXLRWYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755662AbXLRWYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:24:30 -0500
Received: from waste.org ([66.93.16.53]:35903 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbXLRWY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:24:29 -0500
Date: Tue, 18 Dec 2007 16:22:59 -0600
From: Matt Mackall <mpm@selenic.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] procfs : Move some extern declaration from fs/proc/proc_misc.c to include/linux/seq_file.h
Message-ID: <20071218222259.GX17536@waste.org>
References: <47683ADE.3080107@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47683ADE.3080107@cosmosbay.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 10:25:50PM +0100, Eric Dumazet wrote:
> Some 'extern struct seq_operations' are wrongly defined in 
> fs/proc/proc_misc.c (they miss a const qualifier)
> 
> In order to fix this correctly, move the "extern ... " declaration from .c 
> file to an appropriate include file, as advised by checkpatch.pl
> 
> Note : "extern struct seq_operations cpuinfo_op;" will be taken into account
> in a separate patch, since its const status is arch dependant.

seq_file.h doesn't seem the best place for these, as it's otherwise
unpolluted with anything but seq_file internals.

Most of these things perhaps ought to be pushed out to their relevant
subsystems and then no .h file declaration will be needed.

-- 
Mathematics is the supreme nostalgia of our time.
