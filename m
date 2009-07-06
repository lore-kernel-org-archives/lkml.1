Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbZGFU7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbZGFU7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 16:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZGFU66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 16:58:58 -0400
Received: from mail2.shareable.org ([80.68.89.115]:42701 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbZGFU65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 16:58:57 -0400
Date: Mon, 6 Jul 2009 21:58:44 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: tridge@samba.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090706205844.GE13638@shareable.org>
References: <alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr> <19021.26102.80885.330380@samba.org> <alpine.LSU.2.00.0907030403330.26905@fbirervta.pbzchgretzou.qr> <19021.31291.642416.956966@samba.org> <alpine.LSU.2.00.0907031121250.16093@fbirervta.pbzchgretzou.qr> <19021.63615.450348.192109@samba.org> <alpine.LSU.2.00.0907061337550.9199@fbirervta.pbzchgretzou.qr> <19025.63119.656216.431469@samba.org> <alpine.LSU.2.00.0907061932120.20434@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> 
> On Monday 2009-07-06 20:55, Jan Engelhardt wrote:
> >>How did things go with your mp3 players?
> >[...]
> >As it stands, my two devices always want a valid 8.3 name.
> 
> On or about June 26, James Bottomley exchanged these words to Andrew Tridgell:
> >So the patch has been tested with Vista, Windows 7 and Windows XP
> 
> 
> Vista, 7... nothing special.
> 
> So let me fill in.
> 
> Windows 98 can't make anything of the stunted vfat entries either[3],
> and there's blanks for 16-bit programs[4]. They too, it seems, always
> want an 8.3 entry in any case.
> It does not crash, but neither of these results is usable.
>
> This dualnames patch just won't fly in practice.
> 
> 
> [3] http://picpaste.de/w98dualnames.png
> [4] http://picpaste.de/xpwith16bit.png
> (pics kept for 7 days from now)

Summary of pics, for posterity:

[3] shows an MS-DOS window on a Windows 98 desktop, listing the A:
    drive:

      Microsoft(R) Windows 98
         (C)Copyright Microsoft Corp 1981-1998.

      A:\>Dir

       Datantrager in Laufwerk A: hat keine Bezeichnung
       Seriennummer des Datentragers: 4A52-570A
       Verzeichnis von A:\

      SHORT    TXT            12  06.07.09  21:57 SHORT.TXT
                              12  06.07.09  21:57 
                              12  06.07.09  21:57 
               3 Datai(en)                    36 Bytes
               0 Verzeichnis(se)       1.456.128 Bytes frei

      A:\>

Question: In Windows 98, is it just the MS-DOS box which cannot see
some of the filenames, or is the normal file explorer affected too?

[4] shows a old-looking Windows application, presumably 16-bit running
    on XP, with a File Selection box listing the a:\ drive.  Four
    files are shown on the a:\ drive in a selection box, but the first
    of them is completely blank.

In Windows XP, it suggests to me that the Windows API function
GetShortPathName() returns the 8.3 file name entry.  Call it an
educated guess, and I'll guess the same applies in Server 2003, Vista,
Server 2008 and Windows 7.

All those Windows versions also have GetLongPathName() which does the
reverse transformation.  Presumably that also expects the 8.3 entry to
exist.

The fact these were added in Windows 2000 implies they're not an
ancient thing from the Windows 95 era, but specifically used by
applications since Windows 2000.

-- Jamie
