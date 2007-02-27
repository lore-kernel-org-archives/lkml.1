Return-Path: <linux-kernel-owner+w=401wt.eu-S932893AbXB0LrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893AbXB0LrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 06:47:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933044AbXB0LrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 06:47:07 -0500
Received: from sslsrv.de ([62.75.159.123]:34056 "EHLO sslsrv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932893AbXB0LrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 06:47:05 -0500
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Feb 2007 06:47:05 EST
Message-ID: <37295.193.171.152.61.1172576225.squirrel@webmail.marek.priv.at>
Date: Tue, 27 Feb 2007 12:37:05 +0100 (CET)
Subject: Using dm-crypt for encrypting files
From: "Ph. Marek" <philipp@marek.priv.at>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6-4.fc1.1.legacy
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody!

I'm aware of some implementations for file system encryption - dm-crypt,
loopback with encryption, truecrypt, and fuse.

Now I'd like to ask if it's easily possible to write a (preloaded)
user-space library or a kernel module, that
- overlays an existing directory tree,
- decrypts all encrypted files therein,
- encrypts new files depending on their filename, and generally
- allows transparent access, as to normal files.

Why? I'd need to achieve a file-encryption, that works on files whose
filenames match certain criteria.


How to do that? I'm thinking along the lines
- create an anonymous dm-crypt-device,
- attach that (with an offset) to the "base" file,
- on close detach and cleanup the dm-crypt-device.


I don't like the block-device-encryption *in this case*, because
- the amount of encrypted data varies a lot (some use none, others many
  GB), which makes the sizing a bit difficult,
- and I'd like to do incremental backups - which is easier if you just
  look at the files' meta-data.

The advantage I see over fuse is that the context switches are eliminated
- and the infrastructure for encryption is present in the kernel.
(The only difference between a file and a block device is, AFAIK, the
sparseness - which might make a problem for dm-crypt (?).)

(The kernel module would probably be better, because it works on static
binaries too, can hide the keys better [even against the user], and is
easier regarding access to the devices - how many should exist, and who
may use them?)


The main problems I see are:
- In order to know which key to use the full path may have to be created.
  How do we know how long that can be?
- The files should get decrypted *only* for the user-process-hierarchy.
  With other filesystems it's possible to use a clone() with CLONE_NEWNS
  on logon, and no other processes apart from that processtree can access
  clear-text data - not even the administrator (until he *really* wants
  to, then nothing can stop him, of course).
  I don't see how that could be done here, too.


I'm afraid that this is more a brainstorming than a complete wish list or
question table - but I'd like to hear others' opinions before thinking to
much ahead.


Thank you for all ideas, answers, other feedback.



Regards,

Phil



-- 
Versioning your /etc, /home or even your whole installation?
             Try fsvs (fsvs.tigris.org)!

