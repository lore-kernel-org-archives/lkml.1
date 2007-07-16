Return-Path: <linux-kernel-owner+w=401wt.eu-S1763348AbXGPVbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763348AbXGPVbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759148AbXGPVbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:31:07 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:35529 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756789AbXGPVbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:31:06 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Tue, 17 Jul 2007 03:24:14 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Al Viro <viro@ftp.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH] utime(s): Honour CAP_FOWNER when times==NULL
In-Reply-To: <Pine.LNX.4.64.0707170306200.2005@cselinux1.cse.iitk.ac.in>
Message-ID: <Pine.LNX.4.64.0707170322430.2005@cselinux1.cse.iitk.ac.in>
References: <20070716185423.1607.78787.sendpatchset@cselinux1.cse.iitk.ac.in>
 <alpine.LFD.0.999.0707161142210.20061@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707170054100.2005@cselinux1.cse.iitk.ac.in>
 <20070716204523.GJ21668@ftp.linux.org.uk> <Pine.LNX.4.64.0707170306200.2005@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Satyam Sharma wrote:
> [...]
> Anwyay, so I'm thinking of adding:
> 
> struct inode;
> 
> int is_not_owner(struct inode *)

  ^static inline                 ^inode

of course.

> {
> 	return ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER));
> }
> 
> to linux/capability.h inside the __KERNEL__ #ifdef, asm/current.h is
> included in there already.
> 
> And then do the necessary conversions. Sounds OK?
> 
> Satyam
> 
