Return-Path: <linux-kernel-owner+w=401wt.eu-S1760041AbYCZUvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760041AbYCZUvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 16:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756803AbYCZUvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 16:51:39 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:46406 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966AbYCZUvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 16:51:38 -0400
Date: Wed, 26 Mar 2008 21:51:34 +0100
Message-Id: <213384793@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       david-b@pacbell.net, greg@kroah.com, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: some minor issues with 2.6.25-rc6-git7-default
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18xm7f4TPnmOXLoo0idEQSC3/N/ULlta7hioP14ahrZC018V
 HvTqThZcijbqYwx/hakx1HFLul8Ep3tSLIH9QWet7rJWu6RgWc=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you post the full kernel log up to this BUG?
> It should show that causes the Taint.

oh - yes:

Mar 23 09:12:20 opensuse103 kernel: ac97_codec: module license 'unspecified' taints kernel.

modinfo ac97_codec
filename:       /lib/modules/2.6.25-rc6-git7-default/kernel/sound/oss/ac97_codec.ko
srcversion:     8665939D5E471F7E331BB3E
depends:
vermagic:       2.6.25-rc6-git7-default SMP mod_unload 586


seems MODULE_LICENSE is missing in ./sound/oss/ac97_codec.c !?


> > > > CCing Dave Brownell.
> > > > 
> > > > > Mar 23 09:14:23 opensuse103 kernel: Generic RTC Driver v1.07
> > > > > Mar 23 09:14:23 opensuse103 kernel: proc_dir_entry 'rtc' already registered
> > > > > Mar 23 09:14:23 opensuse103 kernel: Pid: 3994, comm: modprobe Tainted: P         2.6.25-rc6-git7-default #1
> > > > > Mar 23 09:14:23 opensuse103 kernel:  [<c019a602>] proc_register+0xf3/0x11f
> > > > > Mar 23 09:14:23 opensuse103 kernel:  [<c019a719>] create_proc_entry+0x69/0x7b
> > > > > Mar 23 09:14:23 opensuse103 kernel:  [<e0c5f02d>] rtc_generic_init+0x2d/0x54 [genrtc]
> > > > > Mar 23 09:14:23 opensuse103 kernel:  [<c013c1de>] sys_init_module+0x16b6/0x17c9
> > > > > Mar 23 09:14:23 opensuse103 kernel:  [<c0108a6a>] sys_mmap2+0x62/0x77
> > > > > Mar 23 09:14:23 opensuse103 kernel:  [<c01059c4>] sysenter_past_esp+0x6d/0xa9
> > > > > Mar 23 09:14:23 opensuse103 kernel:  =======================
> > > 
> > > uh, "known problem": multiple rtc drivers are being run.
> > > 
> > > I don't really understand why we haven't been able to fix this - there have
> > > been numerous reports..
> > 
> > i will take a closer look to determine how/when this happens.
> 
> I thought that David B. sent a (Kconfig ?) patch for this...
> 
> ---
> ~Randy

do you mean this one ?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=55ff1aba940ff46d4f6d4fd790ea3e1a47aaa84f

ok, it may be sort of "dumb" to blindly load one module after the other but i would expect a more meaningful message.

regards
roland
_________________________________________________________________________
In 5 Schritten zur eigenen Homepage. Jetzt Domain sichern und gestalten! 
Nur 3,99 EUR/Monat! http://www.maildomain.web.de/?mc=021114

