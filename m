Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbYDFTtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbYDFTtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 15:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYDFTtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 15:49:09 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:54326
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbYDFTtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 15:49:08 -0400
Message-ID: <47F9286E.8070901@qumranet.com>
Date: Sun, 06 Apr 2008 22:45:50 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: kvm-devel <kvm-devel@lists.sourceforge.net>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] kvm-65 release
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (firebolt.argo.co.il [0.0.0.0]); Sun, 06 Apr 2008 22:45:50 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The big item (in more ways than one) for this release is the addition of 
s390 support.  As it is not actually provided in the tarball, you will 
need to use git to fetch it.  You will also need a mainframe.

On x86, the most interesting change is the separation of timer and I/O 
completion handling into a separate thread (these used to be serviced by 
the same thread that executed vcpu 0).  The change should result in 
improved responsiveness and better smp performance.

Changes from kvm-64:
- fix hotplug build for non-x86 (Xiantao Zhang)
- ignore reads from the apic EOI register (Glauber Costa)
   - fixes Linux 2.6.25-rclate bootup problems
- compile fixes (Carlo Marcelo Arenas Belon)
- fix ftruncate() on hugetlbfs use on older Linux hosts (Marcelo Tosatti)
- endianness fix virtio-block (Anthony Liguori)
   - fixes virtio-blk on ppc
- refactor in-kernel PIT to be a separate device (Anthony Liguori)
- separate thread for I/O completions and timers (Marcelo Tosatti)
- fix vmmouse smp (Anthony Liguori)
- fix loading uninitialized variable into apic registers (Marcelo Tosatti)
   - fixes apic being disabled on smp Linux guests running X
- disable kvm clock on Voyager or SGI Visual WS (Randy Dunlap)
- s390 support (Carsten Otte, Martin Schwidefsky, Christian Borntraeger,
                 Heiko Carstens)
- fix large pages (Marcelo Tosatti)
- speedup msr processing on Intel via msr bitmap (Sheng Yang)
- add slab shrinker support (Izik Eidus)
   - reduces nonswappable footprint under memory pressure
- code cleanup (Joerg Roedel)
- vm refcounting (Izik Eidus)
- only mark a page as accessed if it was really accessed by the guest
- drop slots_lock while in guest mode
   - fixes long latencies with iothread
- prepopulate guest pages only after write-protecting them (Marcelo Tosatti)
   - fixes smp race leading to guest spinning

Notes:
      If you use the modules bundled with kvm-65, you can use any version
of Linux from 2.6.17 upwards.
      If you use the modules bundled with Linux 2.6.20, you need to use
kvm-12.
      If you use the modules bundled with Linux 2.6.21, you need to use
kvm-17.
      Modules from Linux 2.6.22 and up will work with any kvm version from
kvm-22.  Some features may only be available in newer releases.
      For best performance, use Linux 2.6.23-rc2 or later as the host.

http://kvm.qumranet.com

