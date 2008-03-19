Return-Path: <linux-kernel-owner+w=401wt.eu-S1161582AbYCSXyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161582AbYCSXyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S941211AbYCSW23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:28:29 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:41889 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S941209AbYCSW20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:28:26 -0400
Date: Wed, 19 Mar 2008 16:28:08 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, joe@fruitfly.org
Subject: Re: [Bugme-new] [Bug 10284] New: executables with read bit 'off' cannot open /dev/stdin
Message-ID: <20080319222808.GF424@parisc-linux.org>
References: <bug-10284-10286@http.bugzilla.kernel.org/> <20080319143108.c8f8a544.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080319143108.c8f8a544.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 02:31:08PM -0700, Andrew Morton wrote:
> > Problem Description: if the read bit of a binary executable is off, then open()
> > on /dev/stdin fails with a EACCES error.
> 
> This is, umm, unexpected?

I'm not sure it's unexpected.  It's undesirable, certainly.

> > open("/dev/stdin", O_RDONLY)            = -1 EACCES (Permission denied)
> > 
> > The last line shows a Permission denied error on opening /dev/stdin. If a
> > normal filesystem (i.e. not-/dev/) filename is used, the open works normally.
> > 
> > I have reproduced this on 2.4 and 2.6 kernels
> > Just a guess here: is an error flag from attempting to read the binary not
> > getting cleared and is being reported when trying to open stdin?

I think the guess is faulty.  Could you show ls -l /dev/stdin ?  On my
system, it reports:

lrwxrwxrwx 1 root root 15 2008-03-10 11:03 /dev/stdin -> /proc/self/fd/0

Wild guess: Users can't access /proc/ directories of executables with the
read-bit clear in order to prevent users from reading the state anyway.

I wonder how effective clearing the read-bit is these days.
Don't we all have source to all the applications anyway?  ;-)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
