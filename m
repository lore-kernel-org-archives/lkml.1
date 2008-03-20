Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbYCTXCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbYCTXCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 19:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYCTXB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:01:58 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4512 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753069AbYCTXB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:01:57 -0400
Date: Thu, 20 Mar 2008 19:01:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pavel Machek <pavel@ucw.cz>, "Eric W. Biederman" <ebiederm@xmission.com>,
       <nigel@nigel.suspend2.net>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-pm@lists.linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
In-Reply-To: <200803202345.25083.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803201858030.8453-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008, Rafael J. Wysocki wrote:

> > > >> Well, I've been saying that for I-don't-remember-how-long: on my box, if you
> > > >> use S5 instead of entering S4, the fan doesn't work correctly after the
> > > >> resume.  Plain and simple.
> > > >> 
> > > >> Perhaps there's a problem with our ACPI drivers that causes this to happen,
> > > >> but I have no idea what that can be at the moment.
> > > >
> > > > IMO it would be worthwhile to track this down.  It's a clear indication 
> > > > that something is wrong somewhere.
> > > >
> > > > Could it be connected with the way the boot kernel hands control over
> > > > to the image kernel?  Presumably ACPI isn't prepared to deal with that
> > > > sort of thing during a boot from S5.  It would have to be fooled into
> > > > thinking the two kernels were one and the same.
> > > 
> > > It should be easy to test if it is a hand over problem, by turning off
> > > the laptop by placing it in S5 (shutdown -h now) and then booting same
> > > kernel again.
> > 
> > Feel free to help with testing.
> > 
> > I believe ACPI is simply getting confused by us overwriting memory
> > with that from old image. I don't see how you can emulate it with
> > shutdown.
> 
> Well, in fact ACPI has something called the NVS memory, which we're supposed
> to restore during the resume and which we're not doing.  The problem may be
> related to this.

No, it can't be.  ACPI won't expect the NVS memory to be restored 
following an S5-shutdown.  In fact, as far as ACPI is concerned, 
resuming from an S5-type hibernation should not be considered a resume 
at all but just an ordinary reboot.  All ACPI-related memory areas 
in the boot kernel should be passed directly through to the image 
kernel.

Alan Stern

