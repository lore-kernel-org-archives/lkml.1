Return-Path: <linux-kernel-owner+w=401wt.eu-S1756364AbYCUAxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbYCUAxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 20:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYCUAxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 20:53:02 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4637 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752115AbYCUAxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 20:53:00 -0400
Date: Thu, 20 Mar 2008 20:52:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pavel Machek <pavel@ucw.cz>, "Eric W. Biederman" <ebiederm@xmission.com>,
       <nigel@nigel.suspend2.net>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-pm@lists.linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
In-Reply-To: <200803210040.33982.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803202049550.11234-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Rafael J. Wysocki wrote:

> > > > Well, in fact ACPI has something called the NVS memory, which we're supposed
> > > > to restore during the resume and which we're not doing.  The problem may be
> > > > related to this.
> > > 
> > > No, it can't be.  ACPI won't expect the NVS memory to be restored 
> > > following an S5-shutdown.  In fact, as far as ACPI is concerned, 
> > > resuming from an S5-type hibernation should not be considered a resume 
> > > at all but just an ordinary reboot.
> 
> I agree here.
> 
> > > All ACPI-related memory areas in the boot kernel should be passed directly
> > > through to the image kernel.
> 
> However, the image kernel is supposed to restore the NVS area (from the
> image) before executing _WAK.

It's supposed to do that when resuming from an S4 hibernation, not 
when resuming from an S5 hibernation.

> > How can we pass interpretter state? I do not think we do this kind of
> > passing.
> 
> The interpreter state is passed withing the image.  The platform state is not.

For an S5 hibernation, the interpreter state within the image is wrong.  
The image kernel needs to have the interpreter state from the boot 
kernel -- I don't know if this is possible.

Alan Stern

