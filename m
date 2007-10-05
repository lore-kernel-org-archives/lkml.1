Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbXJEHJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbXJEHJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 03:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbXJEHIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 03:08:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:37447 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbXJEHIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 03:08:54 -0400
Date: Fri, 5 Oct 2007 09:08:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Ben Collins <ben.collins@ubuntu.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>
Subject: Re: regression: fireware causes oops during system
Message-ID: <20071005070817.GA8821@elf.ucw.cz>
References: <20070911190043.GA1577@elf.ucw.cz> <200709162152.24793.rjw@sisk.pl> <46ED8AD0.2040004@s5r6.in-berlin.de> <200709162216.02448.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709162216.02448.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > This commit is certainly OK, as it should merely preserve status quo.
> > Also note that Pavel wrote in his initial post that the problem became
> > apparent way after -rc1.  Full quote:
> > 
> > | I noticed empty suspend stopped working around 2.6.23-rc4, and it is
> > | still present in 2.6.23-rc6. To reproduce
> > |
> > | swapoff -a
> > | echo disk > /sys/power/state
> > | echo disk > /sys/power/state
> > |
> > | Unsetting
> > |
> > | CONFIG_IEEE1394=y
> > |
> > | solves the problem.
> 
> Yes.
> 
> I thought that there might be a later change that exposed a bug in it.
> 
> Hm.  Pavel, can you do
> 
> # echo test > /sys/power/disk
> # echo disk > /sys/power/state
> 
> and see what happens?

root@amd:~# echo test  > /sys/power/disk
root@amd:~# echo disk > /sys/power/state
root@amd:~# echo disk > /sys/power/state

Produces nothing interesting... I also did few hibernation/resume
cycles, and everything seems to work ok. But when I do swapoff then
try to hibernate, it fails on second try. Weird.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
