Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbYGIQqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbYGIQqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbYGIQqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:46:10 -0400
Received: from wildsau.enemy.org ([193.170.194.34]:34637 "EHLO
	wildsau.enemy.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbYGIQqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:46:09 -0400
X-Greylist: delayed 1336 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jul 2008 12:46:09 EDT
From: "K. Ernel" <kernel@wildsau.enemy.org>
Message-Id: <200807091622.m69GMjnH025474@wildsau.enemy.org>
Subject: CONFIG_NETWORK_FILESYSTEMS not set in /proc/config.gz
To: linux-kernel@vger.kernel.org
Date: Wed, 9 Jul 2008 18:22:45 +0200 (MET DST)
X-Mailer: ELM [version 2.4ME+ PL100 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hello list,

I usually switch to a new kernel version using the
old .config file by doing:

    # zcat /proc/config.gz > .config
    # make oldconfig

however, with the last two (or so) versions, I always lost the network
file system configuration. It's not present in config.gz,
while in the old .config of the previous release, it _is_
present, plus I'm abble to use network file system support
in the current (before the update) kernel.

e.g.:

(1) kernel version:
    # uname -r
    2.6.25.9

(2) this kernel version's configuration in the sources:
    # grep NETWORK_FILE linux-2.6.25.9/.config
    CONFIG_NETWORK_FILESYSTEMS=y

(3) this kernel version's configuration in /proc/config.gz
    # zcat /proc/config.gz | grep NETWORK_FILE
    # CONFIG_NETWORK_FILESYSTEMS is not set

(4) to proof this kernel version has indeed network filesystem:
    # lsmod| grep nfs
    nfs                    86896  1 
    lockd                  38280  2 nfs
    nfs_acl                 1792  1 nfs
    sunrpc                101884  10 nfs,lockd,nfs_acl


to me, this looks like "CONFIG_NETWORK_FILESYSTEMS" is "forgotten" in
config.gz, but what do I know ...

please fix if possible,
thanks,
h. rosmanith
