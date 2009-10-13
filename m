Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbZJMBF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbZJMBF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 21:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbZJMBF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 21:05:59 -0400
Received: from thunk.org ([69.25.196.29]:53151 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbZJMBF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 21:05:58 -0400
Date: Mon, 12 Oct 2009 21:05:18 -0400
From: Theodore Tso <tytso@mit.edu>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Weird ext4 bug: 256P used?
Message-ID: <20091013010518.GA2606@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Felipe Contreras <felipe.contreras@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <94a0d4530910120651i18ce33d2k89abcd66d1b865a1@mail.gmail.com> <20091012222910.GB18195@mit.edu> <94a0d4530910121602i14f34150h18d388668fc355d9@mail.gmail.com> <20091012231211.GC18195@mit.edu> <94a0d4530910121627j74faac64l29169e17c0b2961b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94a0d4530910121627j74faac64l29169e17c0b2961b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 02:27:48AM +0300, Felipe Contreras wrote:
> 
> stat /var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.0.0.72-fc5-i586
>   File: `/var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.0.0.72-fc5-i586'
>   Size: 4096      	Blocks: 281470681743368 IO Block: 4096   directory
> Device: fe00h/65024d	Inode: 141257      Links: 2
> Access: (0755/drwxr-xr-x)  Uid: (4294901760/ UNKNOWN)   Gid: (16711680/ UNKNOWN)
> Access: 2009-10-12 16:36:22.326920328 +0300
> Modify: 2009-07-27 20:52:23.000000000 +0300
> Change: 2009-07-27 20:52:23.000000000 +0300

OK, I see what's going on.   i_blocks_hi is getting set to 0xFFFF.

So I definitely see the bug in e2fsck in not reporitng and fixing the
problem (and I'll fix that).  I'm not sure how i_blocks_hi got set to
that value, though; it looks like everything should be doing the right
thing in the latest mainline kernel.  What version of the kernel are
you using?

     	    	     	  	     	 - Ted
