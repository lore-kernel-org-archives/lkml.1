Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbZKDLoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbZKDLoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 06:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbZKDLoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 06:44:22 -0500
Received: from www.tglx.de ([62.245.132.106]:40039 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320AbZKDLoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:44:21 -0500
Date: Wed, 4 Nov 2009 12:43:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Thierry Vignaud <tvignaud@mandriva.com>,
       bugzilla-daemon@bugzilla.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug 14537] New: missing compat_ioctl on x86_64
In-Reply-To: <bug-14537-6666@http.bugzilla.kernel.org/>
Message-ID: <alpine.LFD.2.00.0911041142370.12138@localhost.localdomain>
References: <bug-14537-6666@http.bugzilla.kernel.org/>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2005;0c(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Tue, 3 Nov 2009, bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=14537
> 
>            Summary: missing compat_ioctl on x86_64
>            Product: Platform Specific/Hardware
>            Version: 2.5
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: x86-64
>         AssignedTo: platform_x86_64@kernel-bugs.osdl.org
>         ReportedBy: tvignaud@mandriva.com
>         Regression: No
> 
> 
> I used to run 64bit userspace on 64bit kernel but I recently tried to run a
> 64bit kernel with as minimal as possible as 64bit userspace (that is
> rpm+glibc+... in order to mananage 64bit kernel packages).
> 
> This revealed several missing compat_ioctl.
> Running 32bit gnome-terminal on a 64 bit kernel results in the following in
> dmesg:
> 
> - with gnome-terminal:
> ioctl32(gnome-terminal:1755): Unknown cmd fd(19) cmd(0000530b){t:'S';sz:0}
> arg(48111345) on /dev/pts/0
> ioctl32(gnome-terminal:1755): Unknown cmd fd(19) cmd(0000530b){t:'S';sz:0}
> arg(4811134a) on /dev/pts/0
> ioctl32(gnome-terminal:1755): Unknown cmd fd(19) cmd(0000530b){t:'S';sz:0}
> arg(48111351) on /dev/pts/0

That looks more like an application problem. 'S' is SNDRV_SEQ_IOCTL
which has no ioctl nr 0xb. Also I have no idea why a sound sequencer
ioctl should work on /dev/pts/0 :)

> - with X:
> ioctl32(X:2803): Unknown cmd fd(0) cmd(40086408){t:'d';sz:8} arg(ff840a68) on
> /var/log/Xorg.0.log
> ioctl32(X:2803): Unknown cmd fd(0) cmd(40086408){t:'d';sz:8} arg(ff840a68) on
> /var/log/Xorg.0.log

'd' is used by pcmcia and DRM. DRM sounds more likely for X, but I
have a hard time to understand why a DRM ioctl should work on
/var/log/Xorg.0.log :)

For both gnome-terminal and X strace should tell you more.

> - when trying to suspend:
> ioctl32(s2disk:8164): Unknown cmd fd(4) cmd(400c330d){t:'3';sz:12}
> arg(ffc190ec) on /dev/snapshot
> ioctl32(s2disk:8164): Unknown cmd fd(4) cmd(4004330a){t:'3';sz:4} arg(00000806)
> on /dev/snapshot

snapshot_ioctl seems to lack compat support completely. Raphael ??
 
> Of course we'd better run 64bit userspace on 64bit kernel but 32bit
> applications are supposed to still work.
> Some may say some of them are too hardware specific but still it would be best
> to fix them...
> 
> Tested with 2.6.31.5 and 2.6.32-rc5.

Thanks,

	tglx
