Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbZKVRu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbZKVRu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 12:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbZKVRu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 12:50:26 -0500
Received: from www.tglx.de ([62.245.132.106]:55584 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402AbZKVRuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 12:50:25 -0500
Date: Sun, 22 Nov 2009 18:49:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>, indexer@internode.on.net,
       Feng Tang <feng.tang@intel.com>, bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug 14658] Regression in efi.c
In-Reply-To: <200911212017.nALKHLSC029634@demeter.kernel.org>
Message-ID: <alpine.LFD.2.00.0911221817200.24119@localhost.localdomain>
References: <bug-14658-6666@http.bugzilla.kernel.org/> <200911212017.nALKHLSC029634@demeter.kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Nov 2009, bugzilla-daemon@bugzilla.kernel.org wrote:

Switched to email. Please reply by mail (reply-to-all) and not in the
bugzilla.

> --- Comment #1 from Rafael J. Wysocki <rjw@sisk.pl>  2009-11-21 20:17:21 ---
> Caused by:
> 
> commit 7bd867dfb4e0357e06a3211ab2bd0e714110def3

That's completely bogus. That commit is not in 2.6.31. It was merged in the
2.6.32 merge window.

>From the original bug report:

http://marc.info/?l=linux-kernel&m=125846988820120&w=4

> I would like to report a possible regression in efi.c with kernels
> 2.6.31 , 2.6.32-rc5 and 2.6.32.rc7.
>
> Attempting to boot x86_64 with elilo succeeds using 2.6.30 . Using the
> same config cannot boot with any of the 3 afore mentioned kernels.

So the problem exists with 2.6.31 already which excludes the above
commit.

The above commit indeed caused problems on 64bit efi systems in
2.6.32-rc. The fix was merged between 32-rc5 and 32-rc6.

The bisect was done with:

git bisect start
# good: [59a3759d0fe8d969888c741bb33f4946e4d3750d] Linux 2.6.30-rc7
git bisect good 59a3759d0fe8d969888c741bb33f4946e4d3750d
# bad: [156171c71a0dc4bce12b4408bb1591f8fe32dc1a] Linux 2.6.32-rc7

while the bisect should have be done with

good 2.6.30
bad  2.6.31

William, could you please go through the bisect pain again?

Thanks,

	tglx
