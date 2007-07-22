Return-Path: <linux-kernel-owner+w=401wt.eu-S1761650AbXGVRHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761650AbXGVRHM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 13:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbXGVRG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 13:06:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52146 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464AbXGVRG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 13:06:59 -0400
Date: Sun, 22 Jul 2007 18:06:57 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: sparse breakage (x86_64: Add vDSO for x86-64 with gettimeofday/clock_gettime/getcpu)
Message-ID: <20070722170657.GB21668@ftp.linux.org.uk>
References: <20070722160809.GA5803@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070722160809.GA5803@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 08:08:09PM +0400, Alexey Dobriyan wrote:
> Andi, with new vDSO code sparse fails to check with usual invocation here:

Fucks with CF and not in a good way...

CF := $(PROFILING) -mcmodel=small -fPIC -g0 -O2 -fasynchronous-unwind-tables -m64

$(obj)/vclock_gettime.o: CFLAGS = $(CF)
$(obj)/vgetcpu.o: CFLAGS = $(CF)

s/CF/CCF/ in there (arch/x86_64/vdso/Makefile) fixes gcc problems; sparse
ones remain and I'll look into that when I get some sleep (26 hours uptime
right now).  I think I have a good idea of what's going on there, but
I'd rather not touch that code until tonight.

For now just rename the variable in makefile (obviously the right thing
to do) and that will give you sparse runs not aborted at that point.
