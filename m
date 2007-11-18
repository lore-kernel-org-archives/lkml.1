Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbXKRE6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbXKRE6c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 23:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbXKRE6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 23:58:24 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:9252 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbXKRE6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 23:58:23 -0500
Date: Sat, 17 Nov 2007 22:58:10 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [REQUEST] Option for skipping unreadable blocks on Video DVD
In-reply-to: <fa.DNZjDdh1eNcFR2zDRKzQ6G2bIVU@ifi.uio.no>
To: Tobias <kaminsky@finswimmer.de>
Cc: linux-kernel@vger.kernel.org
Message-id: <473FC662.7020901@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.DNZjDdh1eNcFR2zDRKzQ6G2bIVU@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias wrote:
> If you are accessing a scratched Video DVD and the device cannot read it, the 
> process ends. 
> What about a more tolerant way to handle unreadable blocks. 
> Especially on Video DVDs single blocks are not that important than on data 
> dvds.

If the DVD player process ends from this, I'd say that's the fault of 
the player software not handling errors properly.

I think that if they are using the normal block layer accesses on the 
DVD device, there may be some retries that occur which are likely 
undesirable in this case since they will just stall playback. If they 
are using SG_IO to feed raw requests into the drive (which I imagine 
they need to do for CSS authentication, etc. anyway), then all error 
handling is passed up to the user application.

> 
> So is there a way that the kernel tells the device to skip these bad blocks?

We don't know they're bad until we try and read them. How long the drive 
will stall trying to read that sector before giving up and returning an 
error is up to the drive. I'm not sure if the MMC command set allows any 
way to tell the drive to give up more quickly or not..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

