Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbXFKUnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbXFKUnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 16:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbXFKUmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 16:42:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:28153 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbXFKUmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 16:42:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=IkQlI/5luaBIRM6Gb5tZXfNQJE37fPu0K2V3lzg3mRFcKExITgsRWTcVnoqvocqjB18VSZsIs8geS7PTYOL4+QhfLN6bQAxI6SeI+NZpk6dan8cEkSsIkvVtYT+AUSvfR5V16o0bg09f+VLiwg6AgzNp1yCDZwU0DTqQIsQmjws=
Message-ID: <466DCFD4.9080702@gmail.com>
Date: Tue, 12 Jun 2007 00:42:28 +0200
From: Robert de Rooy <robert.de.rooy@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Jiri Kosina <jikos@jikos.cz>, Greg KH <greg@kroah.com>,
       Joel.Becker@oracle.com,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] ThinkPad T41 - Strange USB 2.0 behaviour
References: <Pine.LNX.4.44L0.0706101129070.29131-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0706101129070.29131-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> Okay.  It's clear that you've got a hardware problem of some sort.  
> Hard to say what it is, but evidently the EHCI controller thinks that 
> the device is repeatedly being unplugged and replugged.
>
> Anyway, this isn't a problem of recognizing that a single device is
> having problems.  In fact the computer has no way of knowing that a
> single device is involved; all it knows is that _something_ gets
> plugged into the port and then removed.  There's no way to tell if it's 
> the same _something_ from one iteration to the next.
>
> You can manually force the port to run at full speed instead of high 
> speed as follows:
>
> 	echo '4' >/sys/class/usb_host/usb_host4/companion
>
> The "companion" attribute file contains a list of ports which are 
> permanently set to be handled by the EHCI's companion controller.  To 
> return to high-speed operation, use '-4' instead of '4' above.  This 
> might or might not solve your problem -- the hardware bug might cause 
> the port to return automatically to high-speed regardless.
>
> Let me know what happens.
>
> Alan Stern

Yes that works.
I tried to plug and unplug the device repeatedly and each time it came 
up in full-speed mode.

