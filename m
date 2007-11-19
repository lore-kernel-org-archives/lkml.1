Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbXKSDFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbXKSDFB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 22:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbXKSDEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 22:04:54 -0500
Received: from netrider.rowland.org ([192.131.102.5]:3145 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753439AbXKSDEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 22:04:54 -0500
Date: Sun, 18 Nov 2007 22:04:52 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       <r.marek@assembler.cz>, <lm-sensors@lm-sensors.org>
Subject: Re: broken suspend [Was: 2.6.24-rc2-mm1]
In-Reply-To: <4740BC36.2070200@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0711182156330.22727-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Nov 2007, Jiri Slaby wrote:

> > gives coretemp_cpu_callback -> coretemp_device_remove ->
> > platform_device_unregister, so coretemp seems to be what I have and you don't.

Yes.

For the coretemp developers: coretemp_cpu_callback() needs to be more 
careful about what it does.  During a system sleep transition (suspend, 
hibernate, resume) it isn't possible to register or unregister a 
device.  Attempts to register will fail and attempts to unregister will 
block until the system sleep is over -- and for this callback that 
means hanging.

It's not clear what the best way is to fix this.  Perhaps the CPU 
notification should be sent along with a special flag indicating that 
the CPU transition is part of a system sleep (although this seems 
racy).  Perhaps the driver should notice when a system sleep begins, 
and defer all CPU-change handling until after the sleep is over.

Alan Stern

