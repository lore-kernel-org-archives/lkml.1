Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbYHYPE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbYHYPE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 11:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYHYPES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 11:04:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39689 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbYHYPES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 11:04:18 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Power management for SCSI
Date: Mon, 25 Aug 2008 17:05:27 +0200
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@suse.cz>, linux-pm@lists.linux-foundation.org,
       James.Bottomley@hansenpartnership.com,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, teheo@novell.com
References: <Pine.LNX.4.44L0.0808251033460.6462-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808251033460.6462-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808251705.28455.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 25 August 2008 16:45:20 schrieb Alan Stern:

> You didn't answer my question: How does the HLD know whether it's okay 
> to suspend the link without suspending the device?  I should think that 
> it _doesn't_ know.
> 
> The transport class code might know, or the link's driver -- but not
> the HLD.  The HLD probably doesn't even know what type of transport is
> being used!

There's some truth to that. Unfortunately the transport does not know
whether a device or link may be suspended. Take the case of a CD playing
sound. The transport may know what the consequences of suspending
a link will be to the devices, but only the devices know whether the
consequences are acceptable.

> > I am talking about correctness for controllers. So remote wakeup may or may not
> > be available. Likewise the bus may be able to predict how long it'll be idle.
> 
> I don't understand.  Are you saying that whether or not it's correct to
> suspend a link depends on whether the device may need to talk to the
> CPU at unpredictable times?  And if so, isn't that the same as saying

Yes.

> that remote wakeup for the link can be enabled?

Remote wakeup is a concept specific to USB. If you are writing for
a generic system the question is indeed whether devices may want
to talk to the host and whether they can.
It seems to me that the ULD will know whether its devices will need
to talk to the CPU.
 
> > That's the problem. You don't tell the children when the parent might want
> > to suspend.
> 
> Why should the children need to know?

Because they'll want to do things like flushing caches.
 
> 	If the children are already suspended then we certainly don't
> 	need to tell them the link is going down.

Yes.
 
> 	If the children are active, then the link's driver or the
> 	transport class must already have given the okay for
> 	suspending the link while leaving the children active.

Because the transport class may not know either.

	Regards
		Oliver
