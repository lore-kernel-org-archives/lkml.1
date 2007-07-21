Return-Path: <linux-kernel-owner+w=401wt.eu-S1764622AbXGUNbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764622AbXGUNbf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 09:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574AbXGUNbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 09:31:24 -0400
Received: from ns1.suse.de ([195.135.220.2]:57159 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755522AbXGUNbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 09:31:23 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Subject: NFS mount gives ENETDOWN in -git15
Date: Sat, 21 Jul 2007 15:31:17 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707211531.17750.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I tried to mount another nfs mount on a system running with nfsroot.
But I get

# mount basil:/home /basil/home/
mount: Network is down

The network is not down of course, the system is happily running with nfs root from that
server. Userland is older SUSE 10.0

Excerpt from strace mount:

-Andi

socket(PF_INET, SOCK_STREAM, IPPROTO_TCP) = 3
bind(3, {sa_family=AF_INET, sin_port=htons(938), sin_addr=inet_addr("0.0.0.0")}, 16) = -1 EADDRINUSE (Address already in use)
bind(3, {sa_family=AF_INET, sin_port=htons(939), sin_addr=inet_addr("0.0.0.0")}, 16) = 0
connect(3, {sa_family=AF_INET, sin_port=htons(900), sin_addr=inet_addr("10.23.204.1")}, 16) = 0
uname({sys="Linux", node="bigfoot", ...}) = 0
geteuid()                               = 0
getegid()                               = 0
getgroups(0, NULL)                      = 1
getgroups(1, [0])                       = 1
gettimeofday({1185029510, 644658}, NULL) = 0
write(3, "\200\0\0Td*\362{\0\0\0\0\0\0\0\2\0\1\206\245\0\0\0\2\0"..., 88) = 88
poll([{fd=3, events=POLLIN, revents=POLLIN}], 1, 20000) = 1
read(3, "\200\0\0<d*\362{\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4000) = 64
socket(PF_INET, SOCK_STREAM, IPPROTO_TCP) = 5
bind(5, {sa_family=AF_INET, sin_port=htons(939), sin_addr=inet_addr("0.0.0.0")}, 16) = -1 EADDRINUSE (Address already in use)
bind(5, {sa_family=AF_INET, sin_port=htons(940), sin_addr=inet_addr("0.0.0.0")}, 16) = 0
socket(PF_INET, SOCK_STREAM, IPPROTO_TCP) = 6
bind(6, {sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("0.0.0.0")}, 16) = 0
connect(6, {sa_family=AF_INET, sin_port=htons(111), sin_addr=inet_addr("10.23.204.1")}, 16) = 0
write(6, "\200\0\0008i \25\301\0\0\0\0\0\0\0\2\0\1\206\240\0\0\0"..., 60) = 60
poll([{fd=6, events=POLLIN, revents=POLLIN}], 1, 60000) = 1
read(6, "\200\0\0\34i \25\301\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 400) = 32
close(6)                                = 0
uname({sys="Linux", node="bigfoot", ...}) = 0
close(3)                                = 0
close(3)                                = -1 EBADF (Bad file descriptor)
rt_sigprocmask(SIG_BLOCK, ~[TRAP SEGV RTMIN RT_1], NULL, 8) = 0
mount("basil:/home", "/basil/home/", "nfs", MS_POSIXACL|MS_ACTIVE|MS_NOUSER|0xec0000, 0x51ba60) = -1 ENETDOWN (Network is down)
