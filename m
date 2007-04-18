Return-Path: <linux-kernel-owner+w=401wt.eu-S2992978AbXDRXZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992978AbXDRXZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 19:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992984AbXDRXZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 19:25:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992978AbXDRXZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 19:25:31 -0400
Message-ID: <4626A8E6.9010502@redhat.com>
Date: Wed, 18 Apr 2007 19:25:26 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Tejun Heo <htejun@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Lord <liml@rtr.ca>
Subject: Re: Loud "pop" coming from hard drive on reboot
References: <fa.nTNVZ3bPe8773+gVV7CvcwBT5zY@ifi.uio.no> <fa.r8VLu18GDND9EByYV/EX2mH9V88@ifi.uio.no> <fa.30Zxf5IYhdVc+I5v0caKmHH3HmE@ifi.uio.no> <fa.EFm9zBLufsOlxdviaZmnBDcbYgY@ifi.uio.no> <fa.TBFIUvjBaGbwUHy5JUiGJpvOeMI@ifi.uio.no> <fa.jDn5j5GVDwXXnVYH74vVT3m+Gq8@ifi.uio.no> <4626A303.80208@shaw.ca>
In-Reply-To: <4626A303.80208@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Tejun Heo wrote:
>> This really isn't a regression.  It's been always like that with libata.
>>  libata doesn't make devices go into standby mode and shutdown(8) does
>> it for libata.  The problem here is that libata does issue
>> SYNCHRONIZE_CACHE on shutdown.  So, the sequence of event is...
>>
>> 1. shutdown(8) issues SYNCHRONIZE_CACHE followed by STANDBY_NOW
> 
> This part is presumably distribution dependent. I have never seen Fedora
> or CentOS shut down drives on power down from the shutdown script/utility..
> 

Some distro shutdown scripts must be doing "halt -h" at shutdown time.

-n : don't sync cache (default is to sync)
-h : put harddrives in standby (default is no standby)

And BTW not put them in sleep instead of standby (whether it's
the halt program or the kernel?) They won't wake up from that
until they're reset.

