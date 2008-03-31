Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbYCaSZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbYCaSZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 14:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbYCaSZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 14:25:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752274AbYCaSZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 14:25:42 -0400
Date: Mon, 31 Mar 2008 11:24:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Greg KH <greg@kroah.com>, Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] evdev: Release eventual input device grabs when getting
 disconnected
In-Reply-To: <20080331135653.ZZRA012@mailhub.coreip.homeip.net>
Message-ID: <alpine.LFD.1.00.0803311122040.14670@woody.linux-foundation.org>
References: <20080330184259.GB21375@atjola.homenet> <alpine.LFD.1.00.0803301448190.14670@woody.linux-foundation.org> <200803310215.39414.dtor@insightbb.com> <20080331172813.GA11583@kroah.com> <20080331135653.ZZRA012@mailhub.coreip.homeip.net>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 31 Mar 2008, Dmitry Torokhov wrote:
> 
> Greg, please look at the change again. Before kobject_put(kobj->parent)
> was done in kobject_cleanup() and so the parent would only be freed when
> all its children are gone. Now parent is deleted early, even if its
> children are still referenced by other users. This is lifetime rule
> change and should really be announced as such.
> 
> If this change it intentional and is here to stay then I will just grab
> the references myself, although I wonder what else might be broken by
> it.

I do agree that this might want reverting, unless there is some rally good 
reason for it. People may have pefectly valid reasons to expect topology 
and reachability to remain valid - it's certainly what we guarantee in the 
VFS code for similar rules (ie the parent of a dentry is only free'd after 
all children have gone away).

Greg, is it possible to get the old lifetime rules back wrt his? They seem 
valid and sane..

			Linus
