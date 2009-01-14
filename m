Return-Path: <linux-kernel-owner+w=401wt.eu-S1760235AbZANVvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760235AbZANVvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbZANVve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:51:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33402 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbZANVvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:51:33 -0500
Message-ID: <496E5DB8.1030007@sandeen.net>
Date: Wed, 14 Jan 2009 15:48:40 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: chris.mason@oracle.com, handygewinnspiel@gmx.de, matthew@wil.cx,
       rjw@sisk.pl, HWerner4@gmx.de, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mchehab@infradead.org, stable@kernel.org,
       Christoph Hellwig <hch@lst.de>, Lachlan McIlroy <lachlan@sgi.com>,
       xfs mailing list <xfs@oss.sgi.com>
Subject: Re: [linux-dvb] compiling on 2.6.28 broken?
References: <20090112190420.51f75853@pedra.chehab.org>	<20090112132130.6c932b85.akpm@linux-foundation.org>	<20090112220624.4fbfee34@pedra.chehab.org>	<20090112162337.318dd61d.akpm@linux-foundation.org>	<20090113184755.87720@gmx.net>	<20090113105947.9e774b69.akpm@linux-foundation.org>	<20090113191757.74290@gmx.net>	<20090113113700.776a94b5.akpm@linux-foundation.org>	<20090113203843.GJ29283@parisc-linux.org>	<1231957750.8269.28.camel@think.oraclecorp.com>	<496E56EB.2030301@gmx.de>	<1231968240.8269.48.camel@think.oraclecorp.com>	<496E5AB2.7040507@sandeen.net> <20090114134417.e6b29b52.akpm@linux-foundation.org>
In-Reply-To: <20090114134417.e6b29b52.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 14 Jan 2009 15:35:46 -0600
> Eric Sandeen <sandeen@sandeen.net> wrote:
> 
>> Chris Mason wrote:
>>> On Wed, 2009-01-14 at 22:19 +0100, wk wrote:
>> ...
>>>> I cannot fully understand what strace -v outputs (see attachment), but 
>>>> what i see is that 'find' stops after finding a file with d_off = 4294967295
>>>> 4294967295  =  0xFFFFFFFF, adding any number greater that zero will be 
>>>> greater that 32bits, so this could be the reason for the message "value 
>>>> too large".
>>>>
>>>>
>>>>
>>>> I also noticed that i cannot access these files through samba if i boot 
>>>> from 2.6.28 - really strange.
>>>> If i reboot older kernels these are visible in samba again and fully 
>>>> accessible.
>>>>
>>>> Attached the log from stracing the command which was ivoked by the 
>>>> Makefile from v4l-dvb.
>>>> I guess this is all i could contribute to that problem. Thats stuff for 
>>>> xfs filesystem experts now..
>>> Seems suspect indeed.  Could you please attach the strace for the run
>>> that works on the older kernel?
>> Chris got my attention on this one; you probably want this fix from hch:
>>
>> http://oss.sgi.com/archives/xfs/2009-01/msg00158.html
>>
> 
> Looks likely.  It is below, for anyone who would like to test it.
> 
> 
> It is in linux-next.  Guys, do we plan to merge this into 2.6.29?

It should be merged there, yes.  Was hoping that sgi would request that
soon....

> (cc's stable@kernel.org)
> 
> This patch applies OK to 2.6.27 and 2.6.28.  Is it also needed there? 
> If so, it should have had "Cc: <stable@kernel.org>" in the changelog so
> that it doesn't get lost.
> 

It is needed for .28, but should not be needed for .27 AFAIK.

-Eric
