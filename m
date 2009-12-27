Return-Path: <linux-kernel-owner+w=401wt.eu-S1752426AbZL0OTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbZL0OTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 09:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbZL0OTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 09:19:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59827 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbZL0OTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 09:19:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [linux-pm] [RFC] Asynchronous suspend/resume - test results
Date: Sun, 27 Dec 2009 15:20:08 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Jiri Slaby <jslaby@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200912210140.19713.rjw@sisk.pl> <200912262233.45626.rjw@sisk.pl> <4B36882D.5070002@crca.org.au>
In-Reply-To: <4B36882D.5070002@crca.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912271520.08521.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 December 2009, Nigel Cunningham wrote:
> Hi.
> 
> Rafael J. Wysocki wrote:
> > Yes, it did.  Please compare these lines:
> > 
> > (from the "sync" dmesg):
> > [   31.640676] PM: freeze of devices complete after 709.277 msecs
> > [   37.087548] PM: restore of devices complete after 4973.508 msecs
> > 
> > (from the "async" dmesg):
> > [   25.600067] PM: freeze of devices complete after 620.429 msecs
> > [   29.195366] PM: restore of devices complete after 3057.982 msecs
> > 
> > So clearly, there's a difference. :-)
> 
> Oh okay.
> 
> It still feels like a long time. How do I find out which device took the
> longest? It looks to me like the patch is only recording when things
> start their restore, not when they finish.

First, you need to boot with initcall_debug in the kernel command line.

Then, after a hibernate-resume cycle do something like this:

$ dmesg | grep "call .* returned " | awk '{print $8 "\t" $4;}' | sort -nr

That will give you both the suspend and resume times for all devices,
sorted in the decreasing order.

If you want to separate suspend times from resume times, you generally need
to save the dmesg output and cut everything except for the interesting part
(eg. device suspend) from it.  Then you'll get the times by running the above
command.
 
> > Of course, in terms of total hibernate/restore time this is only a little
> > improvement, but if that was suspend to RAM and resume, the reduction of
> > the device resume time by almost 2 s would be a big deal.
> > 
> >> I'll see if I can find the time to do the other computers, then.
> > 
> > I'd appreciate that very much.
> 
> I'm not sure I'll find the time now - it's Sunday morning here and we
> still have packing and so on to do after I take this morning's service.
> 
> Sorry!

No problem at all. :-)

Rafael
