Return-Path: <linux-kernel-owner+w=401wt.eu-S2992862AbXDDLca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992862AbXDDLca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 07:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992866AbXDDLca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 07:32:30 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:57558 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992862AbXDDLc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 07:32:29 -0400
From: Nikita Danilov <nikita@clusterfs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17939.35217.938339.677599@gargle.gargle.HOWL>
Date: Wed, 4 Apr 2007 15:18:41 +0400
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/13] maps: Add /proc/pid/pagemap interface
Newsgroups: gmane.linux.kernel
In-Reply-To: <13.486631555@selenic.com>
References: <1.486631555@selenic.com>
	<13.486631555@selenic.com>
X-Mailer: VM 7.17 under 21.5 (patch 17) "chayote" (+CVS-20040321) XEmacs Lucid
X-SystemSpamProbe: GOOD 0.0000471 d3b1ff82328ab48c9bf8bb45937d3d3c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall writes:
 > Add /proc/pid/pagemap interface
 > 
 > This interface provides a mapping for each page in an address space to
 > its physical page frame number, allowing precise determination of what
 > pages are mapped and what pages are shared between processes.

[...]

 >  
 > +#ifdef CONFIG_PROC_PAGEMAP
 > +struct pagemapread {
 > +	struct mm_struct *mm;
 > +	unsigned long next;
 > +	unsigned long *buf;
 > +	unsigned long pos;
 > +	size_t count;
 > +	int index;
 > +	char __user *out;
 > +};
 > +
 > +static int flush_pagemap(struct pagemapread *pm)
 > +{
 > +	int n = min(pm->count, pm->index * sizeof(unsigned long));
 > +	if (copy_to_user(pm->out, pm->buf, n))
 > +		return -EFAULT;

This pushes binary data to the user space. Wasn't /proc supposed to be
ascii-based to avoid compatibility problems (e.g., size of unsigned long
changing, endianness, etc.)?

Nikita.

