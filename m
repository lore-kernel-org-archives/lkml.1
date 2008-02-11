Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbYBKM11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbYBKM11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 07:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbYBKM1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 07:27:19 -0500
Received: from cerberus.nrc.co.nz ([60.234.156.227]:39824 "EHLO
	cerberus.nrc.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbYBKM1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 07:27:18 -0500
X-Greylist: delayed 2442 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Feb 2008 07:27:18 EST
Message-ID: <47B03592.20505@nrc.co.nz>
Date: Tue, 12 Feb 2008 00:46:26 +1300
From: "Nick 'Zaf' Clifford" <zaf@nrc.co.nz>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Zaf <zaf@nrc.co.nz>
Subject: if (2.6.24.1 && capset && bind9) bug()
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC me on any/all replies

After trying to upgrade to deal with the most recent security issue, I
have encountered what has to either be me being very tired, or a kernel
bug. After assuming that it was the former for 3 hours, I now conclude
I'm more tired, and it has to be the latter.

Relevant versions:
Bind: 9.3.4
Kernel: Linux version 2.6.24.1.cerberus.1 (zaf@cerberus) (gcc version
4.1.2 (Ubuntu 4.1.2-0ubuntu4)) #1 SMP Mon Feb 11 20:05:58 NZDT 2008
Distro: Ubuntu Feisty
Processor: AMD Athlon

# cat /proc/cmdline
root=UUID=0996d997-a1f5-4601-964e-f3e71a477b81 ro quiet splash

Relevant .config settings (please let me know if more are needed):
CONFIG_SECURITY=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_CAPABILITIES=y
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=0
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT is not set
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set

(Note: tried with CONFIG_SECURITY_CAPABILITIES=n and same result)

relevant line from strace starting bind:
# strace -ff named -u bind 2> /tmp/bind.log

...
capset(0x19980330, 0,
{CAP_DAC_READ_SEARCH|CAP_SETGID|CAP_SETUID|CAP_NET_BIND_SERVICE|CAP_SYS_CHROOT|CAP_SYS_RESOURCE,
CAP
_DAC_READ_SEARCH|CAP_SETGID|CAP_SETUID|CAP_NET_BIND_SERVICE|CAP_SYS_CHROOT|CAP_SYS_RESOURCE,
0}) = -1 EPERM (Operation not
 permitted)
...

What have I tried?

Tried it on two different systems, with the SEC CAP on and off.

Why do I think this is a kernel bug?

1) I revert to older kernel (2.6.22.1), no problems. Upgrade to
2.6.24.1. Problems.
2) Googling for "2.6.24 capset named" produces a lot of comments on the
mm tree about a breakage. It looked like it was fixed, but I'm obviously
not sure now.


So, someone please tell me either that I'm very very tired, and it must
be my config, or that it IS a kernel bug, and hopefully provide a nice
little patch to apply.

Once again, please CC me on replies,

Thanks,
Nick

