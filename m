Return-Path: <linux-kernel-owner+w=401wt.eu-S1756443AbZCXIRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443AbZCXIRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbZCXIQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:16:47 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49086 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbZCXIQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:16:46 -0400
From: hooanon05@yahoo.co.jp
Subject: Q. DEBUG_FS and SYSFS config (Re: [RFC Aufs2 #3 2/2] split 'xino' entry under sysfs)
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20090320054437.GC3993@kroah.com>
References: <1237439565-25039-1-git-send-email-hooanon05@yahoo.co.jp> <1237439565-25039-3-git-send-email-hooanon05@yahoo.co.jp> <20090320004539.GF18781@kroah.com> <3934.1237515949@jrobl> <20090320024249.GA19989@kroah.com> <4443.1237517709@jrobl> <20090320030608.GA2638@kroah.com> <5142.1237521581@jrobl> <20090320041811.GA3352@kroah.com> <6218.1237526149@jrobl> <20090320054437.GC3993@kroah.com>
Date: Tue, 24 Mar 2009 17:16:40 +0900
Message-ID: <2778.1237882600@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg KH:
> No one disables sysfs that I know of.  Heck, my phone enables sysfs...
> 
> > Addition to set limit, there is one more reason to adopt seq_file.
> > Because the printed string is a path, it may contain unprintable
> > characters. seq_file has a good interface seq_path() which supports
> > escaping such characters.
> 
> That is true.  Ok, let's see the final result and I'll be glad to look
> at it.

Hi Greg,

Currently I am testing locally about new aufs entries under debugfs, and
I found a strange issue about configuration.

First, configure "normaly".
General setup
  [ ] Configure standard kernel features (for small systems)  --->

$ egrep -i '(sysfs|debug_fs)' .config
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_SYSFS=y
CONFIG_DEBUG_FS=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set

Next, enable EMBEDED, and then disable SYSFS.
General setup
  [*] Configure standard kernel features (for small systems)  --->
File systems
  Pseudo filesystems  --->
    [ ] sysfs file system support

$ egrep -i '(sysfs|debug_fs)' .config
# CONFIG_SYSFS is not set
CONFIG_DEBUG_FS=y

SYSFS is disabled expectedly, but DEBUG_FS is still enabled,
while "depends on SYSFS" is specified for DEBUG_FS.

Is this expected behaviour?
In other words, can I assume "when DEBUG_FS is enabled, SYSFS must be
enabled too" safely?


J. R. Okajima
