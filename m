Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbYLMI1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbYLMI1V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 03:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbYLMI1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 03:27:11 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:39398 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752767AbYLMI1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 03:27:09 -0500
X-YMail-OSG: d91NzaUVM1kAVdNnEzBHladY.pgLXPh.Y5i8RMhtl8OnmUgQfqRlGXrtP__tG.J4cWyE_gwvR7XO0ThQdh3XbPy4VJIoJV20I.AdDYe9jEF0vRqPAjg6P9fzWGM38ayRV360ur3pylQvPMbeAj5SFYJBYAdQgRjT9SlhMKVFRQF39xB2mte_3Krt3ggs0Hn3Sz9gQ9xXQxyBTtpAvPKstp.c
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [Announce]: Target_Core_Mod/ConfigFS and LIO-Target v3.0 work
From: "Nicholas A. Bellinger" <nab@kernel.org>
Reply-To: nab@kernel.org
To: Valdis.Kletnieks@vt.edu
Cc: linux-iscsi-target-dev@googlegroups.com,
       LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <54939.1229149205@turing-police.cc.vt.edu>
References: <1228965271.4153.510.camel@haakon2.linux-iscsi.org>
	 <e2e108260812111124j79793adcie106ac2da4f801f3@mail.gmail.com>
	 <1229025513.4153.542.camel@haakon2.linux-iscsi.org>
	 <e2e108260812112321w2f5b1827xe2593888e44808ae@mail.gmail.com>
	 <1229074809.4153.666.camel@haakon2.linux-iscsi.org>
	 <54939.1229149205@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Sat, 13 Dec 2008 00:27:05 -0800
Message-Id: <1229156825.4153.754.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-12-13 at 01:20 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 12 Dec 2008 01:40:09 PST, "Nicholas A. Bellinger" said:
> 
> > Too bad, because you are missing out on the most advanced ConfigFS
> > enabled storage engine on the planet.
> 
> OK. I *have* to ask.. ;)
> 
> What's the *second* most advanced configfs-enabled storage engine?
> 
> The only in-tree users of configfs I could find (grepping for the string
> 'config_item_init') were drivers/net/netconsole, fs/ocfs2, and fs/dlm, so
> "most advanced configfs" is well into "world's tallest midget" territory...
> 

It is advanced in the sense that it is the only user of ConfigFS that
spans across multiple kernel modules.  In the context of the generic
target engine, this means that ConfigFS symlinks are used to create
Target Ports from the $FABRIC_MOD (like LIO-Target) to registered
$STORAGE_OBJECTS (storage devices available from Linux/SCSI, Linux/BLOCK
and Linux/VFS) within the generic target engine.  The idea is that any
$FABRIC_MOD can create ConfigFS symlinks to the same $STORAGE_OBJECT,
and said $STORAGE_OBJECT can be shared across multiple $FABRIC_MODs.

Also, I cannot emphesize enough how much I think ConfigFS is the proper
direction for controlling a generic kernel level target engine, and
$FABRIC_MODs.  It has made my work in lio-core-2.6.git simpler, and the
code easier to maintain and improve.  I have implemented my own IOCTL,
Proc and SYSFS code for drivers over the years, and ConfigFS is the best
method that I have found to date for controlling a complex kernel
infrastructure across multiple plugin modules where config is driven by
userspace.

So I really invite folks to take a look at the ConfigFS for the generic
engine to see for themselves:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/lio-core/target_core_configfs.c

and the LIO-Target iSCSI $FABRIC_MOD:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/lio-core/iscsi_target_configfs.c

Unfortuately the detractors of ConfigFS on this list (who obviously have
their own motivations) can only offer hypothetical scenarios for
problems they forsee without writing a single line of ConfigFS code.  I
however have no problems with the above running ConfigFS code, but these
folks have no interest in debating real running ConfigFS code, only
handwaving about their perceived limitiations of ConfigFS without
attempting to take the techincal points to linuxfs-devel, or contact the
ConfigFS author, etc.

Anyways, I appericate the comments, and invite you to have a look at the
running code for yourself.

Many thanks for your most valuable of time,

--nab



