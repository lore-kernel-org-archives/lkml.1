Return-Path: <linux-kernel-owner+w=401wt.eu-S932639AbXK3M65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639AbXK3M65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 07:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756832AbXK3M6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 07:58:48 -0500
Received: from sacred.ru ([62.205.161.221]:54487 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538AbXK3M6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 07:58:47 -0500
Message-ID: <475008F5.3000506@openvz.org>
Date: Fri, 30 Nov 2007 15:58:29 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH 0/7] Start using sysctl paths in the core kernel code
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 30 Nov 2007 15:58:31 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The patches from Eric, that add support for so called ctl_paths
has recently being accepted, so I hope we can start using this
very useful feature.

To begin with, I switched the core kernel code to use the paths.
The rest code to be patched (after this set) will be:
 * arch-specifi,
 * some filesystems,
 * networking.

After this set the total vmlinux size decrease is ~500 bytes:

add/remove: 5/6 grow/shrink: 5/1 up/down: 121/-616 (-495)
function                                     old     new   delta
mq_sysctl_path                                 -      24     +24
fs_quota_path                                  -      24     +24
uts_root_path                                  -      16     +16
sd_ctl_path                                    -      16     +16
ipc_root_path                                  -      16     +16
utsname_sysctl_init                           13      18      +5
register_sched_domain_sysctl                 762     767      +5
ipc_sysctl_init                               13      18      +5
init_mqueue_fs                               165     170      +5
dquot_init                                   191     196      +5
uts_root_table                                88       -     -88
sys_table                                     88       -     -88
sd_ctl_root                                   88       -     -88
mq_sysctl_root                                88       -     -88
mq_sysctl_dir                                 88       -     -88
ipc_root_table                                88       -     -88
fs_table                                     792     704     -88

The set is prepared to fit the 2.6.24-rc3-mm2 kernel with Eric's
patches concerning sysctls.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
