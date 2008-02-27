Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbYB0NmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbYB0NmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 08:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbYB0NmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 08:42:01 -0500
Received: from twin.jikos.cz ([213.151.79.26]:48821 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbYB0NmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:42:00 -0500
Date: Wed, 27 Feb 2008 14:41:47 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: BuraphaLinux Server <buraphalinuxserver@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: at program breaks with kernel 2.6.24
In-Reply-To: <5d75f4610802270427y789ffae9ie2682059206eed51@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802271440400.7699@twin.jikos.cz>
References: <5d75f4610802270427y789ffae9ie2682059206eed51@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, BuraphaLinux Server wrote:

> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=463669
> I have the same problem - it is not debian specific.  Did the
> semantics of kill() change with the new kernel?  I thought as long as
> something is setuid, even with capability stuff around the setuid
> programs just get _all_ capabilities and would keep working.

Does this still happen to you with current mainline? If so, what is your 
.config? It works for me(TM):

read(0, "/bin/echo \"aaa\"\n", 1024)    = 16
write(2, "at> ", 4)                     = 4
read(0, "", 1024)                       = 0
write(2, "<EOT>\n", 6)                  = 6
write(4, "#!/bin/sh\n# atrun uid=1000 gid=1"..., 4076) = 4076
close(4)                                = 0
munmap(0x7f068f383000, 4096)            = 0
fchmod(5, 0700)                         = 0
close(5)                                = 0
stat("/etc/localtime", {st_mode=S_IFREG|0644, st_size=2246, ...}) = 0
write(2, "job 1 at 2008-02-27 14:42\n", 26) = 26
open("/var/run/atd.pid", O_RDONLY)      = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=5, ...}) = 0
fcntl(3, F_GETFL)                       = 0x8000 (flags 
O_RDONLY|O_LARGEFILE)
fstat(3, {st_mode=S_IFREG|0644, st_size=5, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 
0x7f068f383000
lseek(3, 0, SEEK_CUR)                   = 0
read(3, "5679\n", 4096)                 = 5
setreuid(1000, 25)                      = 0
setregid(100, 25)                       = 0
kill(5679, SIGHUP)                      = 0

(this is 2.6.25-rc3).

-- 
Jiri Kosina
SUSE Labs

