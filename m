Return-Path: <linux-kernel-owner+w=401wt.eu-S1759625AbZCZR3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625AbZCZR3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754423AbZCZR3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:29:38 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:57717 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753427AbZCZR3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:29:37 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Date: Thu, 26 Mar 2009 18:29:30 +0100
User-Agent: KMail/1.9.9
Cc: tytso@mit.edu, mingo@elte.hu, jack@suse.cz, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, a.p.zijlstra@chello.nl,
       npiggin@suse.de, jens.axboe@oracle.com, drees76@gmail.com,
       jesper@krogh.cc, linux-kernel@vger.kernel.org, oleg@redhat.com,
       roland@redhat.com
References: <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326144707.GA6239@mit.edu> <20090326144707.GA6239@mit.edu> <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain>
In-reply-To: <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903261829.34359.elendil@planet.nl>
X-OriginalArrivalTime: 26 Mar 2009 17:29:35.0013 (UTC) FILETIME=[6E62A550:01C9AE38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> And quite frankly, even if you then _manually_ put 'relatime' in
> /etc/fstab, the default Fedora install will totally ignore it. Why?
> Because it mounts the root partition while using initrd, and totally
> ignores /etc/fstab.

That's a difference between Fedora's initrd and Debian/Ubuntu's 
initramfs-tools then. We do respect the mount options in fstab for the 
root partition when root is mounted from the initrd:

$ cat /etc/fstab | grep " / "
/dev/mapper/main-root /      ext3    relatime,errors=remount-ro 0       1

$ mount | grep " / "
/dev/mapper/main-root on / type ext3 (rw,relatime,errors=remount-ro)

$ cat /proc/cmdline
root=/dev/mapper/main-root ro vga=791 quiet

Cheers,
FJP
