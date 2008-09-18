Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbYIRNVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbYIRNVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 09:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbYIRNVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 09:21:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35653 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbYIRNVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 09:21:09 -0400
Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Martin Knoblauch <knobi@knobisoft.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Banks <gnb@melbourne.sgi.com>,
       linux-nfs list <linux-nfs@vger.kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <124712.40022.qm@web32602.mail.mud.yahoo.com>
References: <124712.40022.qm@web32602.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Thu, 18 Sep 2008 15:20:48 +0200
Message-Id: <1221744048.15314.30.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-18 at 01:38 -0700, Martin Knoblauch wrote:

>  I believe Peter wanted to add per bdi stuff for nfs some time ago. Not sure what came out of it.

$ mount localhost:/ /mnt/tmp
$ grep nfs /proc/$$/mountinfo
21 17 0:17 / /var/lib/nfs/rpc_pipefs rw - rpc_pipefs rpc_pipefs rw
31 13 0:20 / /proc/fs/nfsd rw - nfsd nfsd rw
37 17 0:22 / /mnt/tmp rw - nfs localhost:/ rw,vers=3,rsize=65536,wsize=65536,namlen=255,hard,nointr,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=127.0.0.1,mountvers=3,mountproto=tcp,addr=127.0.0.1
$ ls -la /sys/class/bdi/0\:22/
total 0
drwxr-xr-x  3 root root    0 2008-09-18 15:16 .
drwxr-xr-x 21 root root    0 2008-09-18 15:16 ..
-rw-r--r--  1 root root 4096 2008-09-18 15:19 max_ratio
-rw-r--r--  1 root root 4096 2008-09-18 15:19 min_ratio
drwxr-xr-x  2 root root    0 2008-09-18 15:19 power
-rw-r--r--  1 root root 4096 2008-09-18 15:19 read_ahead_kb
lrwxrwxrwx  1 root root    0 2008-09-18 15:19 subsystem -> ../../bdi
-rw-r--r--  1 root root 4096 2008-09-18 15:19 uevent
$ cat /sys/class/bdi/0\:22/read_ahead_kb
960




