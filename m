Return-Path: <linux-kernel-owner+w=401wt.eu-S932912AbXBKXHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912AbXBKXHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 18:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932915AbXBKXHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 18:07:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39317 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932912AbXBKXHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 18:07:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: NAK new drivers without proper power management?
Date: Mon, 12 Feb 2007 00:04:14 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@infradead.org>,
       nigel@nigel.suspend2.net, LKML <linux-kernel@vger.kernel.org>
References: <1171058269.1484.64.camel@nigel.suspend2.net> <20070211194202.GC15445@elf.ucw.cz> <20070211210258.0b8da53c@localhost.localdomain>
In-Reply-To: <20070211210258.0b8da53c@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702120004.15529.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 11 February 2007 22:02, Alan wrote:
> > > "If the device requires that, implement .suspend and .resume or at least
> > > define .suspend that will always return -ENOSYS (then people will know they
> > > have to unload the driver before the suspend).  Similarly, if you aren't sure
> > > whether or not the device requires .suspend and .resume, define .suspend that
> > > will always return -ENOSYS."
> > 
> > Sounds ok to me. Where should this text go?
> > Documentation/SubmittingDrivers ?
> 
> And testing/submitting drivers, perhaps with additional text in that to
> make it clear we want suspend/resume support or good excuses
> 
> "Please verify your driver correctly handles suspend and resume. If it
> does not your patch submission is likely to be suspended and only resume
> when the driver correctly handles this feature"

I have prepared a patch against Documentation/SubmittingDrivers.  Please
have a look.

---
 Documentation/SubmittingDrivers |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: linux-2.6.20-git4/Documentation/SubmittingDrivers
===================================================================
--- linux-2.6.20-git4.orig/Documentation/SubmittingDrivers
+++ linux-2.6.20-git4/Documentation/SubmittingDrivers
@@ -87,6 +87,18 @@ Clarity:	It helps if anyone can see how 
 		driver that intentionally obfuscates how the hardware works
 		it will go in the bitbucket.
 
+PM support:	Since Linux is used on many portable and desktop systems, your
+		driver is likely to be used on such a system and therefore it
+		should support basic power management by implementing, if
+		necessary, the .suspend and .resume methods used during the
+		system-wide suspend and resume transitions.  You should verify
+		that your driver correctly handles the suspend and resume, but
+		if you are unable to ensure that, please at least define the
+		.suspend method returning the -ENOSYS ("Function not
+		implemented") error.  Note, however, that in such a case your
+		submission is likely to be suspended and only resumed when the
+		driver correctly handles this feature.
+
 Control:	In general if there is active maintainance of a driver by
 		the author then patches will be redirected to them unless
 		they are totally obvious and without need of checking.
