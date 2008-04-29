Return-Path: <linux-kernel-owner+w=401wt.eu-S1760625AbYD3MRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625AbYD3MRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 08:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762272AbYD3MR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 08:17:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39438 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761969AbYD3MR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 08:17:27 -0400
Date: Tue, 29 Apr 2008 07:17:15 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russ Anderson <rja@sgi.com>, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, torvalds@linux-foundation.org,
       tony.luck@intel.com, clameter@sgi.com
Subject: Re: [PATCH 1/2] mm: Avoid putting a bad page back on the LRU
Message-ID: <20080429071715.5d39d9c1@infradead.org>
In-Reply-To: <20080429143329.3a17ef91.akpm@linux-foundation.org>
References: <20080428192358.GB14629@sgi.com>
	<20080429143329.3a17ef91.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 14:33:29 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 28 Apr 2008 14:23:58 -0500
> Russ Anderson <rja@sgi.com> wrote:
> 
> > --- test.orig/include/linux/kernel.h	2008-04-25
> > 15:22:07.640501421 -0500 +++ test/include/linux/kernel.h
> > 2008-04-25 15:42:02.826266036 -0500 @@ -412,6 +412,7 @@ struct
> > sysinfo { unsigned long totalhigh;	/* Total high memory size
> > */ unsigned long freehigh;		/* Available high memory
> > size */ unsigned int mem_unit;		/* Memory unit size
> > in bytes */
> > +	unsigned int badpages;		/* Number of bad
> > (PG_memerror) pages */ char
> > _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses
> > this.. */ };
> 
> eek.  sys_sysinfo() copies this structure out to userspace verbatim. 
> Increasing its size by four bytes will cause memory scribbles in
> userspace applications.

not if you also reduce the padding ??


