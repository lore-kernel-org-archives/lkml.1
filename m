Return-Path: <linux-kernel-owner+w=401wt.eu-S1422704AbXCBBdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422704AbXCBBdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 20:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422703AbXCBBdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 20:33:21 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:46436 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422692AbXCBBdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 20:33:20 -0500
Message-ID: <45E77EDD.3010205@garzik.org>
Date: Thu, 01 Mar 2007 20:33:17 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alan <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] libata: Cable detection fixes
References: <20070301173003.5d5ab4a6@lxorguk.ukuu.org.uk> <Pine.LNX.4.64.0703011723270.12485@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703011723270.12485@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 1 Mar 2007, Alan wrote:
>> The patch switches the identify order so that we can do the drive side
>> detection correctly. 
>>
>> Secondly we add a ->cable_detect() method called after the identify
>> sequence which allows a host to do host side detection at this point
>> should it wish, or to modify the results of the drive side identify.
> 
> Alan, sign-offs?
> 
> Jeff, should I just expect to get these things through you?

See my reply, which passed yours in-flight :)

I'm OK with all the changes, but ->cable_detect (and _nice_ cleanups) 
does not seem like 2.6.21-rc bugfix material to me.

We definitely want the IDENTIFY ordering changes, though we'll also want 
that passed through at least one more 2.6.21-rcX release before 
confidence appears.

That little change, buried in the middle of Alan's patch, changes the 
probing order for a /lot/ of devices, possibly millions, when you 
consider that it changes behavior of ata_piix (Intel SATA) as well as 
all the not-yet-default PATA controllers.

A wanted fix, but something that definitely wants a lot of public 
testing before 2.6.21 release.

	Jeff



