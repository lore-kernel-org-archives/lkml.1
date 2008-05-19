Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbYESW4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbYESW4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbYESW4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:56:25 -0400
Received: from vena.lwn.net ([206.168.112.25]:39458 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbYESW4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:56:24 -0400
To: Roland Dreier <rdreier@cisco.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH, RFC] Char dev BKL pushdown v2 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Mon, 19 May 2008 15:18:06 PDT."
             <aday7665469.fsf@cisco.com> 
Date: Mon, 19 May 2008 16:56:24 -0600
Message-ID: <26562.1211237784@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> wrote:

> Thanks.  Just to be super-explicit, ioctl() cannot be called on a given
> file until the open() for that particular file has returned, right?

ioctl() will not be called on a given file descriptor before open() is
done, no.  If there are other file descriptors open, though, somebody
can be calling ioctl() on them while the open() for the new one is
executing.
 
> And the point about driver initialization is that open() can be called
> as soon as the file operations are registered, even if the module_init
> function has not returned?

That is the point, yes.  The key there is to avoid registering the
device before everything has been set up to actually manage the device. 

jon
