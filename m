Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab0CFK32 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 05:29:28 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:60342 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab0CFK30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 05:29:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ueQ9segJwektj50+1JrCZt1aOOPRLmfVL5ZXoIAZT/Wssg/3UCig+wCbJ45QI80+4K
         s+a4pwGzPHDbl5xPZQ8YuEbNUPquuW7dokcLfJ36xbGJGmI0GKdQevv4RrKVTZn7B9hV
         xw3bWQoRuQ/a9hVyRLNONqNEN5b5s/OnvOurw=
Date: Sat, 6 Mar 2010 02:29:19 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: James Morris <jmorris@namei.org>
Subject: Selinux going crazy in 2.6.34-rc0
Message-ID: <20100306102919.GA2341@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Selinux generates insane amounts of denial messages like the following
over and over again:

type=SYSCALL msg=audit(1267870752.587:23084): arch=c000003e syscall=0 success=no exit=-13 a0=5 a1=2049af0 a2=400 a3=0 items=0 ppid=1 pid=1807 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="polkitd" exe="/usr/libexec/polkit-1/polkitd" subj=system_u:system_r:policykit_t:s0-s0:c0.c1023 key=(null)
type=AVC msg=audit(1267870752.587:23085): avc:  denied  { ioctl } for pid=1807 comm="polkitd" path="anon_inode:inotify" dev=anon_inodefs ino=839 scontext=system_u:system_r:policykit_t:s0-s0:c0.c1023 tcontext=system_u:object_r:anon_inodefs_t:s0 tclass=file
type=SYSCALL msg=audit(1267870752.587:23085): arch=c000003e syscall=16 success=no exit=-13 a0=5 a1=541b a2=7fff7b494bec a3=0 items=0 ppid=1 pid=1807 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="polkitd" exe="/usr/libexec/polkit-1/polkitd" subj=system_u:system_r:policykit_t:s0-s0:c0.c1023 key=(null)
type=AVC msg=audit(1267870752.587:23086): avc:  denied  { read } for pid=1807 comm="polkitd" path="anon_inode:inotify" dev=anon_inodefs ino=839 scontext=system_u:system_r:policykit_t:s0-s0:c0.c1023 tcontext=system_u:object_r:anon_inodefs_t:s0 tclass=file
type=SYSCALL msg=audit(1267870752.587:23086): arch=c000003e syscall=0 success=no exit=-13 a0=5 a1=2049af0 a2=400 a3=0 items=0 ppid=1 pid=1807 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="polkitd" exe="/usr/libexec/polkit-1/polkitd" subj=system_u:system_r:policykit_t:s0-s0:c0.c1023 key=(null)
type=AVC msg=audit(1267870752.587:23087): avc:  denied  { ioctl } for pid=1807 comm="polkitd" path="anon_inode:inotify" dev=anon_inodefs ino=839 scontext=system_u:system_r:policykit_t:s0-s0:c0.c1023 tcontext=system_u:object_r:anon_inodefs_t:s0 tclass=file
type=SYSCALL msg=audit(1267870752.587:23087): arch=c000003e syscall=16 success=no exit=-13 a0=5 a1=541b a2=7fff7b494bec a3=0 items=0 ppid=1 pid=1807 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="polkitd" exe="/usr/libexec/polkit-1/polkitd" subj=system_u:system_r:policykit_t:s0-s0:c0.c1023 key=(null)

This is on updated Fedora 12, commit 64096c17417380d8a472d096645f4cbc9406c987.
2.6.33-rc8-ish works fine.

-- 
Dmitry
