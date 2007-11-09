Return-Path: <linux-kernel-owner+w=401wt.eu-S1759321AbXKIKDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321AbXKIKDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 05:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbXKIKDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 05:03:35 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60007 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751501AbXKIKDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 05:03:33 -0500
Date: Fri, 9 Nov 2007 02:03:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: SANGOI DINO LEONARDO <dino.leonardo.sangoi@allianz.it>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.24-rc1 and 2.6.24.rc2 hangs while running udev on my laptop
Message-Id: <20071109020321.b26b293f.akpm@linux-foundation.org>
In-Reply-To: <2C8305E0BE090E47A2BAD52A48AC911D17BCE242@exchange1.lloyd.com>
References: <2C8305E0BE090E47A2BAD52A48AC911D17BCE242@exchange1.lloyd.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(cc's added)

On Fri, 9 Nov 2007 09:47:02 +0100  SANGOI DINO LEONARDO <dino.leonardo.sangoi@allianz.it> wrote:

> Hi,
>  
> My laptop (an HP nx6125) doesn't boot with kernels 2.6.24-rc1 and
> 2.6.24.rc2. 
> It works fine with 2.6.23 and older.
> 
> I seen this bug first while running fedora rawhide, so you can find hardware
> 
> info and boot logs at https://bugzilla.redhat.com/show_bug.cgi?id=312201.
> 
> I did a git bisect, and got this:
> 
> $ git bisect bad
> 4f86d3a8e297205780cca027e974fd5f81064780 is first bad commit
> commit 4f86d3a8e297205780cca027e974fd5f81064780
> Author: Len Brown <len.brown@intel.com>
> Date:   Wed Oct 3 18:58:00 2007 -0400
> 
>     cpuidle: consolidate 2.6.22 cpuidle branch into one patch
> [SNIP full commit log]
> 
> :040000 040000 fadedf003c64838a73d172d6b7c0046d88dedd5e
> ebb8a32b3bc49d731c13f2812148ae553bc1a533 M	arch
> :040000 040000 039a15fe07324bb0481eb1006571f6523c56c254
> e3251f5abcc19417472488f523da968e37698ddd M	drivers
> :040000 040000 89a350e5adc6dfd82adbb9c2f327557cd7a95334
> 14c738510d6c772e9a8db4bc494ce8fb3434a5fb M	include
> :040000 040000 e1d33c4a2558da0fb68f7e98145abf69e885ba94
> 7987a9110d0749aa7442a3f4c8c6c7d7a3df9426 M	kernel
> 
> $ git bisect log
> git-bisect start
> # bad: [b4f555081fdd27d13e6ff39d455d5aefae9d2c0c] Merge branch 'for-linus'
> of git://git.kernel.dk/linux-2.6-block
> git-bisect bad b4f555081fdd27d13e6ff39d455d5aefae9d2c0c
> # good: [bbf25010f1a6b761914430f5fca081ec8c7accd1] Linux 2.6.23
> git-bisect good bbf25010f1a6b761914430f5fca081ec8c7accd1
> # good: [1f06862e11f23ebc99438c592be9c92560d78548] rt2x00: Add new rt73usb
> USB ID
> git-bisect good 1f06862e11f23ebc99438c592be9c92560d78548
> # good: [2c6221483169ddd4c04797cd7296ed4fe52fcdd7] Fix discrepancy between
> VDSO based gettimeofday() and sys_gettimeofday().
> git-bisect good 2c6221483169ddd4c04797cd7296ed4fe52fcdd7
> # bad: [56d61a0e26c5a61c66d1ac259a59960295939da9] Merge branch 'for-linus'
> of git://git390.osdl.marist.edu/pub/scm/linux-2.6
> git-bisect bad 56d61a0e26c5a61c66d1ac259a59960295939da9
> # good: [ec2626815bf9a9922e49820b03e670e833f3ca3c] Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched
> git-bisect good ec2626815bf9a9922e49820b03e670e833f3ca3c
> # bad: [c00046c279a2521075250fad682ca0acc10d4fd7] Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/bunk/trivial
> git-bisect bad c00046c279a2521075250fad682ca0acc10d4fd7
> # bad: [e9a404580ccaeb31dd2a976f9929c4f9eb6f3540] nfs: Fix build break with
> CONFIG_NFS_V4=n
> git-bisect bad e9a404580ccaeb31dd2a976f9929c4f9eb6f3540
> # bad: [4800be295c34268fd3211d49828bfaa6bf62867f] Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild
> git-bisect bad 4800be295c34268fd3211d49828bfaa6bf62867f
> # good: [a2883dfa2e4a94b24109b2bfe735561e50cc44b4] Pull thermal into release
> branch
> git-bisect good a2883dfa2e4a94b24109b2bfe735561e50cc44b4
> # good: [731aa5fd9971a5163845fbe55de63d686a11da0a] Pull bugzilla-8709 into
> release branch
> git-bisect good 731aa5fd9971a5163845fbe55de63d686a11da0a
> # good: [910b40468a9ce3f2f5d48c5d260329c27d45adb5] kbuild: introduce
> cc-cross-prefix
> git-bisect good 910b40468a9ce3f2f5d48c5d260329c27d45adb5
> # bad: [00a2b433557f10736e8a02de619b3e9052556c12] Pull acpica into test
> branch
> git-bisect bad 00a2b433557f10736e8a02de619b3e9052556c12
> # bad: [de85871a9a53c00cae4c3a70849b5eaad0eb38b2] Pull cpuidle into test
> branch
> git-bisect bad de85871a9a53c00cae4c3a70849b5eaad0eb38b2
> # bad: [e196441bdf2dbf0526b28a6829c39557c236d611] ACPI: cpuidle: port idle
> timer suspend/resume workaround to cpuidle
> git-bisect bad e196441bdf2dbf0526b28a6829c39557c236d611
> # bad: [4f86d3a8e297205780cca027e974fd5f81064780] cpuidle: consolidate
> 2.6.22 cpuidle branch into one patch
> git-bisect bad 4f86d3a8e297205780cca027e974fd5f81064780
> --------
> 
> Config is taken from Fedora kernel. CONFIG_CPU_IDLE is set to y (tell me if
> full config is needed).
> 
> If I use 'nolapic' parameter, kernel 2.6.24-rc1 boots fine. 
> Setting CONFIG_CPU_IDLE=n also gives me a working kernel.
> 
> Ask me if more info is needed (please CC me).
> 
> Thanks,
> 
> Dino

