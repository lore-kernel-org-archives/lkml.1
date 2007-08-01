Return-Path: <linux-kernel-owner+w=401wt.eu-S1764027AbXHARqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764027AbXHARqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758607AbXHARqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:46:01 -0400
Received: from web52904.mail.re2.yahoo.com ([206.190.49.14]:37462 "HELO
	web52904.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757400AbXHARqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:46:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=TKaa+KSU+MvMMKPl/8XKf1LUkapZC+hqpzgPeZ03FqGb/XtZO9fXw3bmW3G+idb0S1nk/P2PZVNSlBgQUfDkaDyJNGoyvJS83co/whXs5DIQIco4M3vwrN4KojHUMlqGM/AKjtBdlYT3av22Vxwja65R5bulYYjekf2/m4OgXvQ=;
X-YMail-OSG: .iLs9gAVM1lbz1bjUP0_wvtm.DIEZBjp20s1WqaL5opVuWhPtr17_f1U1t8.dvAIPuj3EBpDeTIoRcfR8vRJkk7GBoTTRh7OwId7UgGvzoc7liSDFIFmgAUPsTYngqSoGpK1gz6_23x8iNt_n8Ug_9GGqg--
Date: Wed, 1 Aug 2007 18:45:59 +0100 (BST)
From: Chris Rankin <rankincj@yahoo.com>
Subject: [BUG] Linux 2.6.22 - Atomic counter underflow in NFS
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <272608.90315.qm@web52904.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am running a 2.6.22 kernel on a dual P4 Xeon (HT enabled) with 2 GB RAM, and I have just found
this BUG in my dmesg log:

nfsd: last server has exited
nfsd: unexporting all filesystems
BUG: atomic counter underflow at:
 [<c01a382a>] kref_put+0x66/0x84
 [<c0188bc2>] sysfs_hash_and_remove+0xb8/0x12d
 [<c0188bca>] sysfs_hash_and_remove+0xc0/0x12d
 [<c01522e2>] sysfs_slab_alias+0x19/0x5c
 [<c0152438>] sysfs_slab_add+0x113/0x124
 [<c01527de>] kmem_cache_create+0x12d/0x1d3
 [<f8d9df1b>] nfs4_state_start+0x3b/0x1a7 [nfsd]
 [<f8d8a485>] nfsd_svc+0x51/0x10d [nfsd]
 [<f8d8ae76>] write_threads+0x65/0x96 [nfsd]
 [<c016c279>] simple_transaction_get+0x70/0x82
 [<f8d8ae11>] write_threads+0x0/0x96 [nfsd]
 [<f8d8ab9f>] nfsctl_transaction_write+0x36/0x5c [nfsd]
 [<f8d8ab69>] nfsctl_transaction_write+0x0/0x5c [nfsd]
 [<c0155392>] vfs_write+0x8a/0x10c
 [<c0155901>] sys_write+0x41/0x67
 [<c010266e>] sysenter_past_esp+0x5f/0x85
 =======================
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period

Cheers,
Chris



      ___________________________________________________________ 
Yahoo! Mail is the world's favourite email. Don't settle for less, sign up for
your free account today http://uk.rd.yahoo.com/evt=44106/*http://uk.docs.yahoo.com/mail/winter07.html 
