Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbYCLVWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbYCLVWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 17:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYCLVWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 17:22:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbYCLVWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 17:22:31 -0400
Date: Wed, 12 Mar 2008 17:22:21 -0400
From: Rik van Riel <riel@redhat.com>
To: "J.C. Pizarro" <jcpiza@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux+glibc memory allocator, poor performance
Message-ID: <20080312172221.6b6dba95@bree.surriel.com>
In-Reply-To: <998d0e4a0803121309s125dddbao801e53e44296a4d6@mail.gmail.com>
References: <998d0e4a0803121309s125dddbao801e53e44296a4d6@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008 21:09:04 +0100
"J.C. Pizarro" <jcpiza@gmail.com> wrote:

> Assume a SMP system that has 8 CPUs. The main problem of requesting
> pages is the BKL (Big Kernel Lock) in this SMP system used for mutual
> exclusion of the shared resource (the memory).
> 
> To solve this major problem, i propose you freely to allocate 8 local caches
> of (e.g.) 2 MiB each CPU (total 2MiB x 8 CPUs = 16 MiB) acting as
> 8 producer buffers for globally many consumer tasks (e.g. >= 20).
> 
> When the some producer buffer is empty then it does unfrequently BKL to
> allocate another 2 MiB more from the shared resource (the memory).

You really should read the source code before proposing ideas.

The kernel has done roughly what you describe since a little before
2.6.0.

-- 
All rights reversed.
