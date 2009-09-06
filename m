Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbZIFPvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbZIFPvz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 11:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757998AbZIFPvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 11:51:52 -0400
Received: from THUNK.ORG ([69.25.196.29]:54555 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758001AbZIFPvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 11:51:51 -0400
Date: Sun, 6 Sep 2009 11:51:47 -0400
From: Theodore Tso <tytso@mit.edu>
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: block_dump - full path ?
Message-ID: <20090906155147.GH3055@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, devzero@web.de,
	linux-kernel@vger.kernel.org
References: <899288751@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <899288751@web.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 05, 2009 at 11:44:35PM +0200, devzero@web.de wrote:
> Hi, 
> 
> i came across the nice debugging feature sysctl vm.block_dump=1 which leaves information on read/write in dmesg for every process.
> 
> Sep  5 20:11:15 neoware kernel: kjournald(423): WRITE block 155542512 on sda2
> Sep  5 20:11:15 neoware kernel: kjournald(423): WRITE block 155542520 on sda2
> Sep  5 20:11:15 neoware kernel: kjournald(423): WRITE block 155542528 on sda2
> Sep  5 20:11:19 neoware kernel: pdflush(14): WRITE block 144498288 on sda2
> Sep  5 20:11:19 neoware kernel: pdflush(14): WRITE block 144916496 on sda2
> Sep  5 20:11:19 neoware kernel: pdflush(14): WRITE block 144917376 on sda2
> Sep  5 20:11:19 neoware kernel: pdflush(14): WRITE block 144704600 on sda2
> 
> is it possible to log the full path of the process ?

What do you mean by "the full path of the process"?  Do you mean the
full path of the process' executable?  (In this case kjournald and
pdflush are kernel threads so there is no executable, and thus there
is no "full path". unless you mean pathname to the kernel, i.e., /vmlinux.)

Or did you mean the full path name of the file associated with the
block number?  In this case, kjournald is writing to the file system
journal, which has no pathname.  pdflush is writing dirty pages from
the page cache, which could be mapped to file names, but it would take
up a huge amount of space in the log -- but to what effect?

What exactly are you trying to do?  There might be a more efficient
way of gathering whatever data you are trying to get for your experiment.

       		 	       	       - Ted
