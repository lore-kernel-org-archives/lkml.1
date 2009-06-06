Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbZFFBH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbZFFBH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 21:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbZFFBHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 21:07:50 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:8465 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbZFFBHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 21:07:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Q3lBjKyxU34zmLJcln6yOFWDEbn21HOBj90hV53jXXvxMbBjbU4dP/+OYbSVfa6Yg+
         4WTT2y/bDOYcVXGFzyMFv0fveL+IMikaRm73v6NLE53LuETVEPcXqvbcXdhwNen110sC
         5Dp7Po2L1w0zBlSIdW7VJnG604A7cORH49FQ4=
Message-ID: <4A29C163.3080706@gmail.com>
Date: Fri, 05 Jun 2009 19:07:47 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Grozdan <neutrino8@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Kernel 2.6.30rc7 limits IDE to UDMA33
References: <c5bd819b0906021525l13ee9282j1fb270e141985f66@mail.gmail.com>	<4A25F688.9000407@gmail.com>	<c5bd819b0906030435w466368cbsd48be91a97597437@mail.gmail.com>	<20090603131407.57c490ed@lxorguk.ukuu.org.uk>	<c5bd819b0906030552w6f23185etb394f83c8b630e6@mail.gmail.com>	<20090603140140.491a8ea8@lxorguk.ukuu.org.uk>	<c5bd819b0906030639o5f9c34ffg500e132d3a0b5117@mail.gmail.com>	<c5bd819b0906040750w75e0389cod2a03b89ce838d1b@mail.gmail.com>	<20090605100505.41b3b818@lxorguk.ukuu.org.uk>	<c5bd819b0906050335i4e813887sc8f4d901da86a1aa@mail.gmail.com> <20090605114245.175499e1@lxorguk.ukuu.org.uk>
In-Reply-To: <20090605114245.175499e1@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> I've relayed your reply to the pata_amd user on the forum. As for my
>> case with pata_via, until this is fixed, is there any way to force it
>> to use a higher UDMA? Is there a flag that can be passed in, for
> 
> In your case given the BIOS appears to be informing us you have a 40wire
> cable there isn't much that can be fixed
> 
>> example, in /sys somewhere? hdparm fails to set a higher UDMA and I
>> looked at sdparm but don't see anything in it to increase UDMA...
> 
> Tejun some time ago added stuff to override all of these things:
> 
> See Documentation/kernel-parameters.txt
> 
> 	libata.force=
> 
> which will let you override all sorts of autodetection for quirky boards

I wouldn't rule out the possibility of a bug. The code in pata_via looks 
a bit fishy, it reports a 40-wire cable if either the GTM data wasn't 
present or valid, or if it reports a mode of UDMA2 or less. In the 
former case it seems like ATA_CABLE_PATA_UNK would be the safer choice 
since we really don't know, and we should then use drive-side detection, 
rather than assuming a 40-wire cable by default..
