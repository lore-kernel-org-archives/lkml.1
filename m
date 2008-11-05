Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbYKEAUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbYKEAUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 19:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbYKEAUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 19:20:35 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:64019 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbYKEAUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 19:20:34 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=W9pE81S-YBcOGMrujjkA:9 a=0o8zeatMWY_nwoueZUcGHgg62MEA:4 a=j0CMlSstq6wA:10 a=eNxp2uuuQYoA:10
Message-ID: <4910E6CD.9090605@mail.usask.ca>
Date: Tue, 04 Nov 2008 18:20:29 -0600
From: Robert Hancock <rwh461@mail.usask.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Pavel Machek <pavel@suse.cz>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata hibernation fixes
References: <fa.Ast7pgG6P20u1PcyOsfgzoaX5YA@ifi.uio.no> <fa.1+JQHm7yjIiZJxAzR0eBPn39a9M@ifi.uio.no> <fa.8GbzH83c2CAI53n9dyzVOFugmoc@ifi.uio.no> <fa.hGdpNHQGmXAR19JiGuHxSr9N9CA@ifi.uio.no>
In-Reply-To: <fa.hGdpNHQGmXAR19JiGuHxSr9N9CA@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 4 Nov 2008, Pavel Machek wrote:
>> (Is park command normally supported on modern disks? IIRC hdaps people
>> had issues with not all disks supporting it?)
> 
> The modern version of parking is called "idle immediate". It may be that 
> only laptop drives support the "unload" part. But it's definitely not an 
> ancient and deprecated thing (although calling it "parking" is apparently 
> old-fashioned :)

IDLE IMMEDIATE just transitions the device to the Idle state, which is 
normally parked/unloaded and spun down. Newer specs have an unload 
option, but really the only thing that does is tell the drive to do it 
immediately, even if read-ahead is in progress or there is dirty data in 
its write cache (something we definitely don't want to do if we're about 
to power down), it still spins down.

It would be interesting to check Windows using QEMU or something to 
verify what exactly it's doing. I know Windows can run into this as 
well, on my Compaq X1000 laptop a shutdown from Windows also does a 
double spin-down on the hard drive. (However I replaced the original 
Hitachi drive with a Samsung, which might have different behavior.)
