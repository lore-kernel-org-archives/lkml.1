Return-Path: <linux-kernel-owner+w=401wt.eu-S1764261AbXJEVNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764261AbXJEVNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 17:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763107AbXJEVNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 17:13:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49568 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763040AbXJEVNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 17:13:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: regression: fireware causes oops during system
Date: Fri, 5 Oct 2007 23:28:13 +0200
User-Agent: KMail/1.9.5
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Ben Collins <ben.collins@ubuntu.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>
References: <20070911190043.GA1577@elf.ucw.cz> <200709162216.02448.rjw@sisk.pl> <20071005070817.GA8821@elf.ucw.cz>
In-Reply-To: <20071005070817.GA8821@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710052328.14423.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 5 October 2007 09:08, Pavel Machek wrote:
> Hi!
> 
> > > This commit is certainly OK, as it should merely preserve status quo.
> > > Also note that Pavel wrote in his initial post that the problem became
> > > apparent way after -rc1.  Full quote:
> > > 
> > > | I noticed empty suspend stopped working around 2.6.23-rc4, and it is
> > > | still present in 2.6.23-rc6. To reproduce
> > > |
> > > | swapoff -a
> > > | echo disk > /sys/power/state
> > > | echo disk > /sys/power/state
> > > |
> > > | Unsetting
> > > |
> > > | CONFIG_IEEE1394=y
> > > |
> > > | solves the problem.
> > 
> > Yes.
> > 
> > I thought that there might be a later change that exposed a bug in it.
> > 
> > Hm.  Pavel, can you do
> > 
> > # echo test > /sys/power/disk
> > # echo disk > /sys/power/state
> > 
> > and see what happens?
> 
> root@amd:~# echo test  > /sys/power/disk
> root@amd:~# echo disk > /sys/power/state
> root@amd:~# echo disk > /sys/power/state
> 
> Produces nothing interesting... I also did few hibernation/resume
> cycles, and everything seems to work ok. But when I do swapoff then
> try to hibernate, it fails on second try. Weird.

Weird indeed, but it means that there's some history that causes things to
break on the second attempt.

To summarize, after running swapoff the suspending of devices during the second
attempt to hibernate fails (100% of the time) unless CONFIG_IEEE1394 is unset?

What happens for CONFIG_IEEE1394=m?

Greetings,
Rafael
