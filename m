Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbYG2Szt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbYG2Szt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 14:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbYG2Szj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 14:55:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44456 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbYG2Szi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 14:55:38 -0400
Date: Tue, 29 Jul 2008 19:55:37 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 2/2] Remove a few inlines in fs/namei.c
Message-ID: <20080729185537.GI28946@ZenIV.linux.org.uk>
References: <20080729155229.489904417@free-electrons.com>> <20080729155527.799486507@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729155527.799486507@free-electrons.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 05:52:31PM +0200, Thomas Petazzoni wrote:
> Uninline may_create() and do_follow_link() and use vfs_follow_link()
> instead of __vfs_follow_link() in __do_follow_link(). It allows to
> slightly reduce the size of kernel code:
> 
>    text	   data	    bss	    dec	    hex	filename
> 1114299	 118564	 212992	1445855	 160fdf	vmlinux.old
> 1112971	 118564	 212992	1444527	 160aaf	vmlinux
>   -1328       0       0   -1328    -530 +/-
> 
> This patch is part of the Linux Tiny project and has been originally
> written by Matt Mackall <mpm@selenic.com>

Absolutely not.  do_follow_link() et.al. are parts of mutual recursion
loop and we need to reduce the use of kernel *stack*.
