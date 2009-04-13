Return-Path: <linux-kernel-owner+w=401wt.eu-S1752100AbZDMM1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbZDMM1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 08:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbZDMM1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 08:27:35 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:57012 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbZDMM1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 08:27:34 -0400
To: arjan@linux.intel.com, gregkh@suse.de
Cc: jmorris@namei.org, alan@redhat.com, hooanon05@yahoo.co.jp,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: current->mm == NULL in security_vm_enough_memory().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200903260130.n2Q1U9EJ040448@www262.sakura.ne.jp>
	<alpine.LRH.2.00.0903261236580.30336@tundra.namei.org>
	<200904092105.HBG52601.MHFOtQOLSVFOFJ@I-love.SAKURA.ne.jp>
In-Reply-To: <200904092105.HBG52601.MHFOtQOLSVFOFJ@I-love.SAKURA.ne.jp>
Message-Id: <200904132127.FBG30222.OOFFtQLJFOHSMV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 13 Apr 2009 21:27:29 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I'm experiencing

  WARNING: at security/security.c:217 security_vm_enough_memory+0xa0/0xb0()

messages.
"git bisect" reported that commit f520360d93cdc37de5d972dac4bf3bdef6a7f6a7
is the cause of this warning. May I ignore this warning?

Regards.

Tetsuo Handa wrote:
> James Morris wrote:
> > khelper is a kernel thread, so it should not have an ->mm, but I wonder
> > why this hasn't shown up before.  Odd...
> 
> I don't see this message for 2.6.29 and earlier.
> As of 2.6.30-rc1, this problem is not solved yet.
> I think something happened between 2.6.29 and 2.6.30-rc1.
> 
> http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.30-rc1.txt
> http://I-love.SAKURA.ne.jp/tmp/config-2.6.30-rc1

# git bisect start v2.6.30-rc1 v2.6.29 -- arch/x86/ fs/ kernel/ include/asm-generic/
Bisecting: 1304 revisions left to test after this
[749b0afc3a9d90dda3319fd1464a3b32fc225361] kexec: Change kexec jump code ordering
# git bisect bad
Bisecting: 639 revisions left to test after this
[6d2e91bf80e4410207f01edb0962aec9213f3533] Merge branch 'x86/urgent' into x86/mm
# git bisect good
Bisecting: 326 revisions left to test after this
[6e15cf04860074ad032e88c306bea656bbdd0f22] Merge branch 'core/percpu' into percpu-cpumask-x86-for-linus-2
# git bisect bad
Bisecting: 163 revisions left to test after this
[13220a94d35708d5378114e96ffcc88d0a74fe99] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6
# git bisect bad
Bisecting: 81 revisions left to test after this
[08abe18af1f78ee80c3c3a5ac47c3e0ae0beadf6] Merge branch 'master' of /home/davem/src/GIT/linux-2.6/
# git bisect bad
Bisecting: 44 revisions left to test after this
[562f477a54478002ddfbb5b85627c009ca41e71d] Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
# git bisect good
Bisecting: 23 revisions left to test after this
[8ff64b539bfd998792614481ccb67139b97075ef] Merge git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw
# git bisect good
Bisecting: 11 revisions left to test after this
[aa4abc9bcce0d2a7ec189e897f8f8c58ca04643b] Merge branch 'master' of master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6
# git bisect good
Bisecting: 5 revisions left to test after this
[f67f129e519fa87f8ebd236b6336fe43f31ee141] Driver core: implement uevent suppress in kobject
# git bisect good
Bisecting: 2 revisions left to test after this
[e9d376f0fa66bd630fe27403669c6ae6c22a868f] dynamic debug: combine dprintk and dynamic printk
# git bisect bad
Bisecting: 1 revisions left to test after this
[669420644c79c207f83fdf9105ae782867e2991f] sysfs: only allow one scheduled removal callback per kobj
# gid bisect good
(...snipped...)
# git bisect reset
(...snipped...)
# git bisect start e9d376f0fa66bd630fe27403669c6ae6c22a868f v2.6.29 6d2e91bf80e4410207f01edb0962aec9213f3533 562f477a54478002ddfbb5b85627c009ca41e71d 8ff64b539bfd998792614481ccb67139b97075ef aa4abc9bcce0d2a7ec189e897f8f8c58ca04643b f67f129e519fa87f8ebd236b6336fe43f31ee141 669420644c79c207f83fdf9105ae782867e2991f
Bisecting: 1 revisions left to test after this
[095160aee954688a9bad225952c4bee546541e19] sysfs: fix some bin_vm_ops errors
# git bisect bad
Bisecting: 0 revisions left to test after this
[f520360d93cdc37de5d972dac4bf3bdef6a7f6a7] kobject: don't block for each kobject_uevent
# git bisect bad
f520360d93cdc37de5d972dac4bf3bdef6a7f6a7 is first bad commit
commit f520360d93cdc37de5d972dac4bf3bdef6a7f6a7
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Thu Mar 19 09:09:05 2009 -0700

    kobject: don't block for each kobject_uevent

    Right now, the kobject_uevent code blocks for each uevent that's being
    generated, due to using (for hystoric reasons) UHM_WAIT_EXEC as flag to
    call_usermode_helper().  Specifically, the effect is that each uevent
    that is being sent causes the code to wake up keventd, then block until
    keventd has processed the work. Needless to say, this happens many times
    during the system boot.

    This patches changes that to UHN_NO_WAIT (brilliant name for a constant
    btw) so that we only schedule the work to fire the uevent message, but
    do not wait for keventd to process the work.

    This removes one of the bottlenecks during boot; each one of them is
    only a small effect, but the sum of them does add up.

    [Note, distros that need this are broken, they should be setting
    CONFIG_UEVENT_HELPER_PATH to "", that way this code path will never be
    excuted at all -- gregkh]

    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

:040000 040000 b1bfc977d11bb63ee29e42ad552eb89df4508815 4b301b5d0277359da91ee5e0162d44f76bbc7585 M      lib
