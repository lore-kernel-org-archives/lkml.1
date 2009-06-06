Return-Path: <linux-kernel-owner+w=401wt.eu-S1752058AbZFFSRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbZFFSRN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 14:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbZFFSQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 14:16:58 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:48203 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbZFFSQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 14:16:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bEWzomFd6OsPcrynIiwa51gXXHwPuTHRWKMSWwg3LbD9E9gz/KjNpsHk7Gv3n60pVY
         mLwyZRccSuFT9uV03GjGUaTZtAiCXggzDI7OR/9TF86lvrDu8/7AF4CuyVJCLXzeNtqY
         0PF6otYbXuLWJt30KJpD+hgTrvKod/PMnRL6Y=
Message-ID: <4A2AB298.7020603@gmail.com>
Date: Sat, 06 Jun 2009 12:16:56 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Grozdan <neutrino8@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: Kernel 2.6.30rc7 limits IDE to UDMA33
References: <c5bd819b0906021525l13ee9282j1fb270e141985f66@mail.gmail.com>	<4A25F688.9000407@gmail.com>	<c5bd819b0906030435w466368cbsd48be91a97597437@mail.gmail.com>	<20090603131407.57c490ed@lxorguk.ukuu.org.uk>	<c5bd819b0906030552w6f23185etb394f83c8b630e6@mail.gmail.com>	<20090603140140.491a8ea8@lxorguk.ukuu.org.uk>	<c5bd819b0906030639o5f9c34ffg500e132d3a0b5117@mail.gmail.com>	<c5bd819b0906040750w75e0389cod2a03b89ce838d1b@mail.gmail.com>	<20090605100505.41b3b818@lxorguk.ukuu.org.uk>	<c5bd819b0906050335i4e813887sc8f4d901da86a1aa@mail.gmail.com>	<20090605114245.175499e1@lxorguk.ukuu.org.uk>	<4A29C163.3080706@gmail.com> <20090606155636.18bc4f2e@lxorguk.ukuu.org.uk>
In-Reply-To: <20090606155636.18bc4f2e@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> I wouldn't rule out the possibility of a bug. The code in pata_via looks 
>> a bit fishy, it reports a 40-wire cable if either the GTM data wasn't 
>> present or valid, or if it reports a mode of UDMA2 or less. In the 
>> former case it seems like ATA_CABLE_PATA_UNK would be the safer choice 
>> since we really don't know, and we should then use drive-side detection, 
>> rather than assuming a 40-wire cable by default..
> 
> Drive side detection doesn't work for many VIA boards, the neccessary
> components are not included.

Ugh, seems they messed this stuff up as bad as NVIDIA did..

> 
> About the only other check I can think to try is to see if the BIOS
> programmed modes > UDMA2 for either device. That has its own problems
> (suspend-resume/hotplug/non-bios devices) which is why we currently don't
> do it.

Well, that's pretty much the same thing that GTM does (it generally just 
reads the configured mode out of the controller registers). So it really 
wouldn't be much worse than what we're doing now.

Thing is somehow the GTM detection isn't working now and it apparently 
was in 2.6.27.1. I'm not seeing any patches to pata_via or libata-acpi 
that seem like they would affect this offhand. Grozdan, would you be 
able to try git bisect to try to figure out what changed the behavior?

CCing Tejun in case he has any ideas..
