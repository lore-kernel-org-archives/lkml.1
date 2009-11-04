Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbZKDPOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbZKDPOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbZKDPOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:14:52 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48816 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911AbZKDPOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:14:52 -0500
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Thierry Vignaud <tvignaud@mandriva.com>,
       bugzilla-daemon@bugzilla.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug 14537] New: missing compat_ioctl on x86_64
From: Andi Kleen <andi@firstfloor.org>
References: <bug-14537-6666@http.bugzilla.kernel.org/>
	<alpine.LFD.2.00.0911041142370.12138@localhost.localdomain>
Date: Wed, 04 Nov 2009 16:14:55 +0100
In-Reply-To: <alpine.LFD.2.00.0911041142370.12138@localhost.localdomain> (Thomas Gleixner's message of "Wed, 4 Nov 2009 12:43:57 +0100 (CET)")
Message-ID: <87vdhq8gpc.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

>> - with gnome-terminal:
>> ioctl32(gnome-terminal:1755): Unknown cmd fd(19) cmd(0000530b){t:'S';sz:0}
>> arg(48111345) on /dev/pts/0
>> ioctl32(gnome-terminal:1755): Unknown cmd fd(19) cmd(0000530b){t:'S';sz:0}
>> arg(4811134a) on /dev/pts/0
>> ioctl32(gnome-terminal:1755): Unknown cmd fd(19) cmd(0000530b){t:'S';sz:0}
>> arg(48111351) on /dev/pts/0
>
> That looks more like an application problem. 'S' is SNDRV_SEQ_IOCTL
> which has no ioctl nr 0xb. Also I have no idea why a sound sequencer
> ioctl should work on /dev/pts/0 :)

ioctl numbers are not always unique (I haven't checked if this is the
case here).  But it might be that it's some other ioctl actually.

One easy way to check is to install debuginfo and set break points
on ioctl in gdb and then look at the sources in the backtrace.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
