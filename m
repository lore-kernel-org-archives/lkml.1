Return-Path: <linux-kernel-owner+w=401wt.eu-S1764095AbXEZU5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764095AbXEZU5O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 16:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755777AbXEZU46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 16:56:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36035 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbXEZU45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 16:56:57 -0400
Message-ID: <46589F15.8080003@garzik.org>
Date: Sat, 26 May 2007 16:56:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: dean gaudet <dean@arctic.org>, Dave Dillow <dave@thedillows.org>
CC: linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFT, v4] sata_mv: convert to new EH
References: <20070225233454.GA31282@havoc.gtf.org>  <1173158201.3416.8.camel@obelisk.thedillows.org>  <45ED039E.20608@garzik.org> <1173164261.3416.15.camel@obelisk.thedillows.org> <4656EB26.40504@garzik.org> <4657A678.8090308@garzik.org> <Pine.LNX.4.64.0705252335590.8327@twinlark.arctic.org>
In-Reply-To: <Pine.LNX.4.64.0705252335590.8327@twinlark.arctic.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

dean gaudet wrote:
> On Fri, 25 May 2007, Jeff Garzik wrote:
> 
>> Already uncovered and fixed a few bugs in v3.
>>
>> Here's v4 of the sata_mv new-EH patch.
> 
> you asked for test results with 2.6.21.3 ... that seems to boot fine,
> and i've tested reading from the disks only and it seems to be working
> fine.  ditto for 2.6.22-rc3.
> 
> but 2.6.22-rc3 + your v4 patch fails... i'll send you the serial console
> outputs offline.

Well, I have the same hardware as dean, and do not see the 
BUG_ON/WARN_ON traces that he sees.  These are the same two code 
locations that caused spewage before.  This only difference I see is 
that he is testing with an NCQ-capable disk, and I am not -- which could 
be a very significant difference.  Dave also appears to have an 
NCQ-capable disk.

Dave's output (sent privately to me) was different -- errors and 
corruption -- rather than the BUG_ON/WARN_ON stuff both he and dean sent 
in March 2007, which is interesting.

Dave, any chance you could try 2.6.22-rc3 + my v4 patch, on a different 
hard drive?  Preferably a non-Maxtor, or at least not another Maxtor 
6L200S0.  If that's a big deal, don't worry about it.  I just want to 
rule out buggy firmware and/or bad hard drive in your case.

dean's output (backtraces matching March 2007 reports) was what I 
expected, and if I can reproduce that with an NCQ-capable disk locally, 
I should be able to fix it from there without trouble.  Probably just 
some hardware bits accidentally kicking into NCQ mode, when they should not.

	Jeff





