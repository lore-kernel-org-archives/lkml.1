Return-Path: <linux-kernel-owner+w=401wt.eu-S1759635AbZF2UKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635AbZF2UKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 16:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbZF2UKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 16:10:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752778AbZF2UKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 16:10:08 -0400
Date: Mon, 29 Jun 2009 13:09:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Eric Paris <eparis@redhat.com>
cc: Al Viro <viro@zeniv.linux.org.uk>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Kerr <jk@ozlabs.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] notification tree - fsnotify assumes incorrectly
 positive parent dentry
In-Reply-To: <1246305712.754.292.camel@dhcp235-23.rdu.redhat.com>
Message-ID: <alpine.LFD.2.01.0906291305030.3605@localhost.localdomain>
References: <1246305712.754.292.camel@dhcp235-23.rdu.redhat.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Jun 2009, Eric Paris wrote:
>
> Linus please consider pulling from the notification tree.  There is one
> patch in the tree which should fix an issue in which fsnotify assumed
> that dentry->d_parent->d_inode != NULL.  This turns out to be false for
> spufs and causes a panic.

Hmm. It does sound like a reasonable assumption, though. Maybe spufs 
should be fixed to have an inode for all directories?

A NULL d_inode means that something is a negative dentry, and a negative 
dentry shouldn't have children.

Added a few ppc people to the cc.

I'll pull the fix, but I really think it sounds like spufs is doing 
something wrong here.

			Linus
