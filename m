Return-Path: <linux-kernel-owner+w=401wt.eu-S1760308AbXE0VuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760308AbXE0VuS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 17:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759359AbXE0VuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 17:50:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54836 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756738AbXE0VuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 17:50:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Date: Sun, 27 May 2007 23:55:19 +0200
User-Agent: KMail/1.9.5
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
References: <200705272229.21263.rjw@sisk.pl> <200705272231.54535.rjw@sisk.pl> <6BD5252F-96CD-49D9-86C7-18115294D913@cam.ac.uk>
In-Reply-To: <6BD5252F-96CD-49D9-86C7-18115294D913@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705272355.20840.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 27 May 2007 22:45, Michael-Luke Jones wrote:
> On 27 May 2007, at 21:31, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Use a hibernation and suspend notifier to disable the firmware  
> > requesting
> > mechanism before a hibernation/suspend and enable it after the  
> > operation.
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> >
> >  drivers/base/firmware_class.c |   36 ++++++++++++++++++++++++++++++ 
> > ++++++
> >  1 file changed, 36 insertions(+)
> 
> I don't like this approach, as I feel that the firmware loading  
> interface should be able to detect if a firmware load request is not  
> being handled, due to absence of userspace / hotplug handler presence.

In principle, I agree.  In practice, though, I don't know how to make this
happen.

> Other circumstances in which this can be a problem is during bootup  
> when request_firmware() calls can be made before userspace is up and  
> init has run (even in the presence of an initramfs).
> 
> (Slightly OT: A particularly nasty race is when an initramfs  
> userspace is present, but firmware loading cannot occur because init  
> has not run, so proc hasn't been mounted, so a hotplug event handler  
> cannot be registered, despite the fact that the firmware is sitting  
> on the ramdisk mounted correctly...)
> 
> In short, a more general solution would be preferred, and preferably  
> one which allows firmware loading to *actually* occur once userspace  
> has actually turned up and registered a handler :)

I agree, but well ... ;-)

Greetings,
Rafael
