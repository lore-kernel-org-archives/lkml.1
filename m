Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbYHRPvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbYHRPvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 11:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYHRPu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 11:50:59 -0400
Received: from mail.windriver.com ([147.11.1.11]:60290 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbYHRPu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 11:50:59 -0400
Message-ID: <48A99A68.6010102@windriver.com>
Date: Mon, 18 Aug 2008 10:51:04 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: amruth_pv@yahoo.com
CC: linux-kernel@vger.kernel.org
Subject: Re: KGDB 2..26 fails to wait while booting
References: <966386.75458.qm@web45216.mail.sp1.yahoo.com>
In-Reply-To: <966386.75458.qm@web45216.mail.sp1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Aug 2008 15:50:57.0781 (UTC) FILETIME=[348FB250:01C9014A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


amruth wrote:
> Thanks Jason. I got it working, but is it possible to enable kdb with kgdb. 
> How can I debug the kernel early. In kdb we have option called as kdb=early, can we do the same in kgdb. I tried to set breakpoint in kgdb at start_kernel, it looks like kgdb executed past the start_kernel code.Hence break point does not work.
> Please let me know how to enable debug early kernel option in KGDB. 
>
>   

This is a limitation of the kgdb which in the mainline sources.  The
kgdb core itself can support early debugging.

The kgdboc I/O module does not support early debugging however because
it waits for the tty driver to get setup.  There is an 8250_kgdb kernel
module which supports debugging from an ealier point than the kgdboc
driver but this is not in the main line sources.  You can get it from
the kgdb branch.

IE:

http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=commitdiff_plain;h=2e92260276c0948e260bb8a8399e20dfb5713f70

and

http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=commitdiff_plain;h=03e9da089af8813ac1947e5a078906652bd2fbb7

Jason.

