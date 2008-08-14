Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbYHNPrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbYHNPrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 11:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbYHNPrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 11:47:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55459 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751373AbYHNPrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 11:47:03 -0400
Date: Thu, 14 Aug 2008 11:47:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Pavel Machek <pavel@suse.cz>, <linux-pm@lists.linux-foundation.org>,
       <James.Bottomley@hansenpartnership.com>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, <teheo@novell.com>
Subject: Re: [linux-pm] Power management for SCSI
In-Reply-To: <200808141608.13431.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.0808141141570.2846-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008, Oliver Neukum wrote:

> > > You could even argue that these storage devices violate the USB spec.
> > 
> > Hmm... but suspended devices have very little power budget, right?
> > 
> > So unless you have external power supply (2.5" frames generally
> > don't), you can't really suspend and stay spinned up...
> > 
> 
> True, but the spec says that no state shall be lost.

What can we do?...  Real world devices don't always obey the spec.

You could argue that the suspend current should be sufficient to 
maintain the contents of the cache, which would then be written out 
after resume.  But even if that is true, it's a very fragile guarantee 
to rely on.

> I don't really argue against flushing the caches. But I cannot that this would
> demand that we should implement autopsuspend for SCSI. It seems like
> overengineering to me.

Think of it in two parts: idle-timeout detection and autosuspend.  
Presumably you don't object to the idle-timeout detection (which is 
needed for powering down links in general), and you don't argue against 
the cache-flushing part of autosuspend.  Taken together, that's about 
90% of my proposal.  So what is the objectionable 10%?

Alan Stern

