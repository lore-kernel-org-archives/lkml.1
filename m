Return-Path: <linux-kernel-owner+w=401wt.eu-S1752313AbXBYEej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbXBYEej (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 23:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbXBYEej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 23:34:39 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:48232 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbXBYEei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 23:34:38 -0500
Date: Sat, 24 Feb 2007 23:34:31 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: 2.6.20-ck1
In-reply-to: <200702162110.03355.kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Cc: Con Kolivas <kernel@kolivas.org>, ck mailing list <ck@vds.kolivas.org>
Message-id: <200702242334.31864.gene.heskett@gmail.com>
Organization: very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200702162110.03355.kernel@kolivas.org>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 February 2007, Con Kolivas wrote:
>This patchset is designed to improve system responsiveness and
> interactivity. It is configurable to any workload but the default -ck
> patch is aimed at the desktop and -cks is available with more emphasis
> on serverspace.
>
>Apply to 2.6.20
>http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.20/2.6.
>20-ck1/patch-2.6.20-ck1.bz2
>
>or server version
>http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.20/2.6.
>20-ck1/patch-2.6.20-cks1.bz2
>
>web:
>http://kernel.kolivas.org
>
>all patches:
>http://www.kernel.org/pub/linux/kernel/people/ck/patches/
>
>
>Split patches available.
>
>Full patchlist:
>
>sched-staircase-17.patch
>sched-staircase17_interactive_tunable.patch
>sched-staircase17_compute_tunable.patch
>sched-range.patch
>sched-iso-4.7.patch
>track_mutexes-1.patch
>sched-idleprio-1.1.patch
>sched-limit_policy_changes.patch
>sched-make_softirqd_batch.patch
>cfq-ioprio_inherit_rt_class.patch
>cfq-iso_idleprio_ionice.patch
>hz-default_1000.patch
>hz-no_default_250.patch
>sched-add-above-background-load-function.patch
>mm-swap_prefetch-34.patch
>mm-convert_swappiness_to_mapped.patch
>mm-lots_watermark.diff
>mm-kswapd_inherit_prio-1.patch
>mm-prio_dependant_scan-2.patch
>mm-background_scan-2.patch
>mm-idleprio_prio.patch
>mm-filesize_dependant_lru_cache_add.patch
>kconfig-expose_vmsplit_option.patch
>ck1-version.patch
>
I have a problem, Con.  The patch itself works fine for me, BUT it doesn't 
update the version.h available in 
/lib/modules/2.6.20-ck1/source/include/linux to include the -ck1 in the 
reported kernel version when trying to build an fglrx driver with the 
latest ati driver builder.  

Which leaves this error message in /usr/share/fglrx/flgrx-install.log:
[root@coyote fglrx]# cat fglrx-install.log
[Message] Kernel Module : Trying to install a precompiled kernel module.
[Message] Kernel Module : Precompiled kernel module version mismatched.
[Message] Kernel Module : Found kernel module build environment, 
generating kernel module now.
ATI module generator V 2.0
==========================
initializing...
Error:
kernel includes at /lib/modules/2.6.20-ck1/build/include do not match 
current kernel.
they are versioned as ""
instead of "2.6.20-ck1".
you might need to adjust your symlinks:
- /usr/include
- /usr/src/linux
[Error] Kernel Module : Failed to compile kernel module - please consult 
readme.
==========================
Unforch, the installer does not leave a readme behind that I've been able 
to find, nor does it report the error on-screen.

The above files are not simlinks here on this FC6 install.  And of 
course /usr/src/linux does not exist allthough I could set it up for the 
duration of a rebuild/reinstall cycle of my script.

Can we have a patch to address this?  Or should I just hardcode it since 
it will never be linked to any other later kernel?

I tried that in the src tree's include/linux/version.h, but it was 
refreshed back to the original regex code by the make, so that's not 
where to do it obviously.  I've also made the simlink in /usr/src, but 
since a kernel make re-writes version.h, that didn't help.

Whats next?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
