Return-Path: <linux-kernel-owner+w=401wt.eu-S1757031AbXKNLM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbXKNLM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbXKNLMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:12:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59917
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751452AbXKNLMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:12:17 -0500
Date: Wed, 14 Nov 2007 03:12:16 -0800 (PST)
Message-Id: <20071114.031216.11725447.davem@davemloft.net>
To: hch@infradead.org
Cc: paulus@samba.org, akpm@linux-foundation.org, gregkh@suse.de,
       mucci@cs.utk.edu, eranian@hpl.hp.com, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       perfmon@napali.hpl.hp.com, andi@firstfloor.org,
       perfmon2-devel@lists.sourceforge.net, ospat-devel@cs.utk.edu,
       ptools-perfapi@cs.utk.edu
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071114110009.GA17833@infradead.org>
References: <20071114103805.GA16652@infradead.org>
	<18234.53558.883970.87414@cargo.ozlabs.ibm.com>
	<20071114110009.GA17833@infradead.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 14 Nov 2007 11:00:09 +0000

> I've done this a gazillion times before, so maybe instead of beeing a lazy
> bastard you could look up mailinglist archive.  It's not like this is the
> first discussion of perfmon.  But to get start look at the systems calls,
> many of them are beasts like:
> 
>   int pfm_read_pmds(int fd, pfarg_pmd_t *pmds, int n)
> 
> This is basically a read(2) (or for other syscalls a write) on something
> else than the file descriptor provided to the system call.   The right thing
> to do is obviously have a pmds and pmcs file in procfs for the thread beeing
> monitored instead of these special-case files, with another set for global
> tracing.  Similarly I'm pretty sure we can get a much better interface
> if we introduce marching files in procfs for the other calls.

This is my impression too, all of the things being done with
a slew of system calls would be better served by real special
files and appropriate fops.  Whether the thing is some kind
of misc device or procfs is less important than simply getting
away from these system calls.
