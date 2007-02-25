Return-Path: <linux-kernel-owner+w=401wt.eu-S965199AbXBYXGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965199AbXBYXGl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 18:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965217AbXBYXGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 18:06:41 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52147 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965199AbXBYXGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 18:06:41 -0500
Date: Sun, 25 Feb 2007 15:06:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Joel Becker <Joel.Becker@oracle.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: mincore returning -ENOMEM instead of -EFAULT
In-Reply-To: <20070223225847.GL7920@ca-server1.us.oracle.com>
Message-ID: <Pine.LNX.4.64.0702251504400.12485@woody.linux-foundation.org>
References: <20070223225847.GL7920@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 23 Feb 2007, Joel Becker wrote:
>
> 	Your fix in commit 2f77d107050abc14bc393b34bdb7b91cf670c250
> modifies sys_mincore() to return -ENOMEM instead of -EFAULT on a totally
> bogus address.  Was this intentional, or is it something that should be
> fixed up?

It was intentional, and I don't actually think it was even a change. The 
access_ok() in question is not done on the actual array that we fill up 
with the result of the operation, but on the address range that is being 
queried, and if the queried address range is bogus, we should return 
ENOMEM.

It's even mentioned in the man-page..

We *do* return -EFAULT for the case where the "vec" array itself is not 
mapped.

		Linus
