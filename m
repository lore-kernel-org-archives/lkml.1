Return-Path: <linux-kernel-owner+w=401wt.eu-S1756981AbZGBXRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbZGBXRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 19:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbZGBXRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 19:17:36 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:51112 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZGBXRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 19:17:36 -0400
Date: Fri, 3 Jul 2009 01:17:38 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Theodore Tso <tytso@mit.edu>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Rusty Russell <rusty@rustcorp.com.au>,
       Pavel Machek <pavel@ucw.cz>, tridge@samba.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regression
In-Reply-To: <20090701140503.GA21185@mit.edu>
Message-ID: <alpine.LSU.2.00.0907030056210.17183@fbirervta.pbzchgretzou.qr>
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz> <200907012019.53932.rusty@rustcorp.com.au> <20090701122558.3a7c80d3@lxorguk.ukuu.org.uk> <20090701140503.GA21185@mit.edu>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2009-07-01 16:05, Theodore Tso wrote:
>On Wed, Jul 01, 2009 at 12:25:58PM +0100, Alan Cox wrote:
>
>> (most *FAT using products don't use Microsofts
>> implementation). Testing it versus Windows and saying it works is
>> not really adequate. Thats what ACPI and BIOS people do that *we*
>> moan about all the time.
>
>[...]
>The other big user I can think of are digital cameras, but (a)
>normally most users read from them and then delete the pictures, and
>rarely write to media meant for a digital camera, and (b) the DCIM
>standard for digital cameras explicitly only supports 8.3 filenames
>and so digital camera manufacturers explicitly don't need to deal with
>Long File Names at all.  (Hmm.... I wonder why....)
>[...]
>Ultimately, though, requiring that every single possible device be
>tested is probably not reasonable, so the best way to do this testing
>is the way do most of our testing; we do basic due diligence, but then
>we merge it into mainline and let our huge user community try it out.


Yes, here is your precedent case. The DUALNAMES patch breaks the
operation on my Fujifilm Finepix A210 digital camera.

Here, dscf4159.jpg is a preexisting file created by the camera itself 
(and subsequently, Finepix's FAT code) as a result of taking a picture. 
Then I just copied that file with two different kernels in succession.

 * 2.6.31-rc1 + dualnames=n
   # mount /dev/sdc1 /mnt
   # cd /mnt/dcim/100_fuji/; cp dscf4159.jpg dscf3000.jpg
   # umount /mnt

 * 2.6.29.5 w/o patch
   # same procedure
   cp dscf4159.jpg dscf3001.jpg

End result is that picture ID 3000 is not selectable in the camera's
built-in menu (OSD), as if the file did not exist. 3001 was shown,
however.
