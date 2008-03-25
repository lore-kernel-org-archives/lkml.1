Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbYCYSAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbYCYSAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 14:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757705AbYCYSAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 14:00:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58344 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347AbYCYSAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:00:15 -0400
Date: Tue, 25 Mar 2008 18:00:14 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] vfs patches
Message-ID: <20080325180014.GL10722@ZenIV.linux.org.uk>
References: <20080325081752.GJ10722@ZenIV.linux.org.uk> <alpine.LFD.1.00.0803250859330.2775@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803250859330.2775@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 09:05:59AM -0700, Linus Torvalds wrote:

> 	dget(save.dentry);
> 	mntget(save.mnt);
> 	...
> 	path_put(&save);
> 
> which looks very strange compared to the natural sequence:
> 
> 	path_get(&save);
> 	..
> 	path_put(&save);
> 
> and yes, I realize the code was just moved (and the reason for the mixing 
> is that the "path_put()" conversion was done much more aggressively, as 
> the ordering matters), but I'm bringing this up in the hope somebody has 
> the energy to clean things like up some day...

*nod*

Keep in mind that there's a lot more coming post-.25; FWIW, there's another
bunch of patches that probably ought to go before .25 (mount expiry stuff;
I'll do a bit of reordering and probably ask to pull tomorrow).

The next couple of cycles is going to get interesting around
fs/{namei,namespace,pnode,super,dentry}.c
