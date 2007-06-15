Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbXFOVmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbXFOVmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbXFOVmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:42:13 -0400
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:36380 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbXFOVmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:42:11 -0400
Date: Fri, 15 Jun 2007 17:42:08 -0400 (EDT)
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
In-Reply-To: <20070615211157.GB7337@kroah.com>
Message-ID: <Line.LNX.4.64.0706151736030.28697@localhost.localdomain>
References: <20070514110607.549397248@suse.de> <200706090003.57722.agruen@suse.de>
 <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com>
 <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz>
 <20070615211157.GB7337@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007, Greg KH wrote:

> > Or just create the files with restrictive labels by default. That way
> > you "fail closed".
> 
> From my limited knowledge of SELinux, this is the default today so this
> would happen by default.  Anyone with more SELinux experience want to
> verify or fix my understanding of this?

This is entirely controllable via policy.  That is, you specify that newly 
create files are labeled to something safe (enforced atomically at the 
kernel level), and then your userland relabeler would be invoked via 
inotify to relabel based on your userland pathname specification.

This labeling policy can be as granular as you wish, from the entire 
filesystem to a single file.  It can also be applied depending on the 
process which created the file and the directory its created in, ranging 
from all processes and all directories, to say, just those running as 
user_t in directories labeled as public_html_t (or whatever).



- James
-- 
James Morris
<jmorris@namei.org>
