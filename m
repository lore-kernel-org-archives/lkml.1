Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbYBUThR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbYBUThR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 14:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYBUThE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 14:37:04 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:48670 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbYBUThB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 14:37:01 -0500
Subject: Re: 2.6.25-rc2-mm1 - several bugs and a crash
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
In-Reply-To: <20080221043828.bcd5cbce.akpm@linux-foundation.org>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	 <47BC982C.7050402@imap.cc>
	 <20080221043828.bcd5cbce.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 11:36:47 -0800
Message-Id: <1203622607.29823.96.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-21 at 04:38 -0800, Andrew Morton wrote:
> 
> > <4>[    0.071378]  [do_name+279/440] do_name+0x117/0x1b8
> > <4>[    0.071570]  [write_buffer+34/49] write_buffer+0x22/0x31
> > <4>[    0.071763]  [flush_window+105/184] flush_window+0x69/0xb8
> > <4>[    0.071996]  [unpack_to_rootfs+1585/2238] unpack_to_rootfs+0x631/0x8be
> > <4>[    0.072192]  [trace_hardirqs_on_caller+248/301] ? trace_hardirqs_on_caller+0xf8/0x12d
> > <4>[    0.072440]  [restore_nocheck_notrace+0/16] ? restore_nocheck_notrace+0x0/0x10
> > <4>[    0.072689]  [populate_rootfs+37/270] populate_rootfs+0x25/0x10e
> > <4>[    0.072886]  [alternative_instructions+344/349] ? alternative_instructions+0x158/0x15d
> > <4>[    0.073139]  [start_kernel+840/858] start_kernel+0x348/0x35a
> > <4>[    0.073335]  =======================
> 
> (net-related cc's removed)
> 
> This look like a startup ordering bug in mnt_want_write().

Let me look into it a bit.  Although, it does seem that this stuff is
just calling into the filesystem code too early.  The mnt_writers[]
spinlocks are init'd with a:

	fs_initcall(init_mnt_writers);

and populate_rootfs() is supposed to happen in a rootfs_initcall() so
I'm a bit confused how it happened in this order.

-- Dave

