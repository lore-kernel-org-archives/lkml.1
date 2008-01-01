Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbYAAFjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbYAAFjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 00:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbYAAFjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 00:39:23 -0500
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:59795 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750983AbYAAFjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 00:39:22 -0500
X-Greylist: delayed 2213 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jan 2008 00:39:21 EST
Date: Tue, 1 Jan 2008 00:01:54 -0500
From: Theodore Tso <tytso@mit.edu>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Miller <davem@davemloft.net>,
       jengelh@computergmbh.de, devzero@web.de, linux-kernel@vger.kernel.org,
       bunk@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Force UNIX domain sockets to be built in
Message-ID: <20080101050154.GG11776@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Bodo Eggert <7eggert@gmx.de>, Al Viro <viro@ZenIV.linux.org.uk>,
	David Miller <davem@davemloft.net>, jengelh@computergmbh.de,
	devzero@web.de, linux-kernel@vger.kernel.org, bunk@kernel.org,
	netdev@vger.kernel.org
References: <alpine.LSU.0.999.0712311300020.3686@be1.lrz> <20071231.042055.145660385.davem@davemloft.net> <alpine.LSU.0.999.0712311426520.3761@be1.lrz> <20071231193848.GQ27894@ZenIV.linux.org.uk> <alpine.LSU.0.999.0801010418260.2337@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.0.999.0801010418260.2337@be1.lrz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 04:45:21AM +0100, Bodo Eggert wrote:
> > udev-free != embedded.
> 
> But UNIX=m == waste RAM and have an effectively b0rken system until the 
> module is loaded. 

Well, the system isn't necessarily totally broken.  If you don't use
udev, then system will be crippled, but not totally broken.  Then
again, besides udev, packages such as dbus, gdm, and acpid all use
Unix Domain Sockets --- not to mention cups, avahi-daemon, bluez,
emacsclient, and any X program when the DISPLAY is :0.0.

The question is whether the size of the Unix domain sockets support is
worth the complexity of yet another config option that we expose to
the user.  For the embedded world, OK, maybe they want to save 14k of
non-swappable memory.  But for the non-embedded world, given the 117k
mandatory memory usage of sysfs, or the 124k memory usage of the core
networking stack, never mind the 3 megabytes of memory used by objects
in the kernel subdirectory, it's not clear that it's worth worrying
over 14k of memory, especially when many Unix programs assume
that Unix Domain Sockets are present.

						- Ted
