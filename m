Return-Path: <linux-kernel-owner+w=401wt.eu-S1760372AbYA2Ow3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760372AbYA2Ow3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 09:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbYA2OwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 09:52:21 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:62198 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbYA2OwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 09:52:19 -0500
Date: Tue, 29 Jan 2008 09:51:53 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <20080129121201.2f727f5f@core>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Richard Heck <rgheck@bobjweil.com>,
       Daniel Barkalow <barkalow@iabervon.org>, Zan Lynx <zlynx@acm.org>,
       Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Message-id: <200801290951.55492.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200801272122.21823.gene.heskett@gmail.com>
 <479E1D9E.3000900@bobjweil.com> <20080129121201.2f727f5f@core>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008, Alan Cox wrote:
>> not one problem but lots---is sufficiently widespread that a Mini HOWTO,
>> say, would be really welcome and, I'm guessing, widely used.
>
>We don't see very many libata problems at the distro level and they for
>the most part boil down to
>
>- error messages looking different - Most bugs I get are things like
>media errors (timeout looks different, UNC report looks different)
>
>- broken hardware - I've closed a whole raft of bugs that turn out to be
>new PC systems where even the BIOS doesn't see the drives
>
>- faulty hardware being picked up because we actually do real error
>checking now. We now check for and give some devices more slack while
>still doing error checking. Both IDE layers also added blacklists for
>stuff like the TSScorp DVD drives. Qemu has now had its bugs patched.
>
>- sata_nv with >4GB of RAM, knowing being worked on, no old IDE driver
>anyway
>
>- pata_ali MWDMA with ATAPI, PIO works fine, all a bit of a mystery and
>as it affects only a few chip variants hard to figure out. Workaround
>libata.dma=1
>
>- CS handling. On a few boxes using cable select (particularly on one
>drive and not the other) shows up a problem, normally a failed SRST.
>That's still under investigation.
>
>- Promise timeouts. The old IDE times out then polls the device and finds
>the IRQ was never sent and then recovers so the user sees a short stall
>but no errors. The new libata doesn't do this and pdc202xx_old thus
>produces some error messages on some boxes. Backup polling is on my todo
>list.

As slight change here, I was going to use the same .config as 2.6.24-rc8, but 
just discovered that neither rc8 nor final is finding the drivers for my
dvd writer while using libata, so its not useable.  So I've enable a couple of 
things in the 2.6.24 build that aren't in the 2.6.24-rc8.  When I find the 
magic twanger, I'll rebuild -rc8 with it too.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
River: "He didn't lie down.  They never lie down."
				--"Serenity"
