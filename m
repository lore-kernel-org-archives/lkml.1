Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbYKUV4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbYKUV4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 16:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYKUV4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 16:56:44 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:44348 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbYKUV4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 16:56:43 -0500
Date: Fri, 21 Nov 2008 23:56:38 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Patrick McHardy <kaber@trash.net>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Regression - Re: 2.6.28-rc2: runaway loop modprobe char-major-5-1
In-Reply-To: <49071A84.3080706@trash.net>
Message-ID: <Pine.SOC.4.64.0811212351200.16409@math.ut.ee>
References: <Pine.SOC.4.64.0810281212540.21462@math.ut.ee> <49071A84.3080706@trash.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > request_module: runaway loop modprobe char-major-5-1
> > 
> > and then hangs.
> > 
> > char-major-5-1 seems to mean ttyS0.
> 
> I'm seeing the same problem on a Debian unstable system using
> initramfs and dm-crypt, but it seems to be caused by userspace
> changes, using an old initramfs image with just the new modules
> added manually works fine (well, breaks elsewhere).

I have done some eveninfs testing, taking apart and putting together my 
own initramfs. It looks like this is a kernel bug, not userspace - the 
hang happens after initramfs is unpacked and after VFS and quotas are 
installed, and after "msgmni has been set to 627" message but before BSG 
loading message and before io scheduler initialization. And log before 
init is executed from initramfs (and no modprobe is executed either, as 
my wrapper does not run).

Rerepeating, same userspace generats fine initramfs for 2.6.27 and the 
initramfs contents are the same except modules tree that is for 
different version.

It happens on 2 of my computers, both have custom config (serial 
compiled in, not modular). The hang happens before ttyS driver 
initialization.

Seems like a kernel regression to me.

-- 
Meelis Roos (mroos@linux.ee)
