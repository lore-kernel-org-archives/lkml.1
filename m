Return-Path: <linux-kernel-owner+w=401wt.eu-S1758792AbYC0KAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbYC0KAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 06:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbYC0KAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 06:00:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:12187 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbYC0KAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 06:00:37 -0400
Subject: Re: DMA not working on SATA?
From: Alex Bennee <kernel-hacker@bennee.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47EB2E92.9060401@shaw.ca>
References: <fa.tM6egqVO3jg78PMZEi2Ne7NkjtI@ifi.uio.no>
	 <47EB2E92.9060401@shaw.ca>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 10:00:34 +0000
Message-Id: <1206612034.24437.5.camel@pitcairn.cambridgebroadband.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-26 at 23:20 -0600, Robert Hancock wrote:
> Alex Bennee wrote:
> > Hi,
> > 
> > Since I got my new machine I noticed it seemed to be running slower than
> > I expected for a duel core machine including a lot of stuttering. After
> > tweaking the BIOS settings from "Legacy" to "AHCI" I measured a doubling
> > of read performance with hdparm but heavy IO still makes the machine
> > sluggish, with top showing ~80% of the time in the wait state (and
> > loadavg shooting up). This seems like a DMA problem because I was under
> > the impression a task demanding IO should be able to sleep on a DMA
> > completion rather than blocking everything else.
> 
> That's not what IOwait means. It basically means "nothing better to do 
> than wait for IO to complete". If you have only one running task which 
> is blocked waiting for IO you will always have high IOwait.

So if my loadavg shoots up at the same time (indicating more than one
task wanting to run) does that infer that most of my tasks are IO
starved and waiting for the disk to catch up with them?

The main problem is I'm not sure if my disk subsystem is running as fast
as it should be. What sort of data rates should I be seeing from a
modern SATA type setup?

As Alan pointed out (and I missed) the dmesg shows DMA is enabled, it's
just hdparam doesn't seem to be able to infer the fact (new IOTCLS for
newer disk systems?).

I could be I've already peaked in my performance and I'm just making
unrealistic demands on memory usage (I have been running cvsps after
all ;-).

-- 
Alex, homepage: http://www.bennee.com/~alex/
Debian is the Jedi operating system: "Always two there are, a master and
an apprentice". -- Simon Richter on debian-devel

