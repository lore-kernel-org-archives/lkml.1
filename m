Return-Path: <linux-kernel-owner+w=401wt.eu-S1758423AbYCYQG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423AbYCYQG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757953AbYCYQGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:06:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757715AbYCYQGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:06:03 -0400
Date: Tue, 25 Mar 2008 09:05:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] vfs patches
In-Reply-To: <20080325081752.GJ10722@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.00.0803250859330.2775@woody.linux-foundation.org>
References: <20080325081752.GJ10722@ZenIV.linux.org.uk>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 Mar 2008, Al Viro wrote:
>
> misc VFS fixes for 2.6.25.  Please pull from
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Pulled.

And looking at the diffs, I see sequences like

	dget(save.dentry);
	mntget(save.mnt);
	...
	path_put(&save);

which looks very strange compared to the natural sequence:

	path_get(&save);
	..
	path_put(&save);

and yes, I realize the code was just moved (and the reason for the mixing 
is that the "path_put()" conversion was done much more aggressively, as 
the ordering matters), but I'm bringing this up in the hope somebody has 
the energy to clean things like up some day...

			Linus
