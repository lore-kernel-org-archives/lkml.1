Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbYC0Rpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbYC0Rpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 13:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbYC0Rpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 13:45:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:10985 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbYC0Rpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 13:45:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=VP2OcX87pcpITN3UYfDhhR6i+JKdwryAKLOLIRQNAaqSTD26QjZzUkYUWjEepgPB2O3zvR2YBey21/cb+qZ++juRQwGSB7PabFxHSuEmNayz2Bsk9w+vKknCCnUUimf5XWyyXKKKDsM7+n5p+Y4db7O/e6amcq0UlWwqLkqafMs=
Message-ID: <47EBDD26.3030303@gmail.com>
Date: Thu, 27 Mar 2008 12:45:10 -0500
From: Roger Heflin <rogerheflin@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alex Bennee <kernel-hacker@bennee.com>
CC: Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: DMA not working on SATA?
References: <fa.tM6egqVO3jg78PMZEi2Ne7NkjtI@ifi.uio.no>	 <47EB2E92.9060401@shaw.ca> <1206612034.24437.5.camel@pitcairn.cambridgebroadband.com>
In-Reply-To: <1206612034.24437.5.camel@pitcairn.cambridgebroadband.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Bennee wrote:
> On Wed, 2008-03-26 at 23:20 -0600, Robert Hancock wrote:
>> Alex Bennee wrote:
>>> Hi,
>>>
>>> Since I got my new machine I noticed it seemed to be running slower than
>>> I expected for a duel core machine including a lot of stuttering. After
>>> tweaking the BIOS settings from "Legacy" to "AHCI" I measured a doubling
>>> of read performance with hdparm but heavy IO still makes the machine
>>> sluggish, with top showing ~80% of the time in the wait state (and
>>> loadavg shooting up). This seems like a DMA problem because I was under
>>> the impression a task demanding IO should be able to sleep on a DMA
>>> completion rather than blocking everything else.
>> That's not what IOwait means. It basically means "nothing better to do 
>> than wait for IO to complete". If you have only one running task which 
>> is blocked waiting for IO you will always have high IOwait.
> 
> So if my loadavg shoots up at the same time (indicating more than one
> task wanting to run) does that infer that most of my tasks are IO
> starved and waiting for the disk to catch up with them?
> 
> The main problem is I'm not sure if my disk subsystem is running as fast
> as it should be. What sort of data rates should I be seeing from a
> modern SATA type setup?

50-70MB/second per disk, if you are doing single sequential reads/writes (alone, 
not together-if you are doing both at the same time or more than one at the sime 
time it will be worse), if you are doing a lot of seeks it can be pretty much 
any number below that.    The smaller the pieces of data that are being sent to 
disk, the worse things will be.   The speed is dependent mostly on the type of 
disk, each disk has a underlying inside/outside platter bits per second, and 
that is the limit that you won't ever exceed.

> 
> As Alan pointed out (and I missed) the dmesg shows DMA is enabled, it's
> just hdparam doesn't seem to be able to infer the fact (new IOTCLS for
> newer disk systems?).
> 
> I could be I've already peaked in my performance and I'm just making
> unrealistic demands on memory usage (I have been running cvsps after
> all ;-).
> 

