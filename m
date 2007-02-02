Return-Path: <linux-kernel-owner+w=401wt.eu-S1946047AbXBBURg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946047AbXBBURg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 15:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946048AbXBBURf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 15:17:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57417 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946043AbXBBURe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 15:17:34 -0500
Message-ID: <45C39C37.8060201@torque.net>
Date: Fri, 02 Feb 2007 15:16:55 -0500
From: Douglas Gilbert <dougg@torque.net>
Reply-To: dougg@torque.net
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: Ric Wheeler <ric@emc.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Mark Lord <liml@rtr.ca>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
References: <200701301947.08478.liml@rtr.ca>	<1170206199.10890.13.camel@mulgrave.il.steeleye.com>	<45C2474E.9030306@rtr.ca>	<1170366920.3388.62.camel@mulgrave.il.steeleye.com>	<45C32C7F.9050706@emc.com> <20070202144211.5a2d2365@localhost.localdomain>
In-Reply-To: <20070202144211.5a2d2365@localhost.localdomain>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
>> The interesting point of this question is about the typically pattern of 
>> IO errors. On a read, it is safe to assume that you will have issues 
>> with some bounded numbers of adjacent sectors.
> 
> Which in theory you can get by asking the drive for the real sector size
> from the ATA7 info. (We ought to dig this out more as its relevant for
> partition layout too).
> 
>> I really like the idea of being able to set this kind of policy on a per 
>> drive instance since what you want here will change depending on what 
>> your system requirements are, what the system is trying to do (i.e., 
>> when trying to recover a failing but not dead yet disk, IO errors should 
>> be as quick as possible and we should choose an IO scheduler that does 
>> not combine IO's).
> 
> That seems to be arguing for a bounded "live" time including retry run
> time for a command. That's also more intuitive for real time work and for
> end user setup. "Either work or fail within n seconds"

Which is more or less the "streaming" feature set in recent
ATA standards. [Alas, streaming and NCQ/TCQ can't be done
with the same access.] SCSI has its Read Write Error Recovery
mode page which doesn't have timeouts but does have Read
and Write Retry Counts amongst other fields that control
the amount (and indirectly the time) of attempted error
recovery.

Doug Gilbert


