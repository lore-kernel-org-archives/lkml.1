Return-Path: <linux-kernel-owner+w=401wt.eu-S932583AbXCMT17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583AbXCMT17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 15:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933345AbXCMT17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 15:27:59 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47300 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583AbXCMT16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 15:27:58 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, David Miller <davem@davemloft.net>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Linux v2.6.21-rc3
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
Date: Tue, 13 Mar 2007 13:26:48 -0600
In-Reply-To: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
	(Linus Torvalds's message of "Tue, 6 Mar 2007 20:59:01 -0800 (PST)")
Message-ID: <m1zm6hq70n.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Here is a quick summary of the regressions I am looking at.

- Currently we appear to have a pid leak in tty_io.c
  http://lkml.org/lkml/2007/3/8/222

- There is a missing init_WORK in vt.c that cases oops
  when we attempt to use SAK.
  http://lkml.org/lkml/2007/3/11/148

- We have a network ABI regression caused by the latest sysfs
  changes to net-sysfs.c   In particular we now cannot rename network
  devices if our destination name happens to be the name of a sysfs file that
  the network device appears in, and if we try the kernel gets very
  confused and we loose access to the network device. 

  Do we just want to revert commit 43cb76d91ee85f579a69d42bc8efc08bac560278
  Greg has been working on this off and on and has not found a
  simple solution yet.

- pci_save_state, pci_restore_state are broken and have been for a
  while if used on anything besides plain pci (pci-x, pci-e and msi)
  and are not used in pairs. (gregkh and Andrew have the patches to 
  correct this).

- I am still confirming that I have fixed all of the irq handling
  problems that resulted in the "No irq for vector" message.  I think
  I have but I have at least one indirect bug report that I'm still
  following up on.

Eric
