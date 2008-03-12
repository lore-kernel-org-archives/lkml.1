Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbYCLVdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbYCLVdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 17:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYCLVc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 17:32:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41892 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbYCLVc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 17:32:57 -0400
Date: Wed, 12 Mar 2008 21:32:55 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rik van Riel <riel@redhat.com>
Cc: "J.C. Pizarro" <jcpiza@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux+glibc memory allocator, poor performance
Message-ID: <20080312213255.GM27894@ZenIV.linux.org.uk>
References: <998d0e4a0803121309s125dddbao801e53e44296a4d6@mail.gmail.com> <20080312172221.6b6dba95@bree.surriel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312172221.6b6dba95@bree.surriel.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 05:22:21PM -0400, Rik van Riel wrote:
> On Wed, 12 Mar 2008 21:09:04 +0100
> "J.C. Pizarro" <jcpiza@gmail.com> wrote:
> 
> > Assume a SMP system that has 8 CPUs. The main problem of requesting
> > pages is the BKL (Big Kernel Lock) in this SMP system used for mutual
> > exclusion of the shared resource (the memory).
> > 
> > To solve this major problem, i propose you freely to allocate 8 local caches
> > of (e.g.) 2 MiB each CPU (total 2MiB x 8 CPUs = 16 MiB) acting as
> > 8 producer buffers for globally many consumer tasks (e.g. >= 20).
> > 
> > When the some producer buffer is empty then it does unfrequently BKL to
> > allocate another 2 MiB more from the shared resource (the memory).
> 
> You really should read the source code before proposing ideas.
> 
> The kernel has done roughly what you describe since a little before
> 2.6.0.

ITYM a little before 2.4.0, and even prior to that it hadn't been under BKL.
