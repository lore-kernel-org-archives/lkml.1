Return-Path: <linux-kernel-owner+w=401wt.eu-S1763533AbXHCPbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763533AbXHCPbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762764AbXHCPbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:31:12 -0400
Received: from twin.jikos.cz ([213.151.79.26]:41299 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762738AbXHCPbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:31:10 -0400
Date: Fri, 3 Aug 2007 17:29:28 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: David Brownell <david-b@pacbell.net>
cc: linux-usb-devel@lists.sourceforge.net, Dave Jones <davej@redhat.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Rogan Dawes <lists@dawes.za.net>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend
 =?iso-8859-1?q?by=09default_on_certain_device?= classes
In-Reply-To: <200708030824.41924.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.64.0708031725520.26230@twin.jikos.cz>
References: <20070803140909.GA19245@srcf.ucam.org>
 <Pine.LNX.4.64.0708031636160.26230@twin.jikos.cz> <20070803145321.GB17138@redhat.com>
 <200708030824.41924.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007, David Brownell wrote:

> And could you elaborate on "many"?  What proportion of HID devices (by 
> volume, model, etc) seem to have problems?

Last time I tried with two random USB keyboards - one from Logitech and 
one from Chicony, I don't remember the exact PIDs, but could look them up 
if it is interesting for someone.

> The specific failure I saw was that the device advertised itself as 
> supporting remote wakeup, but it couldn't issue that signaling. It came 
> back from suspend just fine ... but moving or clicking would not do what 
> it should.

What I have been seeing with both these keyboards was: if connected to 
UHCI controller, root hub not auto-suspended, as soon as they got 
autosuspended, and keys were pressed on them rapidly, very often some 
keypressess got lost. I didn't experience this on OHCI, but I remember 
Alan saying that he triggered it on OHCI too, right?

Seemed like a timing issue - by lowering the polling timeout we were able 
to make things much better, but that of course costs us more power etc. 
and it's even not sure if it is an ultimate solution.

-- 
Jiri Kosina
