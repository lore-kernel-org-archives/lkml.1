Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbYGTRZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbYGTRZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 13:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757574AbYGTRZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 13:25:17 -0400
Received: from saeurebad.de ([85.214.36.134]:59169 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757572AbYGTRZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 13:25:16 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto stuff broken in -mm?
CC: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 20 Jul 2008 19:24:48 +0200
Message-ID: <87ljzwh3j3.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I can not access my encrypted partitions with -mm while they work with
mainline.

For both trees I have similar configs, I didn't change anything relative
to this subsystem:

CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y

On mainline I do cryptsetup and then mount /dev/mapper/foo /mnt/foo
successfully, while I have the following behaviour on -mm:

# cryptsetup create foo /dev/sdd1
Enter passphrase:
# mount /dev/mapper/foo /mnt/foo
mount: you must specify the filesystem type
# mount -t ext3 /dev/mapper/foo /mnt/foo
mount: wrong fs type, bad option, bad superblock on /dev/mapper/foo,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so
# dmesg | tail -n1
[56975.640750] VFS: Can't find ext3 filesystem on dev dm-0.
# cryptsetup --version
cryptsetup 1.0.5

(This is the only relevant info in dmesg, unfortunately).

The cipher is aes-cbc-plain, according to cryptsetup status.

It's a 32bit x86 machine.  I suspect that -next has the same problem as
-mm's crypto changes seem to come from linux-next.patch.

I am willing to try patches (and hope they won't destroy 640GB worth of
porn).

	Hannes
