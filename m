Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbYLFXZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbYLFXZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 18:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYLFXZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 18:25:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:60350 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbYLFXZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 18:25:02 -0500
Date: Sat, 6 Dec 2008 15:25:45 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Takashi Iwai <tiwai@suse.de>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/3] PCI: Rework default handling of suspend
 and resume
Message-ID: <20081206152545.326c8b67@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0812061420190.3425@nehalem.linux-foundation.org>
References: <Pine.LNX.4.44L0.0812061324260.13426-100000@netrider.rowland.org>
	<200812062236.44111.rjw@sisk.pl>
	<alpine.LFD.2.00.0812061420190.3425@nehalem.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Dec 2008 14:24:55 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> > 
> > However, I'm not quite sure about the freeing and requesting IRQs
> > during suspend and resume.  Many drivers do that, many others
> > don't.  Still, apparently some drivers don't work correctly after
> > resume if this is not done. So, if that should generally be done, I
> > also think that moving it to the core might be a good idea.
> 
> I'd suggest against it.
> 
> A lot of drivers that want to disable (or unregister) interrupts
> almost certainly want to do it simply because they are not ready and
> willing to handle any interrupts after having run their "suspend()"
> function. 

the problem is that the system bios can have reassigned interrupts
after resume, and afaik we need to re-evaluate the ACPI methods to
get the new mapping.
So we need to unregister + re-register to make that happen
