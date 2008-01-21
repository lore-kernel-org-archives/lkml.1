Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbYAURCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbYAURCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 12:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbYAURCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 12:02:37 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:3203 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbYAURCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 12:02:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=vTbcHGB4GbH3XrfUoz6kWTOaCKvHccj2Xjso2F84oVhkvbKKqE5CGHn2tYky/P8hrgt0Mm1ITl/C+CXF+E/gcgFM6EFD3VVnFlyTc44wtqbzRkNkrDfsS6hoM3bvTzbNsYuJdajTh+ZO3XCvlLbshKwyXmG+nbiVsptGDI7206I=
Message-ID: <4794D020.4060204@gmail.com>
Date: Tue, 22 Jan 2008 02:02:24 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Georgi Chulkov <g.chulkov@jacobs-university.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Mark Lord <liml@rtr.ca>
Subject: Re: ATA device reset, shoud I be concerned?
References: <200801140019.20668.g.chulkov@jacobs-university.de>	<20080115025435.1e21b703.akpm@linux-foundation.org>	<20080115113552.75731bf8@lxorguk.ukuu.org.uk>	<4794501E.90306@gmail.com>	<20080121130256.2443d7c1@lxorguk.ukuu.org.uk>	<47949AA4.9090601@gmail.com>	<20080121141425.45aa9c61@lxorguk.ukuu.org.uk>	<4794ACAF.70505@gmail.com> <20080121164744.2f7d0ed1@lxorguk.ukuu.org.uk>
In-Reply-To: <20080121164744.2f7d0ed1@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Can you elaborate a bit?  I don't really think completing a command
>> after 30sec timeout contributes a lot to driver stability.
> 
> Timeout, timeout, timeout, reset, timeout.. (repeat), failed I/O
> 
> This gives the end user no information about the fault, nor does it let
> the upper layers of SCSI and above distinguish between a random passing
> sulk and media errors which need the disk replacing.

I still don't think it's worth the trouble.  There's currently only one
reported device which forgets to raise IRQ on media error.  The behavior
is out of spec and rare.  I don't think it's a good idea to change EH
behavior for it.

>>> Should that not then be a per host flag ?
>> Yeah, that would be the best.  The problem is that there are several
>> different kinds of timeouts and we don't know which controller locks up
>> after which timeout and investigating them is really difficult.
> 
> PATA controllers don't lock up in that case so its quite easy. The one
> exception is if the device jams IORDY but in that case you are dead
> anyway the next I/O (except on a SIL680 which has a timer we could use).
> 
> Old IDE says it works for PATA. For SATA I can see it might need more
> care and you might simply not be able to get the info.

Old IDE often locks up the machine hard after timeouts.  I'm all for
gathering more info but benefit vs. risk equation just doesn't look good
here.  Why take risk for a rare device which forgets to raise IRQ on
media error?  If such behavior is wide spread among PATA drives && we
can verify that TF register access after timeout is safe for PATA
controllers, sure, but currently we aren't sure about either.

Thanks.

-- 
tejun
