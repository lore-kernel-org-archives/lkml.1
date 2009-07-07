Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbZGGU5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbZGGU5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 16:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbZGGU5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 16:57:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35833 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbZGGU5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 16:57:43 -0400
Subject: Re: fanotify: the fscking all notification system
From: Eric Paris <eparis@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, malware-list@dmesg.printk.net
In-Reply-To: <63598.1246995702@turing-police.cc.vt.edu>
References: <1246306125.754.300.camel@dhcp235-23.rdu.redhat.com>
	 <22424.1246368155@turing-police.cc.vt.edu>
	 <1246382797.22562.16.camel@dhcp235-23.rdu.redhat.com>
	 <63598.1246995702@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 16:57:11 -0400
Message-Id: <1247000231.2866.130.camel@dhcp235-23.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-07 at 15:41 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 30 Jun 2009 13:26:37 EDT, Eric Paris said:

> > 1) the fd the fanotify listener gets is O_RDONLY.  I think I'll add an
> > "f_flags" option which if 0 defaults to O_RDONLY|O_LARGEFILE like we
> > have today but which you could use to indicate O_RDWR or O_WRONLY.  We
> > currently give O_RDONLY since you can't request O_WR* on files/libraries
> > mapped exec, so this won't work for executables.....
> 
> Having only O_RDONLY is a show-stopper, because then we can't replace the file
> contents before continuing.  For many places, the executables and shared
> libraries aren't the problem, so "You can't HSM an executable" as a
> semi-permanent restriction isn't too bad.

My current devel work allows you to set to open flags.  So an HSM would
use O_RDWR|O_LARGEFILE whereas a file scanner/indexer which cares about
executables/libraries would use O_RDONLY|O_LARGEFILE.

> > 2) Right now you have 5 seconds to answer an fanotify permissions
> > request, if you don't get it in 5 seconds you are done and the original
> > process gets an allow.  But I have a half finished patch which would
> > allow you to delay them infinitely.  As long as you keep them delayed
> > you can modify the file they are about to access however you like.
> 
> That would work fine.

I've added the ability to delay indefinitely.  Maybe your tape
robot/intern is slow/busy.  I'll point you to code when I want you to
see it   :)

> Yes, it's sounding like it. If that's in mainstream, then I can deploy an HSM
> without needing kernel hackery like most do currently.

I'm trying to be useful!

-Eric

