Return-Path: <linux-kernel-owner+w=401wt.eu-S934769AbZGQRBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934769AbZGQRBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 13:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934745AbZGQRBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 13:01:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:34626 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934743AbZGQRBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 13:01:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=KiiBlS3fbHKXGE5iVsh02HGFEvPTLzE4djS31R/2nI4iqHLveCrqHgS48LnqlfNIHk
         ygqRsHimsi9aqXMDoh8zAidVP3YKd15Lo7Nv0vJ0f3zKX0GCPy2Bu2AcGeywKAdX4uwb
         e/GWTFfz1URE8qm8OxFbj58XigvXV/keDd86g=
Date: Fri, 17 Jul 2009 13:01:40 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-desktop
To: linux-kernel@vger.kernel.org
cc: avi@redhat.com
Subject: emulation failed (pagetable) rip
Message-ID: <alpine.DEB.2.00.0907171301280.7725@parag-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On today's git, while installing Ubuntu Jaunty I am getting a load of -

[ 1962.876257] __ratelimit: 1457842 callbacks suppressed
[ 1962.876261] emulation failed (pagetable) rip 7f62e684b5ab 66 0f 7f 07
[ 1962.876268] emulation failed (pagetable) rip 7f62e684b5ab 66 0f 7f 07
[ 1962.876274] emulation failed (pagetable) rip 7f62e684b5ab 66 0f 7f 07
[ 1962.876280] emulation failed (pagetable) rip 7f62e684b5ab 66 0f 7f 07
[ 1962.876286] emulation failed (pagetable) rip 7f62e684b5ab 66 0f 7f 07
[ 1962.876292] emulation failed (pagetable) rip 7f62e684b5ab 66 0f 7f 07
[ 1962.876297] emulation failed (pagetable) rip 7f62e684b5ab 66 0f 7f 07
[ 1962.876303] emulation failed (pagetable) rip 7f62e684b5ab 66 0f 7f 07
[ 1962.876309] emulation failed (pagetable) rip 7f62e684b5ab 66 0f 7f 07
[ 1962.876315] emulation failed (pagetable) rip 7f62e684b5ab 66 0f 7f 07

It happens right after Partition formatting sequence in Jaunty install.
The installation fails with unable to mount partition vda.

QEMU PC emulator version 0.9.1 (kvm-84)

kvm -drive file=ubuntu-jaunty.img,if=virtio,boot=on -net nic,model=virtio 
-net user -m 1024M -cdrom /media/New\ Volume/Downloads/ubuntu-9.04-desktop-amd64.iso 

If I remove the file=...,if=virtio and instead use plain old hda=... the 
install succeeds - probably safe to say virtio is at fault?

Haven't recently tested KVM so can't say when this started.

Any ideas?
