Return-Path: <linux-kernel-owner+w=401wt.eu-S1756287AbYH2Afv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbYH2Afv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 20:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbYH2Afn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 20:35:43 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:43890 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbYH2Afm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 20:35:42 -0400
Message-ID: <48B74438.8070407@kernel.org>
Date: Thu, 28 Aug 2008 17:35:04 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Serge Hallyn <serue@us.ibm.com>
CC: linux-kernel@vger.kernel.org, dhowells@redhat.com, agruen@suse.de
Subject: Re: [PATCH 1/2] file capabilities: add no_file_caps switch (v2)
References: <> <f79cd5c96d2996b984fdfe1c7d8300975f55e8e6.1219951973.git.serue@us.ibm.com>
In-Reply-To: <f79cd5c96d2996b984fdfe1c7d8300975f55e8e6.1219951973.git.serue@us.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Acked-by: Andrew G. Morgan <morgan@kernel.org>

Cheers

Andrew

Serge Hallyn wrote:
| Add a no_file_caps boot option when file capabilities are
| compiled into the kernel (CONFIG_SECURITY_FILE_CAPABILITIES=y).
|
| This allows distributions to ship a kernel with file capabilities
| compiled in, without forcing users to use (and understand and
| trust) them.
|
| When no_file_caps is specified at boot, then when a process executes
| a file, any file capabilities stored with that file will not be
| used in the calculation of the process' new capability sets.
|
| This means that booting with the no_file_caps boot option will
| not be the same as booting a kernel with file capabilities
| compiled out - in particular a task with  CAP_SETPCAP will not
| have any chance of passing capabilities to another task (which
| isn't "really" possible anyway, and which may soon by killed
| altogether by David Howells in any case), and it will instead
| be able to put new capabilities in its pI.  However since fI
| will always be empty and pI is masked with fI, it gains the
| task nothing.
|
| We also support the extra prctl options, setting securebits and
| dropping capabilities from the per-process bounding set.
|
| The other remaining difference is that killpriv, task_setscheduler,
| setioprio, and setnice will continue to be hooked.  That will
| be noticable in the case where a root task changed its uid
| while keeping some caps, and another task owned by the new uid
| tries to change settings for the more privileged task.
|
| Signed-off-by: Serge Hallyn <serue@us.ibm.com>
| ---
|  include/linux/capability.h |    4 ++++
|  kernel/capability.c        |   11 +++++++++++
|  security/commoncap.c       |    9 +++++++++
|  3 files changed, 24 insertions(+), 0 deletions(-)
|
| diff --git a/include/linux/capability.h b/include/linux/capability.h
| index 9d1fe30..c96c455 100644
| --- a/include/linux/capability.h
| +++ b/include/linux/capability.h
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIt0Qi+bHCR3gb8jsRApyoAKC4brJOkrqsna3iDQ8xMFEPlyAW/wCbBHy+
xUaMSRInmcgNkYdoNJkxzOQ=
=zTib
-----END PGP SIGNATURE-----
