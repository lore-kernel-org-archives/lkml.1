Return-Path: <linux-kernel-owner+w=401wt.eu-S1758462AbXL3XMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbXL3XMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 18:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbXL3XML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 18:12:11 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:53008 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965AbXL3XMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 18:12:09 -0500
Date: Sun, 30 Dec 2007 17:10:38 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: RAID timeout parameter accessibility request
In-reply-to: <fa.nf+P3+JC0dd6/v0bUA0T+jgXpts@ifi.uio.no>
To: Jose de la Mancha <hidalgoj@free.fr>
Cc: linux-kernel@vger.kernel.org
Message-id: <4778256E.5000309@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.nf+P3+JC0dd6/v0bUA0T+jgXpts@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jose de la Mancha wrote:
> Hi everyone. I'm sorry but I'm not currently subscribed to this list (I've
> been sent here by the listmaster), so please CC me all your
> answers/comments. Thanks in advance.
> 
> SHORT QUESTION :
> In a Debian-controlled RAID array, is there a parameter that handles the
> timeout before a non-responding drive is dropped from the array ? Can this
> timeout become user-adjustable in a future build ?
> 
> EXPLANATIONS :
> As you might know, if you install and use a "desktop edition" hard drive in
> a RAID array, the drive may not work correctly. This is caused by the normal
> error recovery procedure that a desktop edition hard drive uses : when an
> error is found on a desktop edition hard drive, the drive will enter into a
> deep recovery cycle to attempt to repair the error, recover the data from
> the problematic area, and then reallocate a dedicated area to replace the
> problematic area. This process can take up to 120 seconds depending on the
> severity of the issue.
> 
> The problem is that most RAID controllers allow a very short amount of time
> (7-15 seconds) for a hard drive to recover from an error. If a hard drive
> takes too long to complete this process, the drive will be dropped from the
> RAID array !

This always seemed a strange use case to me. If the drive is getting 
read errors, either it's dying and needs to be replaced, or it has a 
sporadic bad sector as a result of a power failure during write, etc. in 
which case the drive should be resynchronized. In either case the drive 
should be dropped from the array and require manual intervention. It 
doesn't seem logical to me to just read the data from another drive and 
carry on in our merry way without any warning.

> 
> Of course there are "RAID edition" hard drives with a feature called TLER
> (Time Limited Error Recovery) which stops the hard drive from entering into
> a deep recovery cycle. The hard drive will only spend 7 seconds to attempt
> to recover. This means that the hard drive will not be dropped from a RAID
> array. But these "special" hard drives are way too expensive IMHO just for a
> small firmware-based feature.
> 
> There would be an easy way to allow users to use "ordinary" hard drives in a
> Debian software-controlled RAID array. So here's my request : I suppose
> there is a parameter that handles the default timeout before a drive is
> dropped from the RAID array. I don't know if this parameter is hardcoded,
> but it would be nice if it was user-adjustable. This way, we could simply
> set up this parameter to 120 seconds or more (instead of 7-15) and we
> wouldn't have any more problems with using desktop "edition hard" drives in
> a RAID array.
> 
> What do you think ? Can it be done in a future build ?
> 
> I really hope that you'll be able to help, because I guess a lot of people
> can be concerned by this issue.
> 
> Many thanks in advance & Best regards.

I don't know the md internals very well, but I wouldn't imagine there's 
a timeout in its code, the timeout would be based on the block layer and 
driver timeouts for the consitituent devices. For libata disks, the 
timeout is normally 30 seconds. After that expires, the disk will get a 
soft or hard reset and the command is typically retried by the block 
layer. If all retries fail the upper layers will get a failure report, 
and I believe at that point the md layer decides to disable the device.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

