Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbXD0VcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbXD0VcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757344AbXD0VcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:32:22 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757343AbXD0VcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:32:21 -0400
Date: Fri, 27 Apr 2007 14:31:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: - maps2-add-proc-pid-pagemap-interface-fix.patch removed from
 -mm tree
Message-Id: <20070427143131.60d0afc1.akpm@linux-foundation.org>
In-Reply-To: <20070427204155.GT11115@waste.org>
References: <200704270814.l3R8EnFJ023047@shell0.pdx.osdl.net>
	<20070427104533.GA6001@localhost.sw.ru>
	<20070427132713.fc9d82c0.akpm@linux-foundation.org>
	<20070427204155.GT11115@waste.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 15:41:55 -0500
Matt Mackall <mpm@selenic.com> wrote:

> > +	no+_mmap_sem();						\
> 
> Except for this bit.

You'll put gcc out of a job ;)

> Maybe put it in the same config bucket as might_sleep?

hm, could do.  might_sleep() is intertwined with preempt in complex ways,
but we did decouple that at the config level.  no_mmap_sem() will dtrt for
all preempt settings.

But I'll be keeping this as a -mm-only debug patch (which brings us up to
about thirty of 'em), so I think it's best to make it unconfigurable so we
get maximum coverage.

That's if it actually works.  I haven't tried running it yet, and I have a
feeling that running it might cause a big "doh" moment.  We'll see.
