Return-Path: <linux-kernel-owner+w=401wt.eu-S1753145AbYKQOCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbYKQOCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 09:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbYKQOCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 09:02:41 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:37940 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbYKQOCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 09:02:40 -0500
Date: Mon, 17 Nov 2008 14:02:59 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Victoria Muntean <vikimun@gmail.com>
cc: Kernel Linux <linux-kernel@vger.kernel.org>
Subject: Re: size of swapped-out part of the process
In-Reply-To: <ab4346860811170453i2bba95a6nb16c2c9e59424272@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0811171343340.11044@blonde.site>
References: <ab4346860811170452t2cbcb451u407edca19c9e0ba6@mail.gmail.com>
 <ab4346860811170453i2bba95a6nb16c2c9e59424272@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008, Victoria Muntean wrote:
> How can I calculate size of swapped-out part of the process from
> /proc/PID/*, even if approximately ?
> For example, I have VmSize=1216192 kB, VmRSS = 628788 kB, but global
> swap-in-use==0.
> Hence (VmSize - VmRSS) is far from being swapped-out part of the
> process. What is ?

I'm sorry, we don't record those numbers per process or per mm,
so you won't find them in /proc/PID/status or /proc/PID/statm.

And we'd probably resist accepting a patch to add them,
so as not to enlarge key data structures to hold them.

There's also an ambiguity about what "swapped-out" means: does
it include shared file pages which were once mapped into the
process, but have since been freed under memory pressure?

But it looks like you're interested in swapped-out to mean written
on swap.  In that case, if you have CONFIG_PROC_PAGE_MONITOR=y,
you can read /proc/PID/smaps and add up all the "Swap:" lines.

But don't keep reading it in a tight loop: that would
tend to detract from the performance of your system.

Hugh
