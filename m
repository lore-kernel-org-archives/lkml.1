Return-Path: <linux-kernel-owner+w=401wt.eu-S1761344AbXFTHzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761344AbXFTHzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 03:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757761AbXFTHzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 03:55:22 -0400
Received: from main.gmane.org ([80.91.229.2]:36181 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755748AbXFTHzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 03:55:21 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jan Blunck <jblunck@suse.de>
Subject: Re: [RFC PATCH 1/4] Union mount documentation.
Date: Wed, 20 Jun 2007 07:29:55 +0000 (UTC)
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
Message-ID: <f5al1i$foi$1@sea.gmane.org>
References: <20070620055050.GB4267@in.ibm.com>
	<20070620055157.GC4267@in.ibm.com>
	<1182319191.2700.9.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: charybdis-ext.suse.de
User-Agent: pan 0.119 (Karma Hunters)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007 22:59:51 -0700, Arjan van de Ven wrote:

> first of all I'm happy to see that people are still working on unionfs;
> I'd love to have functionality like this show up in Linux.

This has nothing to do with unionfs. This is about doing a VFS based
approach to union mounts. Unification is a name-based construct so it
belongs into VFS and not into a separate file system.

> I'll not claim to have any VFS knowledge whatsoever, but I was just
> wondering what happens in the following scenario:
> 
> FS A is mounted twice, in /mnt/A and /mnt/union
> 
> FS B is mounted twice, in /mnt/B and as topmost union mount
> on /mnt/union
> 
> lets for simplicity say both filesystems are entirely empty
> 
> user does on FS A: 
> mkdir  /mnt/A/somedir
> touch /mnt/A/somedir/somefile
> 
> and then 2 things happen in parallel
> 1) touch /mnt/B/somefile
> 2) mv /mnt/union/somedir /mnt/union/somefile
> 
> since the underlying FS for 2) is FS A... how will this work out locking
> wise? Will the VS lock the union directory only? Or will this operate
> only on the underlying FS? How is dcache consistency guaranteed for
> scenarios like this?

Mounting a file system twice is bad in the first place. This should be
done by using bind mounts and bind a mounted file system into a union.
After that the normal locking rules apply (and hopefully work ;).

Jan

