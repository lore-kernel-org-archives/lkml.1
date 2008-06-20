Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbYFTTJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbYFTTJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 15:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbYFTTJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 15:09:07 -0400
Received: from vena.lwn.net ([206.168.112.25]:47199 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231AbYFTTJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 15:09:07 -0400
Date: Fri, 20 Jun 2008 13:09:05 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH, RFC] fasync() BKL pushdown
Message-ID: <20080620130905.6694a7be@bike.lwn.net>
In-Reply-To: <485BEEF7.2020404@firstfloor.org>
References: <20080620112914.783be428@bike.lwn.net>
	<485BEEF7.2020404@firstfloor.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008 19:55:03 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Jonathan Corbet wrote:
> 
> > The majority of fasync() functions just call fasync_helper() with a
> > pointer to an fasync_struct reachable from the file structure.
> > Given that (1) the struct file will not go away while fasync() is
> > running, and (2) the VFS-level fasync() stuff is protected with the
> > Big Fasync Lock, I contend that these simple implementations have
> > no need for the BKL.  
> 
> Not necessarily true, they might require BKL still for fd live time
> issues.

Could you help me out a bit here?  I'm even slower than usual when it
comes to VFS stuff.  As far as I can tell, the given file cannot go
away during the call to fasync(), as sys_fcntl() holds a reference on
it.  Are you saying that something else can happen during that time?

Thanks,

jon
