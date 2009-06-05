Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbZFEPH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbZFEPH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 11:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbZFEPHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 11:07:21 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:38216 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbZFEPHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 11:07:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iAZsBXXH+H/WW/Q0+QdLC4zXy8rODieugMkBpEkQe5Xa+4sEk9qLgprqVpkjULebdm
         lLp6HFZKHi3lkbeLhuhPaJWRJMPl9j65/L/JKA+RS5Bgyf2ZiQ+QcdbR1pcNRMPe6k0l
         kC2qwjSybGO9fkVJabOSFaf8RMR+7Dq+YmsFo=
Message-ID: <4A2934F5.4050601@tuffmail.co.uk>
Date: Fri, 05 Jun 2009 16:08:37 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Corentin Chary <corentin.chary@gmail.com>,
       acpi4asus-user@lists.sourceforge.net, len.brown@intel.com,
       linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
References: <Pine.LNX.4.64.0906051157460.22218@melkki.cs.Helsinki.FI>	 <71cd59b00906050446g7310d24el94f0d137dc0e0ecf@mail.gmail.com>	 <1244205844.23533.21.camel@penberg-laptop>	 <71cd59b00906050602s5c9b9a31ne11b6aaf7546f58c@mail.gmail.com>	 <1244209873.23533.29.camel@penberg-laptop>	 <9b2b86520906050738kea062c9n1b2c0e767d6eb0aa@mail.gmail.com> <1244213412.23533.41.camel@penberg-laptop> <4A2931F5.1090709@tuffmail.co.uk>
In-Reply-To: <4A2931F5.1090709@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Pekka Enberg wrote:
>> Hi Alan,
>>
>> On Fri, 2009-06-05 at 15:38 +0100, Alan Jenkins wrote:
>>  
>>> Ok.  I didn't bother shutting down my system, but I get a similar
>>> difference; 16 wakeups/s disabled v.s. 25 enabled.  Anecdotally,
>>> disabling the camera does help battery life, and presumably Asus had
>>> good reason to implement it!  (The shipped OS "fixes" the usability
>>> problem by patching the camera apps).
>>>
>>> BUT I found that autosuspend didn't seem to break anything, and
>>> enabling it also got me down to 16 wakeups/s.  I think this is ideal
>>> because autosuspend is automatic so I can save power without manual
>>> toggling.
>>>
>>> Here's some magic to enable autosuspend:
>>>
>>> # echo -n auto > /sys/bus/usb/drivers/uvcvideo/*:*/../power/level
>>>
>>> Ideally this wants to be enabled automatically using a udev rule.
>>>     
>>
>> Can the kernel do this by default for this specific driver on eeepc?
>>
>>             Pekka
>>
>>   
>
> Auto-suspend white-listing would be done on the basis of USB ids 
> (vendor, product).  At the moment it's expected that userspace should 
> take ownership of it.  There's no infrastructure for in-kernel 
> whitelisting.  I think.
>
> Large lists in udev rules can work, there are already lists of USB 
> devices to set permissions for libusb access, e.g. for libmtp.
>
> [CC usb list - in the hope someone will point out if I got this wrong 
> :-)]
>
> Alan

Btw I've now tested the udev rule, you can just dump this in a new 
.rules file under /etc/udev/rules.d:

SUBSYSTEM=="usb", ATTR{idVendor}=="eb1a", ATTR{idProduct}=="2761", ATTR{power/level}="auto"


Not sure who I should submit it to though :-).  debian-eeepc would take 
it, but perhaps it should go in udev's default rules.

Regards
Alan
