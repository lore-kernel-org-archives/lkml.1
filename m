Return-Path: <linux-kernel-owner+w=401wt.eu-S1764806AbYBULEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764806AbYBULEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 06:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758505AbYBULEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 06:04:41 -0500
Received: from static.88-198-202-190.clients.your-server.de ([88.198.202.190]:52008
	"EHLO kleinhenz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758441AbYBULEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 06:04:40 -0500
X-Greylist: delayed 1888 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2008 06:04:40 EST
Message-ID: <47BD5360.5070706@debian.org>
Date: Thu, 21 Feb 2008 11:33:04 +0100
From: Simon Richter <sjr@debian.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
Cc: Gregory Nietsky <gregory@networksentry.co.za>,
       Jeff Garzik <jeff@garzik.org>, kkeil@suse.de, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       isdn4linux@listserv.isdn4linux.de, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
References: <098123kjff90231nv098233rnvd908u234@garzik.org>	<20080217195235.GN14588@uranus.ravnborg.org>	<20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de>	<20080219085033.GA1775@uranus.ravnborg.org>	<47BAA072.9050601@networksentry.co.za> <47BC370F.3000705@imap.cc>
In-Reply-To: <47BC370F.3000705@imap.cc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Tilman Schmidt wrote:

> mISDN has two problems, which are of course interrelated:

mISDN has one problem that is even bigger than these: the kernel oopses 
if modules aren't loaded in the right order. misdn-init works around 
that, but if it doesn't work for some reason (and I can think of 
multiple here), the user is left with a kernel that oopses during 
hardware discovery and never gets to a stage where this can be 
rectified, as almost all distributions now have hardware discovery 
before the first opportunity to get a shell. At least these were my 
experiences the last time I tried it on my test box.

This is the reason I've kept mISDN out of the last two Debian stable 
releases, despite users' requests.

When a hardware driver module is loaded, it should only do basic 
hardware initialisation; it is certainly not necessary to set up the 
entire stack (or even decide on a protocol, which currently needs to be 
handed in via module parameter -- before userland code is there that 
wants to talk to the hardware, there is no reason to have the hardware 
active).

    Simon
