Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbZCaNXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbZCaNXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758549AbZCaNXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:23:36 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:52141 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758178AbZCaNXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:23:35 -0400
X-Greylist: delayed 1545 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Mar 2009 09:23:34 EDT
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Mark Williamson <mark.williamson@cl.cam.ac.uk>
To: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Replacing VFAT as filesystem on removeable media
Date: Tue, 31 Mar 2009 13:57:43 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, info@fsf.org,
       office@fsfeurope.org, info@linuxfoundation.org
References: <200903311015.29222.Martin@Lichtvoll.de>
In-Reply-To: <200903311015.29222.Martin@Lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903311357.44075.mark.williamson@cl.cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another approach which occurs to me would be to come up with a "filesystem over 
USB" protocol so that the actual on-disk format is no longer relevant.  With a 
standard or reasonably common FSoUSB implementation, a device maker could 
choose a disk filesystem that's appropriate to their purpose and hide the 
implementation details within the device.  For instance, an MP3 player could 
use a flash-specific disk filesystem but would be able hide the details of this 
from the host PC.

This might not be so desirable for simple devices (like USB card readers, 
perhaps) but I imagine it would fairly straightforward on media players, 
GPSes, etc that run a "proper" OS.  The most pain would arguably be in 
*somebody* having to write a filesystem driver for Windows but at least it 
would only need writing once ;-)

I've seen some talk of this sort of approach online but nothing too specific.  
A Linux USB website suggested that a certain camera protocol might be suitable 
as a basis for files-over-USB (there's even a FUSE module for this, I think).  
Another possibility that occurs would be to write a USB transport for 9P, 
which looked like it might be fairly straightforward...

Just a thought, anyhow.

Cheers,
Mark

On Tuesday 31 March 2009 09:15:28 Martin Steigerwald wrote:
> Hi!
>
> Now as TomTom appears to have surrendered to Microsoft and Microsoft seems
> to have accepted this deal probably in order to not find out that their
> patents are void, I think replacing VFAT as standard cross platform
> filesystem on removeable media would be an even better idea than before
> [1].
>
> Granted I believe the patents will be made void one day, but even then I
> think it would make sense to replace VFAT for technical reasons.
>
> Such a filesystem IMHO should have the following features:
> - cross platform with implementations for Linux, Windows, Mac OS X at
> least, also the varios BSD variantes come to my mind
> - open source
> - probably some support for flash media without or with bad wear leveling
> - some kind of journaling or other metadata consistency guarentee
>
> People use ext2 as an alternative, but that lacks journaling.
>
> I could also think of UDF with write support, but I am not sure whether
> Windows and Mac OS X has write support.
>
> Or probably even a new filesystem as long as people appear to write one
> filesystem after another these days.
>
> Or some kind of FAT *without* compatibility hacks, but I think this would
> still be an inferior solution as long as it doesn't provide for metadata
> consistency.
>
> Maybe this could become some kind of Linux Foundation or FSF joint effort?
> Together with advertising and advocacy of free software users this could
> probably really replace VFAT in the long term.
>
> What do you think? What other features would make sense to for such a
> filesystem.
>
> I am willing to test such a filesystem and help with documentation as well
> as advocacy. But for coding I better start with something easier ;-).
>
> [1]
> http://www.h-online.com/open/TomTom-Microsoft-settle-patent-dispute--/news/
>112964
>
> Ciao,

