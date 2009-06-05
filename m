Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbZFEO4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbZFEO4D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZFEOzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:55:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:41604 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbZFEOzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:55:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=asZJ1y7L2VsgpenY2ZeWoYLtVd2FgLbWmBkBKpVzlP4g9qjB9+moH+4HM6E6vli7Xy
         zvhumX30wSly0KXOyoUkcP/Sz8tdy6wb4MFBZY26Y75GtGCZY+4I9vJk6XjzTxLnR7G7
         u9C3A3pbLczJ6G7gLVr/7b3U+ohR8Ct1AEG+A=
Message-ID: <4A2931F5.1090709@tuffmail.co.uk>
Date: Fri, 05 Jun 2009 15:55:49 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Corentin Chary <corentin.chary@gmail.com>,
       acpi4asus-user@lists.sourceforge.net, len.brown@intel.com,
       linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
References: <Pine.LNX.4.64.0906051157460.22218@melkki.cs.Helsinki.FI>	 <71cd59b00906050446g7310d24el94f0d137dc0e0ecf@mail.gmail.com>	 <1244205844.23533.21.camel@penberg-laptop>	 <71cd59b00906050602s5c9b9a31ne11b6aaf7546f58c@mail.gmail.com>	 <1244209873.23533.29.camel@penberg-laptop>	 <9b2b86520906050738kea062c9n1b2c0e767d6eb0aa@mail.gmail.com> <1244213412.23533.41.camel@penberg-laptop>
In-Reply-To: <1244213412.23533.41.camel@penberg-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Hi Alan,
>
> On Fri, 2009-06-05 at 15:38 +0100, Alan Jenkins wrote:
>   
>> Ok.  I didn't bother shutting down my system, but I get a similar
>> difference; 16 wakeups/s disabled v.s. 25 enabled.  Anecdotally,
>> disabling the camera does help battery life, and presumably Asus had
>> good reason to implement it!  (The shipped OS "fixes" the usability
>> problem by patching the camera apps).
>>
>> BUT I found that autosuspend didn't seem to break anything, and
>> enabling it also got me down to 16 wakeups/s.  I think this is ideal
>> because autosuspend is automatic so I can save power without manual
>> toggling.
>>
>> Here's some magic to enable autosuspend:
>>
>> # echo -n auto > /sys/bus/usb/drivers/uvcvideo/*:*/../power/level
>>
>> Ideally this wants to be enabled automatically using a udev rule.
>>     
>
> Can the kernel do this by default for this specific driver on eeepc?
>
> 			Pekka
>
>   

Auto-suspend white-listing would be done on the basis of USB ids 
(vendor, product).  At the moment it's expected that userspace should 
take ownership of it.  There's no infrastructure for in-kernel 
whitelisting.  I think.

Large lists in udev rules can work, there are already lists of USB 
devices to set permissions for libusb access, e.g. for libmtp.

[CC usb list - in the hope someone will point out if I got this wrong :-)]

Alan
