Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458AbXDXUkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbXDXUkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbXDXUkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:40:11 -0400
Received: from web36603.mail.mud.yahoo.com ([209.191.85.20]:28655 "HELO
	web36603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754458AbXDXUkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:40:09 -0400
X-RocketYMMF: rancidfat
Date: Tue, 24 Apr 2007 13:40:05 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [ANNOUNCE] UidBind LSM 0.2
To: Gerhard Mack <gmack@innerfire.net>, Roberto De Ioris <roberto@unbit.it>
Cc: linux-security-module@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704241610120.21879@mtl.rackplans.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <36153.9499.qm@web36603.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Gerhard Mack <gmack@innerfire.net> wrote:

> On Tue, 24 Apr 2007, Roberto De Ioris wrote:
> 
> > Hi all,
> > 
> > this is the second release for UidBind LSM:
> > 
> > http://projects.unbit.it/uidbind/
> > 
> > UidBind allows call to bind() function only to the uid defined in a
> > configfs tree.
> > 
> > It is now possible to specify different uid (for the same port) on
> > different ipv4 addresses:
> > 
> > mkdir uidbind/8081
> > mkdir uidbind/8081/192.168.1.17
> > mkdir uidbind/8081/192.168.1.26
> > echo 1017 > uidbind/8081/192.168.1.17/uid
> > echo 1026 > uidbind/8081/192.168.1.26/uid
> > 
> > This version even fix some leek in version 0.1
> > 
> > Patch attached is still for vanilla 2.6.20.7
> 
> Is it possible to specify ranges as allowing everyone?  Is it possible to 
> allow multiple users acess to the same port?  Can ports be allowed by 
> group?

If you're going to go beyond the simple owner access model it
probably makes sense to go all out, swipe the file system ACL
code and provide the whole nine yards of users, groups, and modes.
The only system that I know of that had socket ACLs was the 4.X
version of Trusted Irix, and socket ACLs were dropped in 5.0 because
they were unpopular.

If you're daring you could propose that low number ports be treated
the same way as other ports, with the default ownership being root and
the default ACL allowing only root.

> I really like the idea of this patch.  It has the potential to solve a lot 
> of my current administrative headachs.

Putting access control on ports rather than sockets is a novel
approach. It is a lot simpler underneath and more consistant with
the way other object name spaces are treated.


Casey Schaufler
casey@schaufler-ca.com
