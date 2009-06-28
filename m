Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbZF1TbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbZF1TbW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 15:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbZF1TbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 15:31:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42471 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbZF1TbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 15:31:14 -0400
Date: Sun, 28 Jun 2009 21:31:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
       earl_chew@agilent.com, Oleg Nesterov <oleg@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] exec: Make do_coredump more robust and safer when using pipes in core_pattern
Message-ID: <20090628193112.GA6760@one.firstfloor.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org> <20090626104804.GA7337@hmsreliant.think-freely.org> <20090626092001.32e35e17.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626092001.32e35e17.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One way would be to add a new sysctl-externs.h and then put all the
> declarations in there.  That file gets included by sysctl.c and by each
> file which shares a global with sysctl.c

Long ago I had a experimental patch to put sysctls into a new ELF section. The 
you could simply put a DEFINE_SYSCTL(....) into the appropiate source file
which defined the variable and most of the tables went.

No externs, no mess, no patch collisions, everything much nicer.

The only problem was that it didn't support the numerical sysctl
space, so that would need to be removed first.

It's deprecated for quite some time now:

  if (msg_count < 5) {
                msg_count++;
                printk(KERN_INFO
                        "warning: process `%s' used the deprecated sysctl "
                        "system call with ", current->comm);

Should it finally go now? If yes I could polish up the old patch again.


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
