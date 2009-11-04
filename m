Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbZKDQvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbZKDQvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbZKDQvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:51:19 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:59070 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbZKDQvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:51:19 -0500
Date: Wed, 4 Nov 2009 08:49:07 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andreas Schwab <schwab@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Thierry Vignaud <tvignaud@mandriva.com>,
       bugzilla-daemon@bugzilla.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug 14537] New: missing compat_ioctl on x86_64
Message-Id: <20091104084907.325cd5e5.randy.dunlap@oracle.com>
In-Reply-To: <m3d43ys3f5.fsf@hase.home>
References: <bug-14537-6666@http.bugzilla.kernel.org/>
	<alpine.LFD.2.00.0911041142370.12138@localhost.localdomain>
	<87vdhq8gpc.fsf@basil.nowhere.org>
	<m3d43ys3f5.fsf@hase.home>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4AF1B0D9.0005:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Nov 2009 16:41:34 +0100 Andreas Schwab wrote:

> Andi Kleen <andi@firstfloor.org> writes:
> 
> > Thomas Gleixner <tglx@linutronix.de> writes:
> >
> >>> - with gnome-terminal:
> >>> ioctl32(gnome-terminal:1755): Unknown cmd fd(19) cmd(0000530b){t:'S';sz:0}
> >>> arg(48111345) on /dev/pts/0
> >>> ioctl32(gnome-terminal:1755): Unknown cmd fd(19) cmd(0000530b){t:'S';sz:0}
> >>> arg(4811134a) on /dev/pts/0
> >>> ioctl32(gnome-terminal:1755): Unknown cmd fd(19) cmd(0000530b){t:'S';sz:0}
> >>> arg(48111351) on /dev/pts/0
> >>
> >> That looks more like an application problem. 'S' is SNDRV_SEQ_IOCTL
> >> which has no ioctl nr 0xb. Also I have no idea why a sound sequencer
> >> ioctl should work on /dev/pts/0 :)
> >
> > ioctl numbers are not always unique (I haven't checked if this is the
> > case here).  But it might be that it's some other ioctl actually.
> 
> 'S' is also used for streams ioctls, 0x530b is I_FIND.

Is that last 'S' in the kernel source tree?
If so, I'll have to find/add it to Documentation/ioctl/ioctl-number.txt,
which I sent an update patch for about 2 weeks ago.  For 'S', it now lists:

 'S'	all	linux/cdrom.h		conflict!
 'S'	80-81	scsi/scsi_ioctl.h	conflict!
 'S'	82-FF	scsi/scsi.h		conflict!
+'S'	00-7F	sound/asequencer.h	conflict!


---
~Randy
