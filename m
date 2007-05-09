Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbXEIUe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbXEIUe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 16:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758806AbXEIUeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 16:34:00 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758751AbXEIUd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 16:33:58 -0400
Date: Wed, 9 May 2007 13:33:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org, clameter@sgi.com
Subject: Re: [PATCH 2/2] Call percpu smp cacheline algin interface
Message-Id: <20070509133328.c79ef48e.akpm@linux-foundation.org>
In-Reply-To: <20070507225944.GA15372@linux-os.sc.intel.com>
References: <33E1C72C74DBE747B7B59C1740F7443701A2F0AB@orsmsx417.amr.corp.intel.com>
	<20070505001231.GA27263@linux-os.sc.intel.com>
	<20070507225944.GA15372@linux-os.sc.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2007 15:59:44 -0700
Fenghua Yu <fenghua.yu@intel.com> wrote:

> On Fri, May 04, 2007 at 05:12:31PM -0700, Fenghua Yu wrote:
> > 
> > Call percpu smp cacheline align interface.
> > 
> 
> This is updated patch. Use new macro name DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED for better code understanding.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

hm, DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED is a bit of a mouthful.

I wonder if we can improve things here so that we use the runtime-detected
cacheline size rather than the compile-time size.  I guess not, given that
the offsets into the percpu area are calculated at build-time.

Did you work out how much space this change will actually save?  It
should be available by suitable crunching on the nm and objdump output.
