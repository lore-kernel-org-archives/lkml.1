Return-Path: <linux-kernel-owner+w=401wt.eu-S1760521AbYBHQtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760521AbYBHQtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 11:49:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758502AbYBHQsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 11:48:54 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:55865 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759318AbYBHQsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 11:48:53 -0500
Message-ID: <47AC87E1.7090803@kernel.org>
Date: Fri, 08 Feb 2008 08:48:33 -0800
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Kohei KaiGai <kaigai@ak.jp.nec.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, akpm@osdl.org, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] exporting capability code/name pairs (try #4)
References: <47997122.3070504@ak.jp.nec.com> <479990A1.3050103@kernel.org> <4799CAE0.7010400@ak.jp.nec.com> <47A2AB60.5000403@ak.jp.nec.com> <20080204162103.GA20130@sergelap.ibm.com> <47A91B00.9080301@ak.jp.nec.com> <20080206050805.GD3258@sergelap.austin.ibm.com> <47AC23F1.5030300@ak.jp.nec.com>
In-Reply-To: <47AC23F1.5030300@ak.jp.nec.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

KaiGai,

Thanks for trying to accommodate me :-)

Kohei KaiGai wrote:
| In addition, Andrew suggested me to export these translation by symlinks
| to reduce the number of invocation of system call.

Yes, I wanted to make use of readlink() instead of open()/read()/close()
to access each unknown capability.

| However, current sysfs interface does not allows to create symlinks with
| invalid indication.

:-(

| Thus, this patch exports them as regular files.

What about using symlinks for the name files and text content for the
numeric ones? You could even drop the names/ and codes/ subdirectories too:

$ cat /sys/kernel/capability/20
cap_sys_pacct
$ ls -l /sys/kernel/capability/cap_mknod
lr--r--r--  1 root root 64 Feb  8 08:26 cap_mknod -> 27
$ cat /sys/kernel/capability/names/cap_mknod
cap_mknod

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFHrIfh+bHCR3gb8jsRAkueAKDYMu+so+YCJD9klNentiWlwZJXlQCgrzSa
tWr1XM1nKcvST1ScAfO27j4=
=w5N/
-----END PGP SIGNATURE-----
