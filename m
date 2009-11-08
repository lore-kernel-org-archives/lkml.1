Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbZKHWpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbZKHWpj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 17:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755613AbZKHWpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 17:45:39 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:45875 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592AbZKHWpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 17:45:38 -0500
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Leo Chen <leochen@broadcom.com>
Subject: Re: [PATCH 22/23] sysctl arm: Remove binary sysctl support
References: <m14op5jjo4.fsf@fess.ebiederm.org>
	<1257682930-31401-22-git-send-email-ebiederm@xmission.com>
	<20091108123422.GA9145@flint.arm.linux.org.uk>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 08 Nov 2009 14:45:36 -0800
In-Reply-To: <20091108123422.GA9145@flint.arm.linux.org.uk> (Russell King's message of "Sun\, 8 Nov 2009 12\:34\:22 +0000")
Message-ID: <m1pr7siqjz.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King <rmk+lkml@arm.linux.org.uk> writes:

>
> NAK.  Glibc uses these numeric sysctls to support ioperm emulation on ARM.
> Therefore, removal of these numeric sysctls breaks that user interface:
>
>   static int iobase_name[] = { CTL_BUS, BUS_ISA, BUS_ISA_PORT_BASE };
>   static int ioshift_name[] = { CTL_BUS, BUS_ISA, BUS_ISA_PORT_SHIFT };
>   if (! sysctl (iobase_name, 3, &io.io_base, &len, NULL, 0)
>       && ! sysctl (ioshift_name, 3, &io.shift, &len, NULL, 0))
>     {
>       io.initdone = 1;
>       return 0;
>     }

Those still exist in sysctl_binary.c are provided by reading
/proc/sys/bus/isa/membase, /proc/sys/bus/isa/portbase, and
/proc/sys/bus/isa/portshift.

The practical difference is that /proc support now must be compiled
in to support sys_sysctl.

Eric
