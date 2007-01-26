Return-Path: <linux-kernel-owner+w=401wt.eu-S1161043AbXAZPaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161043AbXAZPaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 10:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161044AbXAZPaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 10:30:17 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:34683 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161043AbXAZPaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 10:30:16 -0500
Date: Fri, 26 Jan 2007 09:29:07 -0600
From: Robin Holt <holt@sgi.com>
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Cc: akpm@osdl.org, pavel@suse.cz, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 0/4] coredump: core dump masking support v2
Message-ID: <20070126152907.GB30950@lnx-holt.americas.sgi.com>
References: <45BA0A93.30004@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BA0A93.30004@hitachi.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 11:05:07PM +0900, Kawai, Hidehiro wrote:
> You can specify memory segment types you don't want to dump via
> /proc/<pid>/core_flags file, which is provided per process.
> This file represents a set of flags, but currently, only bit 0 is
> available. If bit 0 is set, the kernel core dump routine doesn't
> dump anonymous shared memory segments, which includes IPC shared
> memory and some of mmap(2)'ed memory.

Can you make this a little more transparent?  Having a magic bitmask does
not seem like the best way to do stuff.  Could you maybe make a core_flags
directory with a seperate file for each flag.  It could still map to a
single field in the mm, but be broken out for the proc filesystem.

I can certainly see the value of this for our customers.  We have some
customers that run jobs in the 1-2TB range.  Most of those customers
have always had coredumps disabled and just rely upon being able to
rerun the application and have MPI drop them into a debugger.

Thanks,
Robin
