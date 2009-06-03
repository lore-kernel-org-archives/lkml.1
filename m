Return-Path: <linux-kernel-owner+w=401wt.eu-S1757988AbZFCOId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbZFCOId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757273AbZFCOIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:08:10 -0400
Received: from tango.0pointer.de ([85.214.72.216]:43004 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757684AbZFCOII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:08:08 -0400
Date: Wed, 3 Jun 2009 16:07:43 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scheduler: introduce SCHED_RESET_ON_FORK scheduling
	policy flag, Second try
Message-ID: <20090603140742.GA22953@tango.0pointer.de>
References: <20090529083840.GA15516@omega>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090529083840.GA15516@omega>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29.05.09 10:38, Lennart Poettering (mzxreary@0pointer.de) wrote:

> This patch introduces a new flag SCHED_RESET_ON_FORK which can be passed
> to the kernel via sched_setscheduler(), ORed in the policy parameter. If
> set this will make sure that when the process forks a) the scheduling
> priority is reset to DEFAULT_PRIO if it was higher and b) the scheduling
> policy is reset to SCHED_NORMAL if it was either SCHED_FIFO or SCHED_RR.

[...]

> This current patch compiles but is not otherwise tested. For now, I am
> sending this primarily as a request for comments. So please, I'd love to
> hear your comments!

I have now done some testing to make sure it actually works as
advertised. Everything seems to be fine. For those interested here's a
little test program that verifies that RR scheduling is properly
removed from the child process but is kept enabled in the parent process:

http://0pointer.de/public/reset-on-fork.c
 
Ingo, how can I bribe you into taking this patch, or at least
commenting on it?

Thanks,

Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
