Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798Ab0A2HWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab0A2HWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 02:22:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287Ab0A2HWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 02:22:03 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:51245 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab0A2HWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 02:22:01 -0500
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, akpm@linux-foundation.org
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
References: <20100129070516.4058.77227.sendpatchset@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 28 Jan 2010 23:21:46 -0800
In-Reply-To: <20100129070516.4058.77227.sendpatchset@localhost.localdomain> (Amerigo Wang's message of "Fri\, 29 Jan 2010 02\:01\:53 -0500")
Message-ID: <m1eil9v0j9.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <amwang@redhat.com> writes:

> Recently we met a lockdep warning from sysfs during s2ram or cpu hotplug.
> As reported by several people, it is something like:
>
> [ 6967.926563] ACPI: Preparing to enter system sleep state S3
> [ 6967.956156] Disabling non-boot CPUs ...
> [ 6967.970401]
> [ 6967.970408] =============================================
> [ 6967.970419] [ INFO: possible recursive locking detected ]
> [ 6967.970431] 2.6.33-rc2-git6 #27
> [ 6967.970439] ---------------------------------------------
> [ 6967.970450] pm-suspend/22147 is trying to acquire lock:
> [ 6967.970460]  (s_active){++++.+}, at: [<c10d2941>]
> sysfs_hash_and_remove+0x3d/0x4f
> [ 6967.970493]
> [ 6967.970497] but task is already holding lock:
> [ 6967.970506]  (s_active){++++.+}, at: [<c10d4110>]
> sysfs_get_active_two+0x16/0x36
> [...]
>
> Eric already provides a patch for this[1], but it still can't fix the
> problem. I add the missing part of Eric's patch and send these two patches
> together, hopefully we can fix the warning completely.
>
> 1. http://lkml.org/lkml/2010/1/10/282
>
>
> Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> Reported-by: Miles Lane <miles.lane@gmail.com>
> Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

Thanks for following up on this.

I suspect we may want to create a separate class for each sysfs file
instead of playing whack-a-mole and creating a subclass each time we
have problems.

I don't see why the rules for one sysfs file should be the same as for
any other sysfs file.

Eric

