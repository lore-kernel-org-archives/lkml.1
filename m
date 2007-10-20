Return-Path: <linux-kernel-owner+w=401wt.eu-S1760725AbXJTPpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760725AbXJTPpL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 11:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755793AbXJTPo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 11:44:59 -0400
Received: from tachyon.jukie.net ([205.150.199.214]:52817 "EHLO jukie.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755709AbXJTPo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 11:44:58 -0400
Date: Sat, 20 Oct 2007 11:44:45 -0400
From: Bart Trojanowski <bart@jukie.net>
To: kvm-devel@lists.sourceforge.net
Cc: Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.23.1 host freezes when running kvm
Message-ID: <20071020154445.GA5254@jukie.net>
References: <20071019202019.GW3962@jukie.net> <20071020000240.GX3962@jukie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071020000240.GX3962@jukie.net>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Bart Trojanowski <bart@jukie.net> [071019 20:03]:
> * Bart Trojanowski <bart@jukie.net> [071019 17:00]:
> <snip>
> > 
> > Once the system is booted, I attached using vnc, then I ssh in and ran
> > 'svn update'... and the host machine froze.
> > 
> > The last messages I on my serial console are:
> > 
> > kvm: unhandled rdmsr: 0x417
> > kvm: unhandled rdmsr: 0xc0000400
> <snip>
> > I noticed that linus merged a bunch of KVM changes last week.  I will
> > try those out next.
> 
> It looks like Linus' tree has the fix already.

I spoke too soon.  The latest from Linus' tree also freezes... but it
took overnight to get there.  There was no particular load on it.

This system was previously running 2.6.22.y w/o problems with a similar
kvm pattern.

This time it froze w/o showing any kvm rdmsr messages.  And while it
froze sometime over night, I cannot be sure when.  Here is the SysRq's
"showPc" output:

SysRq : Show Regs
CPU 2:
Modules linked in: kvm_amd kvm rtc_cmos rtc_core rtc_lib
cpufreq_userspace cpufreq_powersave cpufreq_conservative ipv6 bridge
ext2 mbcache loop pcspkr button dm_mirror dm_snapshot dm_mod ide_generic
ide_cd pata_acpi ata_generic serverworks generic ide_core
Pid: 0, comm: swapper Not tainted 2.6.23-git-kvm-gc4ec2071 #1
RIP: 0010:[<ffffffff8020b0db>]  [<ffffffff8020b0db>] default_idle+0x29/0x3d
RSP: 0018:ffff810140a55f30  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffffffff8066a040 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff805c3350
RBP: ffffffff8066fa00 R08: ffff810140040560 R09: ffff8101006e7e70
R10: ffff810143e0a900 R11: ffffffff8066fa00 R12: ffffffff8024bc8e
R13: ffff810140a55ec8 R14: 000000000d6ed51a R15: ffffffff8066fa00
FS:  00002aaea92f0bf0(0000) GS:ffff810140a1d300(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00002add9e236140 CR3: 0000000143def000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff8020b182>] cpu_idle+0x93/0xbb

Are there things I should be looking for?

-Bart

-- 
				WebSig: http://www.jukie.net/~bart/sig/
