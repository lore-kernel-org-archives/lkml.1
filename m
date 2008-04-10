Return-Path: <linux-kernel-owner+w=401wt.eu-S1759836AbYDJPbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759836AbYDJPbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758273AbYDJPbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:31:16 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53874 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758109AbYDJPbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:31:15 -0400
Date: Thu, 10 Apr 2008 09:30:59 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jan Kara <jack@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
       Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080410153058.GT11962@parisc-linux.org>
References: <Pine.SOC.4.64.0804081101430.28938@math.ut.ee> <200804101555.58643.mhocko@suse.cz> <Pine.LNX.4.64.0804101558280.26562@twin.jikos.cz> <20080410142700.GC6725@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0804101628000.3896@jikos.suse.cz> <20080410144839.GQ11962@parisc-linux.org> <20080410152212.GF6725@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410152212.GF6725@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 05:22:12PM +0200, Jan Kara wrote:
>   You can get your inspiration in the implementation of i_size_read()
> and i_size_write() functions :). They deal with exactly the same problem.
> But in the case of f_pos, the number of readers and writers is balanced so
> maybe a spinlock would be fine as well...

It's not quite balanced -- see sys_getdents() for a counterexample.

i_size_read/write use a seqcount rather than a seqlock, but the
principle is the same.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
