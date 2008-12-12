Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbYLLR1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbYLLR1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 12:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756933AbYLLR1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 12:27:12 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:60439 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756880AbYLLR1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 12:27:11 -0500
Subject: Re: [PATCH 12/15] kmemleak: Enable the building of the memory leak
	detector
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1228936817.9737.102.camel@nimitz>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182800.30323.49209.stgit@pc1117.cambridge.arm.com>
	 <1228936817.9737.102.camel@nimitz>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 12 Dec 2008 17:27:06 +0000
Message-Id: <1229102826.15045.75.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2008 17:27:07.0629 (UTC) FILETIME=[DB93A1D0:01C95C7E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-10 at 11:20 -0800, Dave Hansen wrote:
> On Wed, 2008-12-10 at 18:28 +0000, Catalin Marinas wrote:
> > +config DEBUG_MEMLEAK
> > +       bool "Kernel memory leak detector"
> > +       default n
> > +       depends on EXPERIMENTAL
> > +       select DEBUG_SLAB if SLAB
> > +       select SLUB_DEBUG if SLUB
> > +       select DEBUG_FS
> > +       select STACKTRACE
> > +       select FRAME_POINTER
> > +       select KALLSYMS
> 
> So, not all architectures have STACKTRACE or FRAME_POINTER.  I think a
> few of these should at least be done with depends.

I think it could depend on STACKTRACE_SUPPORT. Alternatively, it could
select STACKTRACE only if it is supported, though for architectures
without it, the kmemleak reports wouldn't be very useful.

Does FRAME_POINTER even matter? I think STACKTRACE should be enough to
get the backtrace. I even have some ARM patches for stack unwinding
where FRAME_POINTER is disabled (and shouldn't be enabled).

> Is this feature accessible if DEBUG_FS=n?  It seems to compile OK, but I
> wonder if it is useful.

Well, it is recommended. If you don't have this, you can't trigger a
scan manually by reading the /sys/kernel/debug/memleak file (have to
rely on the automatic thread). In my local tree (not published yet), I
also added support for run-time configuration by writing to this file.
Is there any disadvantage in always selecting DEBUG_FS?

Thanks.

-- 
Catalin

