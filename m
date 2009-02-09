Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbZBIUQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbZBIUQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 15:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZBIUQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 15:16:30 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:50570 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZBIUQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 15:16:29 -0500
X-BigFish: VPS-10(zz98dRzzzzz2fh6bh63h)
X-Spam-TCS-SCL: 2:0
Message-ID: <49908F14.50703@am.sony.com>
Date: Mon, 9 Feb 2009 12:16:20 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] ftrace, powerpc64: fix math to calculate offset in TOC
References: <alpine.DEB.1.10.0902080118480.30802@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0902080118480.30802@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2009 20:16:21.0506 (UTC) FILETIME=[46218E20:01C98AF3]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> I found the bug that was causing large modules to fail in setting
> up dynamic ftrace. It wound up being a simple math error. To calculate
> the offset in the TOC, I had used an OR, but the bottom half was
> a signed extended short, and it should have been an addition.
> The fix is in my tree below, as well as posted here.
> ----
>  arch/powerpc/kernel/ftrace.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)

I tested this on PS3 with CONFIG_FTRACE_SELFTEST=y and
CONFIG_FTRACE_SELFTEST=y, and all modules now load and
the system seems to work properly.  I did not run any
tracer specific tests though.

Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>



