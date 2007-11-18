Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbXKRWKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbXKRWKu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 17:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbXKRWKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 17:10:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35932 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbXKRWKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 17:10:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: broken suspend [Was: 2.6.24-rc2-mm1]
Date: Sun, 18 Nov 2007 23:27:59 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0711181203220.5712-100000@netrider.rowland.org> <47408DFF.9070701@gmail.com>
In-Reply-To: <47408DFF.9070701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711182328.00570.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 18 of November 2007, Jiri Slaby wrote:
> On 11/18/2007 06:07 PM, Alan Stern wrote:
> > You'll get more useful results if you redo your changes to 
> > notifier_call_chain().  Have it print out the address of the routine 
> > _before_ making the call, and don't limit it to 20.  That way you'll 
> > know exactly which notifier routine ends up hanging.
> 
> The problem is, that notifier_call_chain is called again and again zillion times
> by somebody else...

You can use a global variable to switch the logging only before the CPU
hotunplug done by the suspend code.  You just need to hack
disable_nonboot_cpus() for that.
