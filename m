Return-Path: <linux-kernel-owner+w=401wt.eu-S1760024AbYHFTNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024AbYHFTNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 15:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbYHFTNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 15:13:05 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:54733 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572AbYHFTNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 15:13:04 -0400
To: linux-kernel@vger.kernel.org
Subject: writable packet CD mounting in 2.6.26.x?
From: Nix <nix@esperi.org.uk>
Emacs: the road to Hell is paved with extensibility.
Date: Wed, 06 Aug 2008 20:12:49 +0100
Message-ID: <87ej52vtxq.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC--Metrics: hades 1114; Body=1 Fuz1=1 Fuz2=1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems to be impossible to mount packet-written CD-RWs writably in
2.6.26.x, even as root. Things worked in 2.6.25.x.

hades:/tmp# ls -l /dev/pktcdvd
total 0
brw-rw-rw- 1 root root  254,  0 2008-08-05 00:45 cdrw
crw-r--r-- 1 root root   10, 63 2008-08-05 00:44 control
brw-rw-rw- 1 root cdrom 254,  0 2008-08-05 00:45 pktcdvd0


hades:/tmp# mount -o rw /dev/pktcdvd/cdrw /mnt/pcdrw
mount: block device /dev/pktcdvd/cdrw is write-protected, mounting read-only

hades:/tmp# mount -o rw /dev/pktcdvd/pktcdvd0 /mnt/pcdrw
mount: block device /dev/pktcdvd/pktcdvd0 is write-protected, mounting read-only

The strace says that we get -EROFS always, now:

mount("/dev/pktcdvd/cdrw", "/mnt/pcdrw", "udf"..., MS_NOSUID|MS_NODEV|MS_NOEXEC|0x200000, NULL) = -1 EROFS (Read-only file system)


Anyone got any ideas? There are no suspicious-looking changes in
pktcdvd.c itself, so maybe this lies deeper in the block layer. Or
perhaps I'm mounting it wrong in some obscure way.
