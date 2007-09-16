Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbXIPUDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbXIPUDw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 16:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbXIPUDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 16:03:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51970 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbXIPUDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 16:03:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>, Pavel Machek <pavel@ucw.cz>
Subject: Re: regression: fireware causes oops during system
Date: Sun, 16 Sep 2007 22:16:01 +0200
User-Agent: KMail/1.9.5
Cc: Ben Collins <ben.collins@ubuntu.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>
References: <20070911190043.GA1577@elf.ucw.cz> <200709162152.24793.rjw@sisk.pl> <46ED8AD0.2040004@s5r6.in-berlin.de>
In-Reply-To: <46ED8AD0.2040004@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709162216.02448.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 16 September 2007 21:58, Stefan Richter wrote:
> Rafael J. Wysocki wrote:
> >> Pavel Machek wrote:
> >>> commit 831441862956fffa17b9801db37e6ea1650b0f69
> >>> tree b0334921341f8f1734bdd3243de76d676329d21c
> >>> parent 787d2214c19bcc9b6ac48af0ce098277a801eded
> >>> author Rafael J. Wysocki <rjw@sisk.pl> Tue, 17 Jul 2007 04:03:35 -0700
> >>> committer Linus Torvalds <torvalds@woody.linux-foundation.org> Tue, 17
> >>> Jul 2007 10:23:02 -0700
> >>>
> >>>     Freezer: make kernel threads nonfreezable by default
> > 
> > Well, I don't think so.
> > 
> > nodemgr_host_thread() calls set_freezable() as it should.
> 
> This commit is certainly OK, as it should merely preserve status quo.
> Also note that Pavel wrote in his initial post that the problem became
> apparent way after -rc1.  Full quote:
> 
> | I noticed empty suspend stopped working around 2.6.23-rc4, and it is
> | still present in 2.6.23-rc6. To reproduce
> |
> | swapoff -a
> | echo disk > /sys/power/state
> | echo disk > /sys/power/state
> |
> | Unsetting
> |
> | CONFIG_IEEE1394=y
> |
> | solves the problem.

Yes.

I thought that there might be a later change that exposed a bug in it.

Hm.  Pavel, can you do

# echo test > /sys/power/disk
# echo disk > /sys/power/state

and see what happens?

Greetings,
Rafael
