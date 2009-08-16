Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbZHPRI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbZHPRI6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 13:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbZHPRI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 13:08:58 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:22665 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbZHPRI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 13:08:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UxxFiuDtUQI0OnM/pUN9H2Rgh/75AXLR3bwDnwxpiJhcEofaON1fgT152weRX3L/QU
         tzxldEQcuV2aYCni5yysqIRewjuFlFOH8Uru2+bjs+ncS65W1O+KfhdkzTAoce/BqxlJ
         JaZokQA1/9BFubwk4vs4cXNH31GRcXcqnuJn0=
Message-ID: <4A883D21.5020209@gmail.com>
Date: Sun, 16 Aug 2009 11:08:49 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: jim owens <jowens@hp.com>
CC: James Bottomley <James.Bottomley@suse.de>, Mark Lord <liml@rtr.ca>,
       Chris Worley <worleys@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Bryan Donlan <bdonlan@gmail.com>, david@lang.hm,
       Greg Freemyer <greg.freemyer@gmail.com>,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Matthew Wilcox <willy@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
   slot is freed)
References: <200908122007.43522.ngupta@vflare.org>	 <20090813151312.GA13559@linux.intel.com>	 <20090813162621.GB1915@phenom2.trippelsdorf.de>	 <alpine.DEB.1.10.0908130931400.28013@asgard.lang.hm>	 <87f94c370908131115r680a7523w3cdbc78b9e82373c@mail.gmail.com>	 <alpine.DEB.1.10.0908131342460.28013@asgard.lang.hm>	 <3e8340490908131354q167840fcv124ec56c92bbb830@mail.gmail.com>	 <4A85E0DC.9040101@rtr.ca>	 <f3177b9e0908141621j15ea96c0s26124d03fc2b0acf@mail.gmail.com>	 <20090814234539.GE27148@parisc-linux.org>	 <f3177b9e0908141719s658dc79eye92ab46558a97260@mail.gmail.com>	 <1250341176.4159.2.camel@mulgrave.site>  <4A86B69C.7090001@rtr.ca> <1250344518.4159.4.camel@mulgrave.site> <4A86F2E1.8080002@hp.com>
In-Reply-To: <4A86F2E1.8080002@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2009 11:39 AM, jim owens wrote:
> ***begin rant***
>
> I have not seen any analysis of the benefit and cost to the
> end user of the TRIM or array UNMAP. We now see that TRIM
> as implemented by some (all?) SSDs will come at high cost.
> The cost is all born by the host. Do we get any benefit, or
> is it all for the device vendor. And when we subtract the cost
> from the benefit, does the user actually benefit and how?
>
> I'm tired of working around shit storage products and broken
> device protocols from the "T" committees. I suggest we just
> add a "white list" of devices that handle the discard fast
> and without us needing NCQ queue drain. Then only send TRIM
> to devices that are on the white list and throw the others
> away in the block device layer.

They all will require NCQ queue drain. It's an inherent requirement of 
the protocol that you can't overlap NCQ and non-NCQ commands, and the 
trim command is not NCQ.
