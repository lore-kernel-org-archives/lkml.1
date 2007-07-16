Return-Path: <linux-kernel-owner+w=401wt.eu-S932136AbXGPXTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136AbXGPXTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756288AbXGPXTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:19:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41812 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbXGPXTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:19:05 -0400
Date: Tue, 17 Jul 2007 00:18:55 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH] utime(s): Honour CAP_FOWNER when times==NULL
Message-ID: <20070716231855.GL21668@ftp.linux.org.uk>
References: <20070716185423.1607.78787.sendpatchset@cselinux1.cse.iitk.ac.in> <alpine.LFD.0.999.0707161142210.20061@woody.linux-foundation.org> <Pine.LNX.4.64.0707170054100.2005@cselinux1.cse.iitk.ac.in> <20070716204523.GJ21668@ftp.linux.org.uk> <Pine.LNX.4.64.0707170306200.2005@cselinux1.cse.iitk.ac.in> <Pine.LNX.4.64.0707170322430.2005@cselinux1.cse.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707170322430.2005@cselinux1.cse.iitk.ac.in>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 03:24:14AM +0530, Satyam Sharma wrote:
> On Tue, 17 Jul 2007, Satyam Sharma wrote:
> > [...]
> > Anwyay, so I'm thinking of adding:
> > 
> > struct inode;
> > 
> > int is_not_owner(struct inode *)
> 
>   ^static inline                 ^inode
> 
> of course.
 
> > {
> > 	return ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER));
> > }

This is pointless.  If you do not have definition of struct inode
already available, you'll get breakage on access to ->i_uid.
