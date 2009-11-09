Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbZKIJiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbZKIJiD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:38:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbZKIJiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:38:02 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45916 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbZKIJiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:38:01 -0500
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/23] sysctl arm: Remove binary sysctl support
From: Andi Kleen <andi@firstfloor.org>
References: <m14op5jjo4.fsf@fess.ebiederm.org>
	<1257682930-31401-22-git-send-email-ebiederm@xmission.com>
	<20091108123422.GA9145@flint.arm.linux.org.uk>
	<m1pr7siqjz.fsf@fess.ebiederm.org> <m1hbt4ipni.fsf@fess.ebiederm.org>
	<20091108164855.595ec70d@infradead.org>
	<m1tyx49y44.fsf@fess.ebiederm.org>
	<20091108205725.28778016@infradead.org>
	<m1hbt45kcp.fsf@fess.ebiederm.org>
Date: Mon, 09 Nov 2009 10:38:05 +0100
In-Reply-To: <m1hbt45kcp.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Sun, 08 Nov 2009 21:37:58 -0800")
Message-ID: <87ocnc598i.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:
>
> The glibc pthread code that uses sysctl has no problems if sys_sysctl
> is gone.  It both falls back to reading /proc/sys and it just controls
> an optimization and the code works with either result.  Been there,
> done that.

/proc/sys is much slower than sysctl though. So you made program startup
slower.

Also I agree with Arjan that breaking such a common ABI is not
really a good idea. But I think it's enough to only handle
common sysctls that are actually used, which are very few.

It would be better to simply keep the commonly used binary sysctls
as emulation around always (commonly = used by glibc and perhaps
added by user printk feedback) That's very cheap because it's just
a simple translation and can be done internally cheaper than going
through the VFS with a bazillion of locks.


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
