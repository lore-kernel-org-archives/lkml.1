Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbYABVaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbYABVaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbYABVaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:30:05 -0500
Received: from home.nigel.suspend2.net ([203.171.70.205]:56481 "EHLO
	server1.example.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752822AbYABVaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:30:03 -0500
Message-ID: <477C0258.8080609@nigel.suspend2.net>
Date: Thu, 03 Jan 2008 08:30:00 +1100
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Kyle Moffett <mrmacman_g4@mac.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: freeze vs freezer
References: <4744FD87.7010301@goop.org> <200711262253.35420.rjw@sisk.pl> <20071127053846.GA28884@srcf.ucam.org> <200711271840.24825.rjw@sisk.pl> <8B00F353-983F-40E7-931B-EA73CCD32F0A@mac.com> <20080102160234.GA17070@ucw.cz>
In-Reply-To: <20080102160234.GA17070@ucw.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Pavel Machek wrote:
> Hi!
> 
>>>>>> So how do you handle threads that are blocked on I/O or a lock  
>>>>>> during the system freeze process, then?
>>>>> We wait until they can continue.
>>>> So if I have a process blocked on an unavilable NFS mount, I can't
>>>> suspend?
>>> That's correct, you can't.
>>>
>>> [And I know what you're going to say. ;-)]
>> Why exactly does suspend/hibernation depend on "TASK_INTERRUPTIBLE"  
>> instead of a zero preempt_count()?  Really what we should do is just  
>> iterate over all of the actual physical devices and tell each one  
>> "Block new IO requests preemptably, finish pending DMA, put the  
>> hardware in low-power mode, and prepare for suspend/hibernate".  As  
>> long as each driver knows how to do those simple things we can have  
>> an entirely consistent kernel image for both suspend and for  
>> hibernation.
> 
> "each driver" means this is a lot of work. But yes, that is probably
> way to go, and patch would be welcome.

Yes, that does work. It's what I've done in my (preliminary) support for
fuse.

Regards,

Nigel

