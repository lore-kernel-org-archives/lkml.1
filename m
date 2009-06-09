Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbZFIWpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbZFIWpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 18:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZFIWpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 18:45:03 -0400
Received: from cantor.suse.de ([195.135.220.2]:49456 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbZFIWpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 18:45:02 -0400
Date: Wed, 10 Jun 2009 00:44:58 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Ingo Molnar <mingo@elte.hu>
Cc: Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: Run-time PM idea (was: Re: [linux-pm] [RFC][PATCH 0/2] PM:
 Rearrange core suspend code)
In-Reply-To: <20090608142154.GD14234@elte.hu>
Message-ID: <alpine.LRH.2.00.0906100039370.31685@twin.jikos.cz>
References: <Pine.LNX.4.44L0.0906071651060.25203-100000@netrider.rowland.org> <20090608131159.GA15100@srcf.ucam.org> <20090608132235.GC13214@elte.hu> <200906081539.20459.oliver@neukum.org> <20090608142154.GD14234@elte.hu>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009, Ingo Molnar wrote:

> > For example do you really need every key pressed while the screen 
> > saver is running or is it enough for the keyboard to be able to 
> > generate a wakeup event?
> The sane default here is to suspend the keyboard, except if an audio 
> app is running that binds to the volume keys of the keyboard.
> If the 'keyboard' is properly abstracted in the kernel and the 
> kernel driver _knows_ that the volume keys are in use, this is not a 
> problem.

So, if you want to abstract this properly, you are proposing that the 
application should in some sense "bind to keyboard keys"?

That has several drawbacks:

- applications in the current universe don't do that
- it's awful overhead: 
  + it apparently wouldn't have any other use than for waking up from 
    autosuspended mode (possibly while screensaver is running)
  + I believe that application writers will find it a little boring to 
    have to start all their main() functions with explicit eunumeration of 
    the keys the application is expecting :)
- even if we require applications to do so, there will be ones violating 
  this rule (i.e. kernel only knows what userspace tells him, in this 
  situation ... is this reliable enough?)

To sum it up -- I don't think that what you are proposing will work.

Thanks,

-- 
Jiri Kosina
SUSE Labs

