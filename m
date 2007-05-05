Return-Path: <linux-kernel-owner+w=401wt.eu-S1422696AbXEEBiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422696AbXEEBiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 21:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031332AbXEEBiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 21:38:23 -0400
Received: from ns1.q-leap.de ([153.94.51.193]:54444 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031094AbXEEBiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 21:38:22 -0400
Date: Sat, 5 May 2007 03:38:19 +0200
From: Bernd Schubert <bs@q-leap.de>
To: linux-kernel@vger.kernel.org
Cc: bernd-schubert@gmx.de
Subject: Re: mkfs.ext2 triggerd RAM corruption
Message-ID: <20070505013819.GB23803@lanczos.q-leap.de>
References: <200705041659.51675.bs@q-leap.de> <20070504203956.GL25077@lug-owl.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070504203956.GL25077@lug-owl.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Benedict Glaw wrote:

> On Fri, 2007-05-04 16:59:51 +0200, Bernd Schubert <bs@q-leap.de>
> wrote:
>> To see whats going on, I copied the entire / (so the initrd) into a
>> tmpfs
>> root, chrooted into it, also bind mounted the main / into this chroot
>> and
>> compared several times /bin of chroot/bin and the bind-mounted /bin
>> while
>> the mkfs.ext2 command was running.
>> 
>> beo-05:/# diff -r /bin /oldroot/bin/
>> beo-05:/# diff -r /bin /oldroot/bin/
>> beo-05:/# diff -r /bin /oldroot/bin/
>> Binary files /bin/sleep and /oldroot/bin/sleep differ
>> beo-05:/# diff -r /bin /oldroot/bin/
>> Binary files /bin/bsd-csh and /oldroot/bin/bsd-csh differ
>> Binary files /bin/cat and /oldroot/bin/cat differ
>> ...
>> 
>> Also tested different schedulers, at least happens with deadline and
>> anticipatory.
>> 
>> The corruption does NOT happen on running the mkfs command on
>> /dev/sda1,
>> but happens with sda2, sda3 and sda3. Also doesn't happen with
>> extended
>> partitions of sda1.
> 
> Is sda2 the largest filesystem out of sda2, sda3 (and the logical
> partitions within the extended sda1, if these get mkfs'ed, too)?

I tested it that way:

- test on sda1, no further partitions
- test on sda2, sda1: ~2MB, everything else for sda2
- test on sda3, sda1: ~2MB, sda2: ~2MB, everything else for sda3
...
test on sda5: sda1: partition that has the extended partition,
everything in
sda5

> 
> I'm not too sure that this is a kernel bug, but probably a bad RAM
> chip. Did you run memtest86 for a while? ...and can you reproduce this
> problem on different machines?

Reproducible on 4 test-systems (2 with identical hardware, but then the
2 + 1 + 1 with entirely different hardware combinations) with ECC memory,
which is monitored by EDAC. Memory, CPU, etc. are already real life stress
tested with several applications, e.g. linpack. 
Though I don't entirely agree, my colleagues in this group are always
telling me, that their real life stress test shows more memory
corruptions than memtest. As soon as I have physical access again, I can also 
do a memtest86 run (would like to do it over the weekend, but don't know how
to convince stupid rembo how to boot memtest).
Anyway, a memory corruption is more than unlikely on these systems for
several reasons.


Thanks,
Bernd
