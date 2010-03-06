Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab0CFR1f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 12:27:35 -0500
Received: from mail-iw0-f202.google.com ([209.85.223.202]:33182 "EHLO
	mail-iw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab0CFR1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 12:27:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rwieXv1ySWyQclYouID/Gxx7Y/VwEzy67Mkb0rYatAjm+BaGG397gCf1yMPAlPR07o
         FaWM1S7sUaMqTNNfQDs29+T+uD8FIvA8h/T4AsgA2/SaYWATZixgEZVXKf1WehZ+IPPn
         i11BHkNeanJ2XK+JWTnnxvC6Y7NxOmjuh5egw=
Date: Sat, 6 Mar 2010 09:27:27 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, James Morris <jmorris@namei.org>
Subject: Re: Selinux going crazy in 2.6.34-rc0
Message-ID: <20100306172727.GA13120@core.coreip.homeip.net>
References: <20100306102919.GA2341@core.coreip.homeip.net>
 <20100306104946.GB30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100306104946.GB30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 06, 2010 at 10:49:46AM +0000, Al Viro wrote:
> On Sat, Mar 06, 2010 at 02:29:19AM -0800, Dmitry Torokhov wrote:
> > Hi,
> > 
> > Selinux generates insane amounts of denial messages like the following
> > over and over again:
>  
> > type=SYSCALL msg=audit(1267870752.587:23084): arch=c000003e syscall=0 success=no exit=-13 a0=5 a1=2049af0 a2=400 a3=0 items=0 ppid=1 pid=1807 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="polkitd" exe="/usr/libexec/polkit-1/polkitd" subj=system_u:system_r:policykit_t:s0-s0:c0.c1023 key=(null)
> > type=AVC msg=audit(1267870752.587:23085): avc:  denied  { ioctl } for pid=1807 comm="polkitd" path="anon_inode:inotify" dev=anon_inodefs ino=839 scontext=system_u:system_r:policykit_t:s0-s0:c0.c1023 tcontext=system_u:object_r:anon_inodefs_t:s0 tclass=file
> > type=SYSCALL msg=audit(1267870752.587:23085): arch=c000003e syscall=16 success=no exit=-13 a0=5 a1=541b a2=7fff7b494bec a3=0 items=0 ppid=1 pid=1807 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="polkitd" exe="/usr/libexec/polkit-1/polkitd" subj=system_u:system_r:policykit_t:s0-s0:c0.c1023 key=(null)
> > type=AVC msg=audit(1267870752.587:23086): avc:  denied  { read } for pid=1807 comm="polkitd" path="anon_inode:inotify" dev=anon_inodefs ino=839 scontext=system_u:system_r:policykit_t:s0-s0:c0.c1023 tcontext=system_u:object_r:anon_inodefs_t:s0 tclass=file
> > type=SYSCALL msg=audit(1267870752.587:23086): arch=c000003e syscall=0 success=no exit=-13 a0=5 a1=2049af0 a2=400 a3=0 items=0 ppid=1 pid=1807 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="polkitd" exe="/usr/libexec/polkit-1/polkitd" subj=system_u:system_r:policykit_t:s0-s0:c0.c1023 key=(null)
> > type=AVC msg=audit(1267870752.587:23087): avc:  denied  { ioctl } for pid=1807 comm="polkitd" path="anon_inode:inotify" dev=anon_inodefs ino=839 scontext=system_u:system_r:policykit_t:s0-s0:c0.c1023 tcontext=system_u:object_r:anon_inodefs_t:s0 tclass=file
> > type=SYSCALL msg=audit(1267870752.587:23087): arch=c000003e syscall=16 success=no exit=-13 a0=5 a1=541b a2=7fff7b494bec a3=0 items=0 ppid=1 pid=1807 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="polkitd" exe="/usr/libexec/polkit-1/polkitd" subj=system_u:system_r:policykit_t:s0-s0:c0.c1023 key=(null)
>  
> Interesting...  That smells like a selinux policy that needed recognition
> of inotify file descriptors and got b0rken by
> commit c44dcc56d2b5c79ba3063d20f76e5347e2e418f6
> that switched inotify to use of anon_inodes.  Could you check if that's the
> trigger?

Yep, that was it. With this commit reverted selinux stays quiet.
Well, almost, it is never completely quiet ;).

Thank you Al.

-- 
Dmitry
