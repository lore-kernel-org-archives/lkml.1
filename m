Return-Path: <linux-kernel-owner+w=401wt.eu-S932948AbXBEOvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948AbXBEOvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:51:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932971AbXBEOvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:51:04 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:62192 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522AbXBEOvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:51:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=OMBpVJcXB0dfjLyfBoMlEapZY6X6JiJzAWvMW5H1zJwgf93xWkM/0Xde4Avexts2gxTqPuakN/59brZVImE2KCcmBNICQBuspdS2Q2VCmMG9NH7mPVW9HivEcyxk+R7t3d1r51VUj+W5ndtVhlhBGt0vEyqFjjiIt7F74kKozo0=
Message-ID: <45C7444F.4070500@gmail.com>
Date: Mon, 05 Feb 2007 23:50:55 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Nvidia cable detection problems (was [PATCH] amd74xx: don't configure
 udma mode higher than BIOS did)
References: <20070205075836.GG1625@htj.dyndns.org>	<20070205112410.5a3c3182@localhost.localdomain>	<45C72012.7050605@gmail.com>	<20070205132247.6f611e3c@localhost.localdomain>	<45C73A3E.6080700@gmail.com> <20070205143439.6962c076@localhost.localdomain>
In-Reply-To: <20070205143439.6962c076@localhost.localdomain>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
[--snip--]
>> CK804 IDE, at least mine, reports 80c in a lot of cases where it
>> shouldn't.  I dunno the reason but it also makes drives confused about
>> cable type.  Maybe it has the wrong capacitor attached or something.
>> This is A8N-E from ASUS, probably one of the popular ones using nf4.
> 
> I take it this was how you came to find every cable related bug while
> trying to work out what was going on ?

Yeap, pretty much.  I thought fixing drive side cable detection would
fix it, but hell no.

>> When that happens, libata EH does its job and slows the interface to
>> udma33 after quite a few error messages.  On IDE, if this happens, the
>> drive is put into PIO mode making the machine painful to use.
> 
> No the IDE layer does DMA changedown fine, well apart from all the
> error/timer races in the old IDE code.

I dunno.  It always ended up in PIO mode in my case.  I can post the log
if necessary.

[--snip--]
>> I agree with you that this is a hack and ugly as hell.  I don't like it
>> either, but it solves an existing problem which could have and possibly
>> will hit many users.  So, I think this problem should at least be
>> verified.  If it's just my BIOS/motherboard that's crazy, I have no
>> problem forgetting about this.
> 
> It certainly seems to be Nvidia specific, so perhaps Nvidia can provide
> more details on the Nforce4 cable detection ? As with a lot of Nvidia
> stuff there was much reverse engineering involved in the original code
> base.

Hmmm... Anyone happen to have working nvidia contact?

> And if its a specific board or couple of boards then we should perhaps
> use DMI to match them specifically.
> 
>> So, anyone with CK804 (a.k.a NF4) up for some testing?
> 
> If it still goes I've got a rather iffy NF3 but not an NF4 handy.

Yeah, please.  If I connect a hdd at the end of 40c cable and leaving
the middle connector empty, the 80c bit is always one and the drive says
it's 80c cable while the BIOS configured mode is correctly udma33.  This
is the same for SAMSUNG SP0802N, Maxtor 91301U3 and HITACHI_DK23BA-20.

-- 
tejun
