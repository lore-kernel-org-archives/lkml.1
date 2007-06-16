Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbXFPBWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbXFPBWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 21:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757464AbXFPBWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 21:22:04 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:38469 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756265AbXFPBWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 21:22:01 -0400
Date: Fri, 15 Jun 2007 21:21:57 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@localhost.localdomain
To: Greg KH <greg@kroah.com>
cc: Pavel Machek <pavel@ucw.cz>, Crispin Cowan <crispin@novell.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <20070615235041.GC15056@kroah.com>
Message-ID: <Line.LNX.4.64.0706152057390.29737@localhost.localdomain>
References: <20070514110607.549397248@suse.de> <200706090003.57722.agruen@suse.de>
 <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com>
 <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz>
 <20070615211157.GB7337@kroah.com> <Line.LNX.4.64.0706151736030.28697@localhost.localdomain>
 <20070615235041.GC15056@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007, Greg KH wrote:

> Oh great, then things like source code control systems would have no
> problems with new files being created under them, or renaming whole
> trees.

It depends -- I think we may be talking about different things.

If you're using inotify to watch for new files and kick something in 
userspace to relabel them, it could take a while to relabel a lot of 
files, although there are likely some gains to be had from parallel 
relabeling which we've not explored.

What I was saying is that you can use traditional SELinux labeling policy 
underneath that to ensure that there is always a safe label on each file 
before it is relabeled from userspace.

> So, so much for the "it's going to be too slow re-labeling everything"
> issue, as it's not even required for almost all situations :)

You could probably get an idea of the cost by running something like:

$ time find /usr/src/linux | xargs setfattr -n user.foo -v bar

On my system, it takes about 1.2 seconds to label a fully checked out 
kernel source tree with ~23,000 files in this manner, on a stock standard 
ext3 filesystem with a SATA drive.



- James
-- 
James Morris
<jmorris@namei.org>
