Return-Path: <linux-kernel-owner+w=401wt.eu-S1750699AbXCEWKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750699AbXCEWKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbXCEWKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:10:13 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:28666 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbXCEWKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:10:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=EhZcUmlxiC6mIdTO4gIYrBCGbLGGfxpKo6SgTh8ko42k1y/6vYQG1NnOu9Nca5A1LlUU9omobWboavJ/xBxCcorySHYxgedmIpKmZQcZQ+rZ3b/ztSVpuyQi9NczBX0tMGeIo4JEZ8vl0oMqaV0cZp2gNwswhQBfvF/sULGOtsQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Trouble using some (fast) compact flash as ide device on an embedded system
Date: Mon, 5 Mar 2007 23:16:50 +0100
User-Agent: KMail/1.9.6
Cc: Marco Lazzarotto <m.lazzarotto@robox.it>, linux-kernel@vger.kernel.org
References: <45E6D7EB.5080501@robox.it> <20070302195650.GA5697@ucw.cz>
In-Reply-To: <20070302195650.GA5697@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703052316.50257.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 02 March 2007, Pavel Machek wrote:
> Hi!
> 
> > As I reported in bug 8036 in bugzilla.kernel.org,
> > 
> > Hardware Environment:
> > 
> >  - Use a compact flash SanDisk SDCFB-128 Firmware revision HDX 2.15
> >    (we used other compact flashes with the same hw ad sw for years
> >     with  no trouble)
> > 
> > It happens on both etx boards:
> >  - VIA SOM-ETX (4475)
> >  - Gene-4312
> > 
> > Doing the command
> > sfdisk -R /dev/hdc
> > 
> > gives:
> > 
> >  * * *
> > ide1: start_request: current=0xc6ebe754 (rq->sect=0,block 0)
> > hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> > ide: failed opcode was: unknown
> > hdc: drive not ready for command
> > ide1: start_request: current=0xc6ebe754 (rq->sect=0,block 0)
> > hdc: do_special: 0x02
> > hdc: do_special: recalibrate
> > ide1: start_request: current=0xc6ebe754 (rq->sect=0,block 0)
> > hdc: reading: block=0 sectors=8, buffer = 0xc6cd40000
> > ide1: end_request: current=0xc6ebe754
> >  * * *
> > 
> > the 'bad bit' in status error is DataRequest
> > 
> > 
> > 
> > doing
> > sfdisk -l /dev/hdc
> > 
> > gives:
> > 
> >  * * *
> > ide1: start_request: current=0xc6ebecd4 (rq->sect=0,block 0)
> > hdc: reading: block=0, sectors=32, buffer=0xc6f37000
> > hdc: lost interrupt
> > hdc: lost interrupt [and so on several times]
> >  * * *
> > 
> > I have no knowledge of the internals of the linux kernel, but I'm a
> > programmer and have both hardware and time to spend on solving this issue.
> 
> Debug it, then :-). Try limiting its speed with hdparm to see if it
> helps.

I would suggest trying booting with "ide=nodma" first.

Should help if this is CF adapter without DMA support with DMA capable CF.
[ Hmm, this should be in the documentation somewhere but actually isn't. ]

Thanks,
Bart
